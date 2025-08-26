//+------------------------------------------------------------------+
//|                                          ExpertSignalMultiP.mqh   |
//|                                     Copyright 2025, Lucas TRONCY |
//+------------------------------------------------------------------+
#ifndef __EXPERT_SIGNAL_LIB_MQH__
#define __EXPERT_SIGNAL_LIB_MQH__

#include <Expert/ExpertSignal.mqh>
//#include <Expert/Utils/UtilsLTR.mqh>

//+------------------------------------------------------------------+
//|                                           ExpertSignalMultiP.mqh  |
//|    Extension propre de la classe CExpertSignal (MetaQuotes)      |
//|    Ajouts : FiltersTotal(), IgnoreLastFilter(),                  |
//|            surcharge de Direction(), ajout de SignalMinPeriod()  |
//+------------------------------------------------------------------+
class CExpertSignalMultiP : public CExpertSignal
  {
public:
                     CExpertSignalMultiP(void);
                    ~CExpertSignalMultiP(void);

   // Ajouts
   int               FiltersTotal(void) const;
   long              Ignore(void) const;

   // Redéfinitions
   virtual double    Direction(void) override;
   virtual ENUM_TIMEFRAMES SignalMinPeriod(void);
   virtual ENUM_TIMEFRAMES SignalGCDPeriod(void);

   // Méthodes utilitaires
   void           IgnoreLastFilter(void);
   int            FiltersTotal()               { return m_filters.Total(); }
   CExpertSignal* FilterAt(const int index)    { return m_filters.At(index); }
   int            GetExpiration()              { return m_expiration;        }

protected:
   static const double PASS_VALUE;
  };
const double CExpertSignalMultiP::PASS_VALUE = -DBL_MAX;
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CExpertSignalMultiP::CExpertSignalMultiP(void) : CExpertSignal()
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CExpertSignalMultiP::~CExpertSignalMultiP(void)
  {
  }
//+------------------------------------------------------------------+
//| Nombre de filtres                                                |
//+------------------------------------------------------------------+
int CExpertSignalMultiP::FiltersTotal(void) const
  {
   return m_filters.Total();
  }
//+------------------------------------------------------------------+
//| Masque de filtres ignorés                                        |
//+------------------------------------------------------------------+
long CExpertSignalMultiP::Ignore(void) const
  {
   return m_ignore;
  }
//+------------------------------------------------------------------+
//| Calcul de la direction pondérée (surcharge avec skip transparent)|
//+------------------------------------------------------------------+
double CExpertSignalMultiP::Direction(void)
  {
   long   mask;
   double direction;
   double result = m_weight * (LongCondition() - ShortCondition());
   int    number = (result == 0.0 ? 0 : 1);

   int total = m_filters.Total();
   for(int i = 0; i < total; i++)
     {
      mask = ((long)1) << i;
      if((m_ignore & mask) != 0)
         continue;

      CExpertSignal *filter = m_filters.At(i); // On utilise le polymorphisme pour appeler un pointer vers CExpertSignal ou CExpertSignalMultiP
      if(filter == NULL)
         continue;

      direction = filter.Direction();

      if(direction == EMPTY_VALUE)
        {
         PrintFormat("[MultiP] Filter %d cancel vote (EMPTY_VALUE).", i);
         return EMPTY_VALUE;
        }

      // Skip transparent (charon)
      if(direction == CExpertSignalMultiP::PASS_VALUE)
        {
         PrintFormat("[MultiP] Filter %d skipped (PASS_VALUE).", i);
         continue;
        }
      if((m_invert & mask) != 0)
         result -= direction;
      else
         result += direction;

      number++;
     }

   if(number != 0)
      result /= number;

   if(result != 0)
      PrintFormat("[MultiP] Résultat du vote pondéré : %f", result);

   return result;
  }
//+------------------------------------------------------------------+
//| Détection de la plus petite timeframe utilisée                   |
//+------------------------------------------------------------------+
ENUM_TIMEFRAMES CExpertSignalMultiP::SignalMinPeriod(void)
  {
   ENUM_TIMEFRAMES min_period = WRONG_VALUE;
   if(m_has_tf_significance)
      min_period = GetPeriod();

   int total = m_filters.Total();
   for(int i = 0; i < total; i++)
     {
      CExpertSignalMultiP *filter = m_filters.At(i);
      if(filter == NULL || !filter.HasTimeframeSignificance())
         continue;

      ENUM_TIMEFRAMES filter_period = filter.SignalMinPeriod();
      if(filter_period == WRONG_VALUE)
         continue;

      if(min_period == WRONG_VALUE || filter_period < min_period)
         min_period = filter_period;
     }
   return min_period;
  }
//+------------------------------------------------------------------+
//| Calcule le PGCD des périodes de tous les filtres (récursif)     |
//+------------------------------------------------------------------+
ENUM_TIMEFRAMES CExpertSignalMultiP::SignalGCDPeriod(void)
  {
   int gcd_minutes = 0;

// Inclure la période locale si significative
   if(m_has_tf_significance)
      gcd_minutes = CUtilsLTR::TimeframeToMinutes(GetPeriod());

   int total = m_filters.Total();
   for(int i = 0; i < total; i++)
     {
      CExpertSignalMultiP *filter = m_filters.At(i);
      if(filter == NULL || !filter.HasTimeframeSignificance())
         continue;

      ENUM_TIMEFRAMES tf = filter.SignalGCDPeriod(); // récursivité
      if(tf == WRONG_VALUE)
         continue;

      int period_minutes = CUtilsLTR::TimeframeToMinutes(tf);
      if(period_minutes <= 0)
        {
         PrintFormat("[WARNING] Période invalide détectée (%d min), saut du filtre.", period_minutes);
         continue;
        }

      if(gcd_minutes == 0)
         gcd_minutes = period_minutes;
      else
         gcd_minutes = CUtilsLTR::GCD(gcd_minutes, period_minutes);
     }

   return CUtilsLTR::MinutesToTimeframe(gcd_minutes);
  }
//+------------------------------------------------------------------+
//| Ignore le dernier filtre ajouté                                  |
//+------------------------------------------------------------------+
void CExpertSignalMultiP::IgnoreLastFilter(void)
  {
   int total = m_filters.Total();
   if(total == 0)
      return;
   long mask = ((long)1) << (total - 1);
   m_ignore |= mask;
  }

#endif // __EXPERT_SIGNAL_LIB_MQH__
//+------------------------------------------------------------------+
