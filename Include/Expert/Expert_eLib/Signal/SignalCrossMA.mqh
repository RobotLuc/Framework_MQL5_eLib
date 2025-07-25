//+------------------------------------------------------------------+
//|                                                SignalCrossMA.mqh |
//|                                  Copyright 2025, Lucas Troncy    |
//+------------------------------------------------------------------+
#include <Expert\Expert_eLib\ExpertSignalMultiP.mqh>
// wizard description start
//+------------------------------------------------------------------+
//| Description of the class                                         |
//| Title=Signals of indicator 'Crossing Moving Average'             |
//| Type=SignalAdvanced                                              |
//| Name=Crossing Moving Average                                     |
//| ShortName=CrossMA                                                |
//| Class=CSignalCrossMA                                             |
//| Parameters=PeriodMA,int,12,Period of averaging                   |
//| Parameters=Shift,int,0,Time shift                                |
//| Parameters=Method,ENUM_MA_METHOD,MODE_SMA,Method of averaging    |
//| Parameters=Applied,ENUM_APPLIED_PRICE,PRICE_CLOSE,Prices series  |
//+------------------------------------------------------------------+
// wizard description end
//+------------------------------------------------------------------+
//| Class CSignalCrossMA                                             |
//| Purpose: Class of generator of trade signals based on            |
//|          the 'Crossing Moving Average' indicator.                |
//| Is derived from the CExpertSignal class.                         |
//+------------------------------------------------------------------+
class CSignalCrossMA : public CExpertSignalMultiP
  {
protected:
   CiMA              m_ma_fast;             // object-indicator
   CiMA              m_ma_slow;             // object-indicator

   // Paramètres de la MA rapide
   int               m_period_fast;
   int               m_shift_fast;
   ENUM_MA_METHOD    m_method_fast;
   ENUM_APPLIED_PRICE m_price_fast;

   // Paramètres de la MA lente
   int                  m_period_slow;
   int                  m_shift_slow;
   ENUM_MA_METHOD       m_method_slow;
   ENUM_APPLIED_PRICE   m_price_slow;
   double               m_percent_change_maslow;
   
   //--- "weights" of market models (0-100)
   int               m_pattern_0;      // model 0 Fast MA crossing Slow MA

public:
                     CSignalCrossMA(void);
                    ~CSignalCrossMA(void);
   // Setters
   void              PeriodFast(int value)              { m_period_fast = value; }
   void              ShiftFast(int value)               { m_shift_fast = value; }
   void              MethodFast(ENUM_MA_METHOD value)   { m_method_fast = value; }
   void              PriceFast(ENUM_APPLIED_PRICE val)  { m_price_fast = val; }

   void              PeriodSlow(int value)              { m_period_slow = value; }
   void              ShiftSlow(int value)               { m_shift_slow = value; }
   void              MethodSlow(ENUM_MA_METHOD value)   { m_method_slow = value; }
   void              PriceSlow(ENUM_APPLIED_PRICE val)  { m_price_slow = val; }
   void              PercentChangeSlowMA(double value)  { m_percent_change_maslow = value; }

   //--- methods of adjusting "weights" of market models
   void              Pattern_0(int value)                { m_pattern_0=value;          }

   //--- method of verification of settings
   virtual bool      ValidationSettings(void);
   //--- method of creating the indicator and timeseries
   virtual bool      InitIndicators(CIndicators *indicators);
   //--- methods of checking if the market models are formed
   virtual int       LongCondition(void);
   virtual int       ShortCondition(void);

protected:
   //--- method of initialization of the indicator
   bool              InitMAs(CIndicators *indicators);
   double            FastMA(int shift) { return m_ma_fast.Main(shift); }
   double            SlowMA(int shift) { return m_ma_slow.Main(shift); }
   bool              IsIncreasing(const CiMA &ma, int shift);
   bool              IsDecreasing(const CiMA &ma, int shift);
   bool              IsCrossingUp(int shift);
   bool              IsCrossingDown(int shift);
   bool              IsMASlowChangingFast(const CiMA &ma, int shift);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CSignalCrossMA::CSignalCrossMA(void) :
   m_period_fast(12), m_shift_fast(0), m_method_fast(MODE_SMA), m_price_fast(PRICE_CLOSE),
   m_period_slow(24), m_shift_slow(0), m_method_slow(MODE_SMA), m_price_slow(PRICE_CLOSE),
   m_pattern_0(100), m_percent_change_maslow(0.1)
  {
//--- initialization of protected data
   m_used_series=USE_SERIES_OPEN+USE_SERIES_HIGH+USE_SERIES_LOW+USE_SERIES_CLOSE;
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CSignalCrossMA::~CSignalCrossMA(void)
  {
  }
//+------------------------------------------------------------------+
//| Validation settings protected data.                              |
//+------------------------------------------------------------------+
bool CSignalCrossMA::ValidationSettings(void)
  {
//--- validation settings of additional filters
   if(!CExpertSignal::ValidationSettings())
      return(false);
//--- initial data checks
   if(m_period_fast <= 0 || m_period_slow <= 0)
     {
      printf(__FUNCTION__+": period MAs must be greater than 0");
      return(false);
     }
   if(m_percent_change_maslow < 0 || m_percent_change_maslow > 100)
     {
      printf(__FUNCTION__+": percent change MA slow must be between 0 and 100");
      return(false);
     }       
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Create indicators.                                               |
//+------------------------------------------------------------------+
bool CSignalCrossMA::InitIndicators(CIndicators *indicators)
  {
//--- check pointer
   if(indicators==NULL)
      return(false);
//--- initialization of indicators and timeseries of additional filters
   if(!CExpertSignal::InitIndicators(indicators))
      return(false);
//--- create and initialize CrossMA indicator
   if(!InitMAs(indicators))
      return(false);
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Initialize MA indicators.                                        |
//+------------------------------------------------------------------+
bool CSignalCrossMA::InitMAs(CIndicators *indicators)
  {
   if(!indicators.Add(GetPointer(m_ma_fast)) || !indicators.Add(GetPointer(m_ma_slow)))
      return false;

   if(!m_ma_fast.Create(m_symbol.Name(), m_period, m_period_fast, m_shift_fast, m_method_fast, m_price_fast))
     {
      printf(__FUNCTION__ + ": failed to initialize fast MA");
      return false;
     }

   if(!m_ma_slow.Create(m_symbol.Name(), m_period, m_period_slow, m_shift_slow, m_method_slow, m_price_slow))
     {
      printf(__FUNCTION__ + ": failed to initialize slow MA");
      return false;
     }

   return true;
  }
//+------------------------------------------------------------------+
//| "Voting" that price will grow.                                   |
//+------------------------------------------------------------------+
int CSignalCrossMA::LongCondition(void)
  {
   int result=0;
   int idx = StartIndex();

   if(!IS_PATTERN_USAGE(0))
      return (result);

   if(IsIncreasing(m_ma_fast, idx) &&
      IsIncreasing(m_ma_slow, idx) &&
      IsMASlowChangingFast(m_ma_slow, idx) &&
      IsCrossingUp(idx))
     {
      result = m_pattern_0;

      double fast_prev = FastMA(idx + 1);
      double slow_prev = SlowMA(idx + 1);
      double fast_curr = FastMA(idx);
      double slow_curr = SlowMA(idx);

      PrintFormat("⏫ Long signal (CrossMA): fast_prev=%.5f, fast_curr=%.5f, slow_prev=%.5f, slow_curr=%.5f, Δfast=%.5f, Δslow=%.5f, Δprev=%.5f, Δcurr=%.5f, pcΔslow=%.5f",
                  fast_prev, fast_curr,
                  slow_prev, slow_curr,
                  fast_curr - fast_prev,
                  slow_curr - slow_prev,
                  fast_prev - slow_prev,
                  fast_curr - slow_curr,
                  100*(slow_curr-slow_prev)/slow_prev);
     }
   return (result);
  }
//+------------------------------------------------------------------+
//| "Voting" that price will fall.                                   |
//+------------------------------------------------------------------+
int CSignalCrossMA::ShortCondition(void)
  {
   int result=0;
   int idx = StartIndex();

   if(!IS_PATTERN_USAGE(0))
      return (result);

   if(IsDecreasing(m_ma_fast, idx) &&
      IsDecreasing(m_ma_slow, idx) &&
      IsMASlowChangingFast(m_ma_slow, idx) &&
      IsCrossingDown(idx))

     {
      result = m_pattern_0;

      double fast_prev = FastMA(idx + 1);
      double slow_prev = SlowMA(idx + 1);
      double fast_curr = FastMA(idx);
      double slow_curr = SlowMA(idx);

      PrintFormat("⏬ Short signal (CrossMA): fast_prev=%.5f, fast_curr=%.5f, slow_prev=%.5f, slow_curr=%.5f, Δfast=%.5f, Δslow=%.5f, Δprev=%.5f, Δcurr=%.5f, pcΔslow=%.5f",
                  fast_prev, fast_curr,
                  slow_prev, slow_curr,
                  fast_curr - fast_prev,
                  slow_curr - slow_prev,
                  fast_prev - slow_prev,
                  fast_curr - slow_curr,
                  100*(slow_curr-slow_prev)/slow_prev);
     }

   return (result);
  }
//+------------------------------------------------------------------+
//| Vérifie si une MA est croissante entre shift+1 et shift         |
//+------------------------------------------------------------------+
bool CSignalCrossMA::IsIncreasing(const CiMA &ma, int shift)
  {
   double prev = ma.Main(shift + 1);
   double curr = ma.Main(shift);
   return (curr > prev);
  }
//+------------------------------------------------------------------+
//| Vérifie si une MA est décroissante entre shift+1 et shift       |
//+------------------------------------------------------------------+
bool CSignalCrossMA::IsDecreasing(const CiMA &ma, int shift)
  {
   double prev = ma.Main(shift + 1);
   double curr = ma.Main(shift);
   return (curr < prev);
  }
//+------------------------------------------------------------------+
//| Vérifie si la MA rapide croise la lente à la hausse             |
//+------------------------------------------------------------------+
bool CSignalCrossMA::IsCrossingUp(int shift)
  {
   double fast_prev = FastMA(shift + 1);
   double slow_prev = SlowMA(shift + 1);
   double fast_curr = FastMA(shift);
   double slow_curr = SlowMA(shift);
   return (fast_prev < slow_prev && fast_curr > slow_curr);
  }
//+------------------------------------------------------------------+
//| Vérifie si la MA rapide croise la lente à la baisse             |
//+------------------------------------------------------------------+
bool CSignalCrossMA::IsCrossingDown(int shift)
  {
   double fast_prev = FastMA(shift + 1);
   double slow_prev = SlowMA(shift + 1);
   double fast_curr = FastMA(shift);
   double slow_curr = SlowMA(shift);
   return (fast_prev > slow_prev && fast_curr < slow_curr);
  }
//+------------------------------------------------------------------+
//| Vérifie si la MM lente varie suffisament vite                    |
//+------------------------------------------------------------------+
bool CSignalCrossMA::IsMASlowChangingFast(const CiMA &ma, int shift)
  {
   double prev = ma.Main(shift + 1);
   double curr = ma.Main(shift);
   if (prev==0.0) return false;
   return (MathAbs(100*(curr-prev)/prev) >= m_percent_change_maslow);
  }

//+------------------------------------------------------------------+
