//+------------------------------------------------------------------+
// Titre du fichier : SignalRSI_ES_eLib.mqh
// Contenu du fichier :
//   * type : Classe MQL5
//   * nom : CSignalRSI_ES_eLib
//   * dérive de : SignalRSI_eLib
//+------------------------------------------------------------------+
//| Include                                                          |
#include <Expert\Expert_eLib\Signal\SignalRSI_eLib.mqh>
//+------------------------------------------------------------------+
//| Declaration                                                      |
class CSignalRSI_ES_eLib : public CSignalRSI_eLib
  {
protected:
   double            m_seuilmaxES;      // Le seuil max au dessus duquel se déclenche l'AU
   double            m_seuilminES;      // Le seuil min en dessous duquel se déclenche l'AU
   bool              m_emergency_stop;  // Si true : act as prohibition of entry depending on oversold or overbought situation of RSI. Void all patterns

public:
                     CSignalRSI_ES_eLib(void);
                    ~CSignalRSI_ES_eLib(void);
   //--- methods of setting adjustable parameters
   void              SeuilMaxES(double value)       { m_seuilmaxES=value;          }
   void              SeuilMinES(double value)       { m_seuilminES=value;          }
   void              EmergencyStop(bool value)      { m_emergency_stop = value;    }

   //--- method of verification of settings
   virtual bool      ValidationSettings(void)   override;
   //--- methods of checking if the market models are formed
   virtual int       LongCondition(void)  override;
   virtual int       ShortCondition(void) override;
   virtual double    Direction(void)      override;
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CSignalRSI_ES_eLib::CSignalRSI_ES_eLib(void) :
   m_seuilmaxES(70),
   m_seuilminES(30),
   m_emergency_stop(false)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CSignalRSI_ES_eLib::~CSignalRSI_ES_eLib(void)
  {
  }
//+------------------------------------------------------------------+
//| Validation settings protected data.                              |
//+------------------------------------------------------------------+
bool CSignalRSI_ES_eLib::ValidationSettings(void)
  {
// 1) Interdiction stricte des filtres
   const int total = m_filters.Total();
   if(total > 0)
     {
      PrintFormat("%s: filtering EmergencyStop signal is forbidden. EA aborted.", __FUNCTION__);
      return false;
     }

// 2) Validation générique de la chaîne Expert (poids, buffers, etc.)
   if(!CExpertSignal::ValidationSettings())
      return false;

// 3) Mini-vérif RSI indispensable (puisque tu utilises RSI())
   if(m_periodRSI <= 0)
     {
      PrintFormat("%s: periodRSI must be > 0", __FUNCTION__);
      return false;
     }

// 4) Seuils AU spécifiques
   if(m_seuilmaxES>=100 || m_seuilminES>=100 || m_seuilmaxES<0 || m_seuilminES<0)
     {
      PrintFormat("%s: ES thresholds must be in [0;100[", __FUNCTION__);
      return false;
     }
   if(m_seuilmaxES <= m_seuilminES)
     {
      PrintFormat("%s: ES max must be > min", __FUNCTION__);
      return false;
     }

   return true;
  }
//+------------------------------------------------------------------+
//| "Voting" that price will grow.                                   |
//+------------------------------------------------------------------+
int CSignalRSI_ES_eLib::LongCondition(void)
  {
   return(0);
  }
//+------------------------------------------------------------------+
//| "Voting" that price will fall.                                   |
//+------------------------------------------------------------------+
int CSignalRSI_ES_eLib::ShortCondition(void)
  {
   return(0);
  }
//+------------------------------------------------------------------+
//| Overriding Direction                                             |
//+------------------------------------------------------------------+
double CSignalRSI_ES_eLib::Direction(void)
  {
   int idx   =StartIndex();
   if(idx < 0)
      return EMPTY_VALUE;
   double rsi_val = RSI(idx);

// Vérification de sécurité si rsi_val est vide :
   if(rsi_val == EMPTY_VALUE)
      return EMPTY_VALUE;   // ignore si tampon pas prêt

// Si le RSI est en mode AU, tester la condition
   if(m_emergency_stop)
     {
      bool stop = (rsi_val >= m_seuilmaxES || rsi_val <= m_seuilminES);
      if(stop)
         return EMPTY_VALUE;
     }
   return PASS_VALUE;
  }
//+------------------------------------------------------------------+
// Fin du fichier SignalRSI_ES_eLib.mqh
