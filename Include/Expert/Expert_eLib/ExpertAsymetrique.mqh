//+------------------------------------------------------------------+
// Titre du fichier : ExpertAsymetrique.mqh                          |
// Contenu du fichier :                                              |
//   * type : Classe MQL5                                            |
//   * nom : ExpertAsymetrique                                       |
//   * dérive de : CExpert                                           |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024-2025, Lucas Troncy"
#include <Expert\Expert.mqh>
#include <Expert\Expert_eLib\ExpertSignalMultiP.mqh>
#include <Expert\ExpertMoney.mqh>
#include <Expert\ExpertTrailing.mqh>
#include <Expert\ExpertTrade.mqh>
//+------------------------------------------------------------------+
//| Declaration                                                      |
//+------------------------------------------------------------------+
class CExpertAsymetrique : public CExpert
  {
protected:
   //--- trading objects
   CExpertSignalMultiP     *m_signal_open;              // trading open signals object
   CExpertSignalMultiP     *m_signal_close;             // trading close signals object

public:
                     CExpertAsymetrique(void);
                    ~CExpertAsymetrique(void);
   //--- initialization
   bool              Init(string symbol,ENUM_TIMEFRAMES period,bool every_tick,ulong magic=0);
   void              Magic(ulong value);

   //--- initialization trading objects
   virtual bool      InitSignalOpen(CExpertSignalMultiP *signal=NULL);
   virtual bool      InitSignalClose(CExpertSignalMultiP *signal=NULL);

   //--- methods of access to protected data
   CExpertSignalMultiP     *SignalOpen(void)            const { return(m_signal_open);               }
   CExpertSignalMultiP     *SignalClose(void)           const { return(m_signal_close);              }

   //--- method of verification of settings
   virtual bool      ValidationSettings();
   //--- method of modifying the min period of the Expert
   virtual bool      InitExpertMinPeriod(void);
   //--- method of creating the indicator and timeseries
   virtual bool      InitIndicators(CIndicators *indicators=NULL);

protected:
   //--- deinitialization
   virtual void      DeinitSignal(void);
   //--- processing (main method)
   virtual bool      Processing(void);
   //--- trade open positions check
   virtual bool      CheckOpenLong(void);
   virtual bool      CheckOpenShort(void);
   //--- trade reverse positions check
   virtual bool      CheckReverseLong(void);
   virtual bool      CheckReverseShort(void);
   //--- trade close positions check
   virtual bool      CheckCloseLong(void);
   virtual bool      CheckCloseShort(void);
   //--- trailing order check
   virtual bool      CheckTrailingOrderLong(void);
   virtual bool      CheckTrailingOrderShort(void);
   //--- delete order check
   virtual bool      CheckDeleteOrderLong(void);
   virtual bool      CheckDeleteOrderShort(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CExpertAsymetrique::CExpertAsymetrique(void) :
   m_signal_open(NULL),
   m_signal_close(NULL)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CExpertAsymetrique::~CExpertAsymetrique(void)
  {
   DeinitSignal();
  }
//+------------------------------------------------------------------+
//| Initialization and checking for input parameters                 |
//+------------------------------------------------------------------+
bool CExpertAsymetrique::Init(string symbol,ENUM_TIMEFRAMES period,bool every_tick,ulong magic)
  {
//--- returns false if the EA is initialized on a symbol/timeframe different from the current one
   if(symbol!=::Symbol() || period!=::Period())
     {
      PrintFormat(__FUNCTION__+": wrong symbol or timeframe (must be %s:%s)",symbol,EnumToString(period));
      return(false);
     }
//--- initialize common information
   if(m_symbol==NULL)
     {
      if((m_symbol=new CSymbolInfo)==NULL)
         return(false);
     }
   if(!m_symbol.Name(symbol))
      return(false);
   m_period    =period;

   m_every_tick=every_tick;
   m_magic     =magic;
   SetMarginMode();
   if(every_tick)
      TimeframeAdd(WRONG_VALUE);            // add all periods
   else
      TimeframeAdd(period);                 // add specified period
//--- tuning for 3 or 5 digits
   int digits_adjust=(m_symbol.Digits()==3 || m_symbol.Digits()==5) ? 10 : 1;
   m_adjusted_point=m_symbol.Point()*digits_adjust;
//--- initializing objects expert
   if(!InitTrade(magic))
     {
      Print(__FUNCTION__+": error initialization trade object");
      return(false);
     }
   if(!InitSignalOpen())
     {
      Print(__FUNCTION__+": error initialization signal object");
      return(false);
     }
   if(!InitSignalClose())
     {
      Print(__FUNCTION__+": error initialization signal object");
      return(false);
     }
   if(!InitTrailing())
     {
      Print(__FUNCTION__+": error initialization trailing object");
      return(false);
     }
   if(!InitMoney())
     {
      Print(__FUNCTION__+": error initialization money object");
      return(false);
     }
   if(!InitParameters())
     {
      Print(__FUNCTION__+": error initialization parameters");
      return(false);
     }
//--- initialization for working with trade history
   PrepareHistoryDate();
   HistoryPoint();
//--- primary initialization is successful, pass to the phase of tuning
   m_init_phase=INIT_PHASE_TUNING;
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Sets magic number for object and its dependent objects           |
//+------------------------------------------------------------------+
void CExpertAsymetrique::Magic(ulong value)
  {
   if(m_trade!=NULL)
      m_trade.SetExpertMagicNumber(value);
   if(m_signal_open!=NULL)
      m_signal_open.Magic(value);
   if(m_signal_close!=NULL)
      m_signal_close.Magic(value);
   if(m_money!=NULL)
      m_money.Magic(value);
   if(m_trailing!=NULL)
      m_trailing.Magic(value);
//---
   CExpertBase::Magic(value);
  }
//+------------------------------------------------------------------+
//| Initialization open signal object                                |
//+------------------------------------------------------------------+
bool CExpertAsymetrique::InitSignalOpen(CExpertSignalMultiP *signal)
  {
   if(m_signal_open!=NULL)
      delete m_signal_open;
//---
   if(signal==NULL)
     {
      if((m_signal_open=new CExpertSignalMultiP)==NULL)
         return(false);
     }
   else
      m_signal_open=signal;
//--- initializing signal object
   if(!m_signal_open.Init(GetPointer(m_symbol),m_period,m_adjusted_point))
      return(false);
   m_signal_open.EveryTick(m_every_tick);
   m_signal_open.Magic(m_magic);
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Initialization close signal object                               |
//+------------------------------------------------------------------+
bool CExpertAsymetrique::InitSignalClose(CExpertSignalMultiP *signal)
  {
   if(m_signal_close!=NULL)
      delete m_signal_close;
//---
   if(signal==NULL)
     {
      if((m_signal_close=new CExpertSignalMultiP)==NULL)
         return(false);
     }
   else
      m_signal_close=signal;
//--- initializing signal object
   if(!m_signal_close.Init(GetPointer(m_symbol),m_period,m_adjusted_point))
      return(false);
   m_signal_close.EveryTick(m_every_tick);
   m_signal_close.Magic(m_magic);
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Validation settings                                              |
//+------------------------------------------------------------------+
bool CExpertAsymetrique::ValidationSettings(void)
  {
   if(!CExpertBase::ValidationSettings())
      return(false);
//--- Check open signal parameters
   if(!m_signal_open.ValidationSettings())
     {
      Print(__FUNCTION__+": error open signal parameters");
      return(false);
     }
//--- Check close signal parameters
   if(!m_signal_close.ValidationSettings())
     {
      Print(__FUNCTION__+": error close signal parameters");
      return(false);
     }
//--- Check trailing parameters
   if(!m_trailing.ValidationSettings())
     {
      Print(__FUNCTION__+": error trailing parameters");
      return(false);
     }
//--- Check money parameters
   if(!m_money.ValidationSettings())
     {
      Print(__FUNCTION__+": error money parameters");
      return(false);
     }
//--- ok
   return(true);
  }
//+----------------------------------------------------------------------------------------------------+
/// @brief Initializes the effective minimal period across all expert components.                      |
/// @details Computes the minimal timeframe (in minutes) used by signal, trailing, and money objects.  |
/// If the expert is configured to run on every tick (m_every_tick), the method exits early and        |
/// leaves m_period_flags unchanged.                                                                   |
///                                                                                                    |
/// @return true if the calculation succeeded or was skipped due to every-tick mode, false otherwise.  |
//+----------------------------------------------------------------------------------------------------+
bool CExpertAsymetrique::InitExpertMinPeriod(void)
  {
// --- Si on travaille en mode "every tick", on ne fait rien
   if(m_every_tick)
     {
      Print("[InitExpertMinPeriod] Mode tick-par-tick détecté : aucun calcul de période effectué.");
      return true;
     }

// --- Calcul global pour déterminer m_period_flags
   int periods[];   // tableau dynamique pour stocker les périodes en minutes
   int count = 0;

// Période du signal d'ouverture
   if(m_signal_open != NULL)
     {
      PrintFormat("Début du test de %s", "signal_open");
      ENUM_TIMEFRAMES tf = m_signal_open.SignalMinPeriod();
      bool hs = m_signal_open.HasTimeframeSignificance();
      PrintFormat("SignalMinPeriod de signal_open = %s | Signifiance : %d", EnumToString(tf), hs);
      int p = CUtilsLTR::TimeframeToMinutes(tf);
      if(p > 0)
        {
         PrintFormat("[DEBUG] %s fournit %d min (hasTF=%s)",
                     "signal open",   // ou un libellé manuel
                     p,
                     ((m_signal_open!=NULL && m_signal_open.HasTimeframeSignificance()) ? "true":"false"));
         ArrayResize(periods, count+1);
         periods[count] = p;
         count++;
        }
     }

// Période du signal de fermeture
   if(m_signal_close != NULL)
     {
      PrintFormat("Début du test de %s", "signal_close");
      ENUM_TIMEFRAMES tf = m_signal_close.SignalMinPeriod();
      bool hs = m_signal_close.HasTimeframeSignificance();
      PrintFormat("SignalMinPeriod de signal_close = %s | Signifiance : %d", EnumToString(tf), hs);
      int p = CUtilsLTR::TimeframeToMinutes(tf);
      PrintFormat("p de signal_close = %d",p);
      if(p > 0)
        {
         PrintFormat("[DEBUG] %s fournit %d min (hasTF=%s)",
                     "signal close",   // ou un libellé manuel
                     p,
                     ((m_signal_close!=NULL && m_signal_close.HasTimeframeSignificance()) ? "true":"false"));
         ArrayResize(periods, count+1);
         periods[count] = p;
         count++;
        }
     }

// Période du trailing
   if(m_trailing != NULL)
     {
      ENUM_TIMEFRAMES tf = m_trailing.GetPeriod();
      int p = CUtilsLTR::TimeframeToMinutes(tf);
      if(p > 0 && m_trailing.HasTimeframeSignificance())
        {
         PrintFormat("[DEBUG] %s fournit %d min (hasTF=%s)",
                     "trailing",   // ou un libellé manuel
                     p,
                     ((m_trailing!=NULL && m_trailing.HasTimeframeSignificance()) ? "true":"false"));
         ArrayResize(periods, count+1);
         periods[count] = p;
         count++;
        }
     }

// Période du money
   if(m_money != NULL)
     {
      ENUM_TIMEFRAMES tf = m_money.GetPeriod();
      int p = CUtilsLTR::TimeframeToMinutes(tf);
      if(p > 0 && m_money.HasTimeframeSignificance())
        {
         PrintFormat("[DEBUG] %s fournit %d min (hasTF=%s)",
                     "money",   // ou un libellé manuel
                     p,
                     ((m_money!=NULL && m_money.HasTimeframeSignificance()) ? "true":"false"));
         ArrayResize(periods, count+1);
         periods[count] = p;
         count++;
        }
     }

//--- Case no period found
   if(count == 0)
     {
      m_period_flags = 0;
      PrintFormat("[DEBUG] Pas de période trouvée, retourne 0");
      return true;
     }

// S'il y a au moins un objet avec période, calculer la période globale
   if(count > 0)
     {
      int globalGCD = periods[0];
      for(int i = 1; i < count; i++)
         globalGCD = CUtilsLTR::GCD(globalGCD, periods[i]);

      int minPeriod = periods[0];
      for(int i = 1; i < count; i++)
         if(periods[i] < minPeriod)
            minPeriod = periods[i];

      // Si le PGCD vaut 1 minute, on retombe sur la plus petite période
      //int effectivePeriod = (globalGCD == 1 ? minPeriod : globalGCD);
      
      // On prend le PGCD comme période minimale, avec le risque de prendre 1min si les périodes ne sont pas compatibles entre elles.
      int effectivePeriod = globalGCD;
      
      for(int i = 0; i < count; i++)
         PrintFormat("periods[%d] = %d (minutes)", i, periods[i]);

      PrintFormat("effectivePeriod = %d (minutes)", effectivePeriod);
      // Conversion de la période effective en flag
      m_period_flags = CUtilsLTR::ConvertMinutesToFlag(effectivePeriod);
     }
   return true;
  }
//+------------------------------------------------------------------+
//| Initialization indicators                                        |
//+------------------------------------------------------------------+
bool CExpertAsymetrique::InitIndicators(CIndicators *indicators)
  {
//--- NULL always comes as the parameter, but here it's not significant for us
   CIndicators *indicators_ptr=GetPointer(m_indicators);
//--- gather information about using of timeseries
   m_used_series|=m_signal_open.UsedSeries();
   m_used_series|=m_signal_close.UsedSeries();
   m_used_series|=m_trailing.UsedSeries();
   m_used_series|=m_money.UsedSeries();
//--- create required timeseries
   if(!CExpertBase::InitIndicators(indicators_ptr))
      return(false);
   m_signal_open.SetPriceSeries(m_open,m_high,m_low,m_close);
   m_signal_open.SetOtherSeries(m_spread,m_time,m_tick_volume,m_real_volume);
   if(!m_signal_open.InitIndicators(indicators_ptr))
     {
      Print(__FUNCTION__+": error initialization indicators of open signal object");
      return(false);
     }
   m_signal_close.SetPriceSeries(m_open,m_high,m_low,m_close);
   m_signal_close.SetOtherSeries(m_spread,m_time,m_tick_volume,m_real_volume);
   if(!m_signal_close.InitIndicators(indicators_ptr))
     {
      Print(__FUNCTION__+": error initialization indicators of close signal object");
      return(false);
     }
   m_trailing.SetPriceSeries(m_open,m_high,m_low,m_close);
   m_trailing.SetOtherSeries(m_spread,m_time,m_tick_volume,m_real_volume);
   if(!m_trailing.InitIndicators(indicators_ptr))
     {
      Print(__FUNCTION__+": error initialization indicators of trailing object");
      return(false);
     }
   m_money.SetPriceSeries(m_open,m_high,m_low,m_close);
   m_money.SetOtherSeries(m_spread,m_time,m_tick_volume,m_real_volume);
   if(!m_money.InitIndicators(indicators_ptr))
     {
      Print(__FUNCTION__+": error initialization indicators of money object");
      return(false);
     }
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Deinitialization signal object                                   |
//+------------------------------------------------------------------+
void CExpertAsymetrique::DeinitSignal(void)
  {
   if(m_signal_open!=NULL)
     {
      delete m_signal_open;
      m_signal_open=NULL;
     }
   if(m_signal_close!=NULL)
     {
      delete m_signal_close;
      m_signal_close=NULL;
     }
  }
//+------------------------------------------------------------------+
//| Main function                                                    |
//+------------------------------------------------------------------+
bool CExpertAsymetrique::Processing(void)
  {
//--- calculate signal direction once
   m_signal_open.SetDirection();
   m_signal_close.SetDirection();

//--- check if open positions
   if(SelectPosition())
     {
      //--- open position is available
      //--- check the possibility of reverse the position
      if(CheckReverse())
         return(true);
      //--- check the possibility of closing the position/delete pending orders
      if(!CheckClose())
        {
         //--- check the possibility of modifying the position
         if(CheckTrailingStop())
            return(true);
         //--- return without operations
         return(false);
        }
     }
//--- check if placed pending orders
   int total=OrdersTotal();
   if(total!=0)
     {
      for(int i=total-1; i>=0; i--)
        {
         m_order.SelectByIndex(i);
         if(m_order.Symbol()!=m_symbol.Name())
            continue;
         if(m_order.OrderType()==ORDER_TYPE_BUY_LIMIT || m_order.OrderType()==ORDER_TYPE_BUY_STOP)
           {
            //--- check the ability to delete a pending order to buy
            if(CheckDeleteOrderLong())
               return(true);
            //--- check the possibility of modifying a pending order to buy
            if(CheckTrailingOrderLong())
               return(true);
           }
         else
           {
            //--- check the ability to delete a pending order to sell
            if(CheckDeleteOrderShort())
               return(true);
            //--- check the possibility of modifying a pending order to sell
            if(CheckTrailingOrderShort())
               return(true);
           }
        }
       //--- return without operations
       return(false);
     }
//--- check the possibility of opening a position/setting pending order
   if(CheckOpen())
   {
         Print("on a check open ok !");
         return(true);
   }

//--- return without operations
   return(false);
  }
//+------------------------------------------------------------------+
//| Check for long position open or limit/stop order set             |
//+------------------------------------------------------------------+
bool CExpertAsymetrique::CheckOpenLong(void)
  {
   double   price=EMPTY_VALUE;
   double   sl=0.0;
   double   tp=0.0;
   datetime expiration=TimeCurrent();
//--- check signal for long enter operations
   if(m_signal_open.CheckOpenLong(price,sl,tp,expiration))
     {
      if(!m_trade.SetOrderExpiration(expiration))
         m_expiration=expiration;
      return(OpenLong(price,sl,tp));
     }
//--- return without operations
   return(false);
  }
//+------------------------------------------------------------------+
//| Check for short position open or limit/stop order set            |
//+------------------------------------------------------------------+
bool CExpertAsymetrique::CheckOpenShort(void)
  {
   double   price=EMPTY_VALUE;
   double   sl=0.0;
   double   tp=0.0;
   datetime expiration=TimeCurrent();
//--- check signal for short enter operations
   if(m_signal_open.CheckOpenShort(price,sl,tp,expiration))
     {
      if(!m_trade.SetOrderExpiration(expiration))
         m_expiration=expiration;
      return(OpenShort(price,sl,tp));
     }
//--- return without operations
   return(false);
  }

//+------------------------------------------------------------------+
//| Check for long position reverse                                  |
//+------------------------------------------------------------------+
bool CExpertAsymetrique::CheckReverseLong(void)
  {
   double   priceOpen=EMPTY_VALUE;
   double   priceClose=EMPTY_VALUE;
   double   sl=0.0;
   double   tp=0.0;
   datetime expiration=TimeCurrent();

// 1) Vérifier la possibilité de fermeture longue avec le signal de fermeture
   if(!m_signal_close.CheckCloseLong(priceClose))
      return(false);

// 2) Vérifier la possibilité d'ouverture d'une position short avec le signal d'ouverture
   if(!m_signal_open.CheckOpenShort(priceOpen, sl, tp, expiration))
      return(false);

// Logique éventuellement conservée depuis l'original (différence de prix close/open)
   if(priceClose != priceOpen)
      return(false);

// Enfin, effectuer la réversion
   return(ReverseLong(priceOpen, sl, tp));
  }
//+------------------------------------------------------------------+
//| Check for short position reverse                                 |
//+------------------------------------------------------------------+
bool CExpertAsymetrique::CheckReverseShort(void)
  {
   double   priceOpen=EMPTY_VALUE;
   double   priceClose=EMPTY_VALUE;
   double   sl=0.0;
   double   tp=0.0;
   datetime expiration=TimeCurrent();

   if(!m_signal_close.CheckCloseShort(priceClose))
      return(false);

   if(!m_signal_open.CheckOpenLong(priceOpen, sl, tp, expiration))
      return(false);

   if(priceClose != priceOpen)
      return(false);

   return(ReverseShort(priceOpen, sl, tp));
  }
//+------------------------------------------------------------------+
//| Check for long position close or limit/stop order delete         |
//+------------------------------------------------------------------+
bool CExpertAsymetrique::CheckCloseLong(void)
  {
   double price=EMPTY_VALUE;
//--- check for long close operations
   if(m_signal_close.CheckCloseLong(price))
      return(CloseLong(price));
//--- return without operations
   return(false);
  }
//+------------------------------------------------------------------+
//| Check for short position close or limit/stop order delete        |
//+------------------------------------------------------------------+
bool CExpertAsymetrique::CheckCloseShort(void)
  {
   double price=EMPTY_VALUE;
//--- check for short close operations
   if(m_signal_close.CheckCloseShort(price))
      return(CloseShort(price));
//--- return without operations
   return(false);
  }
//+------------------------------------------------------------------+
//| Check for trailing long limit/stop order                         |
//+------------------------------------------------------------------+
bool CExpertAsymetrique::CheckTrailingOrderLong(void)
  {
   double price;
//--- check the possibility of modifying the long order
   if(m_signal_open.CheckTrailingOrderLong(GetPointer(m_order),price))
      return(TrailingOrderLong(m_order.PriceOpen()-price));
//--- return without operations
   return(false);
  }
//+------------------------------------------------------------------+
//| Check for trailing short limit/stop order                        |
//+------------------------------------------------------------------+
bool CExpertAsymetrique::CheckTrailingOrderShort(void)
  {
   double price;
//--- check the possibility of modifying the short order
   if(m_signal_open.CheckTrailingOrderShort(GetPointer(m_order),price))
      return(TrailingOrderShort(m_order.PriceOpen()-price));
//--- return without operations
   return(false);
  }
//+------------------------------------------------------------------+
//| Check for delete long limit/stop order                           |
//+------------------------------------------------------------------+
bool CExpertAsymetrique::CheckDeleteOrderLong(void)
  {
   double price;
//--- check the possibility of deleting the long order
   if(m_expiration!=0 && TimeCurrent()>m_expiration)
     {
      m_expiration=0;
      return(DeleteOrderLong());
     }
   if(m_signal_close.CheckCloseLong(price))
      return(DeleteOrderLong());
//--- return without operations
   return(false);
  }
//+------------------------------------------------------------------+
//| Check for delete short limit/stop order                          |
//+------------------------------------------------------------------+
bool CExpertAsymetrique::CheckDeleteOrderShort(void)
  {
   double price;
//--- check the possibility of deleting the short order
   if(m_expiration!=0 && TimeCurrent()>m_expiration)
     {
      m_expiration=0;
      return(DeleteOrderShort());
     }
   if(m_signal_close.CheckCloseShort(price))
      return(DeleteOrderShort());
//--- return without operations
   return(false);
  }
//+------------------------------------------------------------------+
// Fin du fichier ExpertAsymetrique.mqh
//+------------------------------------------------------------------+