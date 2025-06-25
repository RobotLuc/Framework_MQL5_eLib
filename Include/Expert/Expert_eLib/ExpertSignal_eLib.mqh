//+------------------------------------------------------------------+
//|                                          ExpertSignal_eLib.mqh   |
//|                                     Copyright 2025, Lucas TRONCY |
//+------------------------------------------------------------------+
#ifndef __EXPERT_SIGNAL_LIB_MQH__
#define __EXPERT_SIGNAL_LIB_MQH__

#include <Expert/ExpertSignal.mqh>
#include <Expert/Utils/UtilsLTR.mqh>

//+------------------------------------------------------------------+
//|                                           ExpertSignal_eLib.mqh  |
//|    Extension propre de la classe CExpertSignal (MetaQuotes)      |
//|    Ajouts : FiltersTotal(), IgnoreLastFilter(),                  |
//|            surcharge de Direction(), ajout de SignalMinPeriod()  |
//+------------------------------------------------------------------+
class CExpertSignal_eLib : public CExpertSignal
  {
public:
                     CExpertSignal_eLib(void);
                    ~CExpertSignal_eLib(void);

   // Ajouts
   int               FiltersTotal(void) const;
   long              Ignore(void) const;

   // Redéfinitions
   virtual double    Direction(void) override;
   virtual ENUM_TIMEFRAMES SignalMinPeriod(void);

   // Méthode utilitaire
   void              IgnoreLastFilter(void);
  };

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CExpertSignal_eLib::CExpertSignal_eLib(void) : CExpertSignal()
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CExpertSignal_eLib::~CExpertSignal_eLib(void)
  {
  }
//+------------------------------------------------------------------+
//| Nombre de filtres                                                |
//+------------------------------------------------------------------+
int CExpertSignal_eLib::FiltersTotal(void) const
  {
   return m_filters.Total();
  }
//+------------------------------------------------------------------+
//| Masque de filtres ignorés                                        |
//+------------------------------------------------------------------+
long CExpertSignal_eLib::Ignore(void) const
  {
   return m_ignore;
  }
//+------------------------------------------------------------------+
//| Calcul de la direction pondérée (surcharge avec log)            |
//+------------------------------------------------------------------+
double CExpertSignal_eLib::Direction(void)
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

      CExpertSignal_eLib *filter = m_filters.At(i);
      if(filter == NULL)
         continue;

      direction = filter.Direction();
      if(direction == EMPTY_VALUE)
         return EMPTY_VALUE;

      if((m_invert & mask) != 0)
         result -= direction;
      else
         result += direction;

      number++;
     }

   if(number != 0)
      result /= number;

   if(result != 0)
      CUtilsLTR::LogToDesktop(StringFormat("Résultat du vote pondéré : %f", result));

   return result;
  }
//+------------------------------------------------------------------+
//| Détection de la plus petite timeframe utilisée                   |
//+------------------------------------------------------------------+
ENUM_TIMEFRAMES CExpertSignal_eLib::SignalMinPeriod(void)
  {
   ENUM_TIMEFRAMES min_period = WRONG_VALUE;
   if(m_has_tf_significance)
      min_period = GetPeriod();

   int total = m_filters.Total();
   for(int i = 0; i < total; i++)
     {
      CExpertSignal_eLib *filter = m_filters.At(i);
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
//| Ignore le dernier filtre ajouté                                  |
//+------------------------------------------------------------------+
void CExpertSignal_eLib::IgnoreLastFilter(void)
  {
   int total = m_filters.Total();
   if(total == 0)
      return;
   long mask = ((long)1) << (total - 1);
   m_ignore |= mask;
  }

#endif // __EXPERT_SIGNAL_LIB_MQH__
//+------------------------------------------------------------------+
