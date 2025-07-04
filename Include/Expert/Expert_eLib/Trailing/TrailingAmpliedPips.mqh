//+------------------------------------------------------------------+
//|                                          TrailingAmpliedPips.mqh |
//|         Adaptive trailing stop derived from CTrailingFixedPips   |
//|  Increases stop distance after a user‑defined threshold is ht.   |
//+------------------------------------------------------------------+

#include <Expert\Expert_eLib\Trailing\TrailingFixedPips_eLib.mqh>
// wizard description start
//+----------------------------------------------------------------------+
//| Description of the class                                             |
//| Title=Trailing Stop with Amplification                               |
//| Type=Trailing                                                        |
//| Name=AmpliedPips                                                     |
//| Class=CTrailingAmpliedPips                                           |
//| Parameter=StopLevel,int,30,Initial stop level (points)               |
//| Parameter=ProfitLevel,int,50,Profit level (points)                   |
//| Parameter=SLThreshold,double,100,Threshold before amplification (pt) |
//| Parameter=AmplificationFactor,double,2.0,Stop amplification factor   |
//+----------------------------------------------------------------------+
// wizard description end

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CTrailingAmpliedPips : public CTrailingFixedPips_eLib
  {
protected:
   //--- additional parameters
   int               m_sl_threshold;         // threshold in points between position price and current market price before amplification
   double            m_amplification_factor; // coefficient to enlarge stop level

public:
                     CTrailingAmpliedPips(void);
                    ~CTrailingAmpliedPips(void) {}
   //--- setters
   void              SLThreshold(int thr)           { m_sl_threshold=thr;           }
   void              AmplificationFactor(double coeff) { m_amplification_factor=coeff; }
   //--- validation of settings
   virtual bool      ValidationSettings(void);
   //--- core trailing methods
   virtual bool      CheckTrailingStopLong(CPositionInfo *position,double &sl,double &tp);
   virtual bool      CheckTrailingStopShort(CPositionInfo *position,double &sl,double &tp);
  };

//+------------------------------------------------------------------+
//| Constructor with defaults                                         |
//+------------------------------------------------------------------+
CTrailingAmpliedPips::CTrailingAmpliedPips(void) :
   m_sl_threshold(100.0),
   m_amplification_factor(2.0)
  {
  }
//+------------------------------------------------------------------+
//| Validation                                                        |
//+------------------------------------------------------------------+
bool CTrailingAmpliedPips::ValidationSettings(void)
  {
   if(!CTrailingFixedPips::ValidationSettings())
      return(false);
//--- additional checks
   if(m_sl_threshold<=0.0)
     {
      printf(__FUNCTION__+": SLThreshold must be strictly positive");
      return(false);
     }
   if(m_amplification_factor<=0.0)
     {
      printf(__FUNCTION__+": AmplificationFactor must be strictly positive");
      return(false);
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| Trailing logic for long position                                  |
//+------------------------------------------------------------------+
bool CTrailingAmpliedPips::CheckTrailingStopLong(CPositionInfo *position,double &sl,double &tp)
  {
   if(position==NULL)
      return(false);
   if(m_stop_level==0)
      return(false);

   double pos_sl = position.StopLoss();
   double base   = (pos_sl==0.0) ? position.PriceOpen() : pos_sl;
   double price  = m_symbol.Bid();

   sl = EMPTY_VALUE;
   tp = EMPTY_VALUE;

// Effective stop level (points)
   double eff_stop_level = m_stop_level;

// Progress since entry price
   double progress    = price - position.PriceOpen();
   double threshold   = m_sl_threshold * m_adjusted_point;

   if(progress > threshold)
      eff_stop_level *= m_amplification_factor; // enlarge stop level after threshold

   double delta = eff_stop_level * m_adjusted_point;

   if(price - base > delta)
     {
      sl = price - delta;
      if(m_profit_level!=0)
         tp = price + m_profit_level * m_adjusted_point;
     }
   return(sl!=EMPTY_VALUE);
  }

//+------------------------------------------------------------------+
//| Trailing logic for short position                                 |
//+------------------------------------------------------------------+
bool CTrailingAmpliedPips::CheckTrailingStopShort(CPositionInfo *position,double &sl,double &tp)
  {
   if(position==NULL)
      return(false);
   if(m_stop_level==0)
      return(false);

   double pos_sl = position.StopLoss();
   double base   = (pos_sl==0.0) ? position.PriceOpen() : pos_sl;
   double price  = m_symbol.Ask();

   sl = EMPTY_VALUE;
   tp = EMPTY_VALUE;

// Effective stop level (points)
   double eff_stop_level = m_stop_level;

   double progress  = position.PriceOpen() - price; // distance for short
   double threshold = m_sl_threshold * m_adjusted_point;

   if(progress > threshold)
      eff_stop_level *= m_amplification_factor;

   double delta = eff_stop_level * m_adjusted_point;

   if(base - price > delta)
     {
      sl = price + delta;
      if(m_profit_level!=0)
         tp = price - m_profit_level * m_adjusted_point;
     }
   return(sl!=EMPTY_VALUE);
  }
//+------------------------------------------------------------------+
