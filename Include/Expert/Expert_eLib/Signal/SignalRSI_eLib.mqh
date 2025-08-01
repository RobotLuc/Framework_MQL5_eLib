//+------------------------------------------------------------------+
// Titre du fichier : SignalRSI_eLib.mqh
// Contenu du fichier :
//   * type : Classe MQL5
//   * nom : CSignalRSI_eLib
//   * dérive de : ExpertSignalMultiP
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include <Expert\Expert_eLib\ExpertSignalMultiP.mqh>
//+------------------------------------------------------------------+
//| Declaration                                                      |
//+------------------------------------------------------------------+
class CSignalRSI_eLib : public CExpertSignalMultiP
  {
protected:
   CiRSI             m_rsi;             // object-oscillator
   //--- adjusted parameters
   int               m_periodRSI;       // the "period of calculation" parameter of the oscillator
   ENUM_APPLIED_PRICE m_applied;        // the "prices series" parameter of the oscillator
   double            m_seuilsurachete;  // Le seuil qui défini le surachat - 70 par défaut
   double            m_seuilsurvendu;   // La valeur seuil qui défini la survente - 30 par défaut
   double            m_min_rsi_change;  // Variation minimale significative du RSI pour détecter une hausse/baisse
   double            m_seuil_medianmax; // Valeur médiane du RSI : si RSI >mediane max => Long, - 55 par défaut
   double            m_seuil_maximum;   // Valeur max du RSI pour motif 6 - 70 par défaut
   double            m_seuil_medianmin; // Valeur médiane du RSI : si RSI < medianemin => Short - 45 par défaut
   double            m_seuil_minimum;   // Valeur min du RSI pour motif 6 - 30 par défaut

   //--- "weights" of market models (0-100)
   int               m_pattern_0;      // model 0 "the oscillator has required direction"
   int               m_pattern_1;      // model 1 "reverse behind the level of overbuying/overselling"
   int               m_pattern_2;      // model 2 "failed swing"
   int               m_pattern_3;      // model 3 "divergence of the oscillator and price"
   int               m_pattern_4;      // model 4 "double divergence of the oscillator and price"
   int               m_pattern_5;      // model 5 "head/shoulders"
   int               m_pattern_6;      // model 6 "RSI dans zone achat-vente"

   //--- variables
   double            m_extr_osc[10];   // array of values of extremums of the oscillator
   double            m_extr_pr[10];    // array of values of the corresponding extremums of price
   int               m_extr_pos[10];   // array of shifts of extremums (in bars)
   uint              m_extr_map;       // resulting bit-map of ratio of extremums of the oscillator and the price

public:
                     CSignalRSI_eLib(void);
                    ~CSignalRSI_eLib(void);
   //--- methods of setting adjustable parameters
   void              PeriodRSI(int value)              { m_periodRSI=value;           }
   void              Applied(ENUM_APPLIED_PRICE value) { m_applied=value;             }
   void              Pattern_0(int value)              { m_pattern_0=value;           }
   void              Pattern_1(int value)              { m_pattern_1=value;           }
   void              Pattern_2(int value)              { m_pattern_2=value;           }
   void              Pattern_3(int value)              { m_pattern_3=value;           }
   void              Pattern_4(int value)              { m_pattern_4=value;           }
   void              Pattern_5(int value)              { m_pattern_5=value;           }
   void              Pattern_6(int value)              { m_pattern_6 = value;         }

   void              SeuilMedianMax(double value)      { m_seuil_medianmax = value;   }
   void              SeuilMedianMin(double value)      { m_seuil_medianmin = value;   }
   void              SeuilMaximum(double value)        { m_seuil_maximum = value;     }
   void              SeuilMinimum(double value)        { m_seuil_minimum = value;     }
   void              SeuilSurAchete(double value)      { m_seuilsurachete=value;      }
   void              SeuilSurVendu(double value)       { m_seuilsurvendu=value;       }
   void              MinRSIChange(double value)        { m_min_rsi_change = value;    }

   //--- method of verification of settings
   virtual bool      ValidationSettings(void);
   //--- method of creating the indicator and timeseries
   virtual bool      InitIndicators(CIndicators *indicators);
   //--- methods of checking if the market models are formed
   virtual int       LongCondition(void);
   virtual int       ShortCondition(void);

protected:
   //--- method of initialization of the oscillator
   bool              InitRSI(CIndicators *indicators);
   //--- methods of getting data
   double            RSI(int ind)                      { return(m_rsi.Main(ind));     }
   double            DiffRSI(int ind)                  { return(RSI(ind)-RSI(ind+1)); }
   int               StateRSI(int ind);
   bool              ExtStateRSI(int ind);
   bool              CompareMaps(int map,int count,bool minimax=false,int start=0);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CSignalRSI_eLib::CSignalRSI_eLib(void) : m_periodRSI(14),
   m_applied(PRICE_CLOSE),
   m_pattern_0(0),
   m_pattern_1(100),
   m_pattern_2(0),
   m_pattern_3(100),
   m_pattern_4(0),
   m_pattern_5(0),
   m_pattern_6(0),
   m_seuilsurachete(70),
   m_seuilsurvendu(30),
   m_min_rsi_change(0.0),
   m_seuil_maximum(70),
   m_seuil_minimum(30),
   m_seuil_medianmax(55),
   m_seuil_medianmin(45)
  {
//--- initialization of protected data
   m_used_series=USE_SERIES_HIGH+USE_SERIES_LOW;
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CSignalRSI_eLib::~CSignalRSI_eLib(void)
  {
  }
//+------------------------------------------------------------------+
//| Validation settings protected data.                              |
//+------------------------------------------------------------------+
bool CSignalRSI_eLib::ValidationSettings(void)
  {
//--- validation settings of additional filters
   if(!CExpertSignal::ValidationSettings())
      return(false);
//--- initial data checks
   if(m_periodRSI<=0)
     {
      printf(__FUNCTION__+": period of the RSI oscillator must be greater than 0");
      return(false);
     }
   if(m_min_rsi_change < 0)
     {
      printf(__FUNCTION__+": minimal RSI change must be greater than or equal to 0");
      return(false);
     }
   if(m_seuilsurachete>=100 || m_seuilsurvendu >=100 || m_seuilsurachete <0 || m_seuilsurvendu <0)
     {
      printf(__FUNCTION__+": error in definition of threshold for overbuy or oversell");
      return(false);
     }
   if(m_seuil_minimum >= m_seuil_medianmin || m_seuil_medianmax >= m_seuil_maximum  || m_seuil_medianmax < m_seuil_medianmin)
     {
      printf(__FUNCTION__+": thresholds must be ordered : minimum < medianmin < medianmax < maximum");
      return(false);
     }
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Create indicators.                                               |
//+------------------------------------------------------------------+
bool CSignalRSI_eLib::InitIndicators(CIndicators *indicators)
  {
//--- check pointer
   if(indicators==NULL)
      return(false);
//--- initialization of indicators and timeseries of additional filters
   if(!CExpertSignal::InitIndicators(indicators))
      return(false);
//--- create and initialize RSI oscillator
   if(!InitRSI(indicators))
      return(false);
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Initialize RSI oscillators.                                      |
//+------------------------------------------------------------------+
bool CSignalRSI_eLib::InitRSI(CIndicators *indicators)
  {
//--- check pointer
   if(indicators==NULL)
      return(false);
//--- add object to collection
   if(!indicators.Add(GetPointer(m_rsi)))
     {
      printf(__FUNCTION__+": error adding object");
      return(false);
     }
//--- initialize object
   if(!m_rsi.Create(m_symbol.Name(),m_period,m_periodRSI,m_applied))
     {
      printf(__FUNCTION__+": error initializing object");
      return(false);
     }
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| Check of the oscillator state.                                   |
//+------------------------------------------------------------------+
int CSignalRSI_eLib::StateRSI(int ind)
  {
   int    res=0;
   double var;
//---
   for(int i=ind;;i++)
     {
      if(RSI(i+1)==EMPTY_VALUE)
         break;
      var=DiffRSI(i);
      if(res>0)
        {
         if(var<0)
            break;
         res++;
         continue;
        }
      if(res<0)
        {
         if(var>0)
            break;
         res--;
         continue;
        }
      if(var>0)
         res++;
      if(var<0)
         res--;
     }
//---
   return(res);
  }
//+------------------------------------------------------------------+
//| Extended check of the oscillator state consists                  |
//| in forming a bit-map according to certain rules,                 |
//| which shows ratios of extremums of the oscillator and price.     |
//+------------------------------------------------------------------+
bool CSignalRSI_eLib::ExtStateRSI(int ind)
  {
//--- operation of this method results in a bit-map of extremums
//--- practically, the bit-map of extremums is an "array" of 4-bit fields
//--- each "element of the array" definitely describes the ratio
//--- of current extremums of the oscillator and the price with previous ones
//--- purpose of bits of an element of the analyzed bit-map
//--- bit 3 - not used (always 0)
//--- bit 2 - is equal to 1 if the current extremum of the oscillator is "more extreme" than the previous one
//---         (a higher peak or a deeper valley), otherwise - 0
//--- bit 1 - not used (always 0)
//--- bit 0 - is equal to 1 if the current extremum of price is "more extreme" than the previous one
//---         (a higher peak or a deeper valley), otherwise - 0
//--- in addition to them, the following is formed:
//--- array of values of extremums of the oscillator,
//--- array of values of price extremums and
//--- array of "distances" between extremums of the oscillator (in bars)
//--- it should be noted that when using the results of the extended check of state,
//--- you should consider, which extremum of the oscillator (peak or valley)
//--- is the "reference point" (i.e. was detected first during the analysis)
//--- if a peak is detected first then even elements of all arrays
//--- will contain information about peaks, and odd elements will contain information about valleys
//--- if a valley is detected first, then respectively in reverse
   int    pos=ind,off,index;
   uint   map;                 // intermediate bit-map for one extremum
//---
   m_extr_map=0;
   for(int i=0;i<10;i++)
     {
      off=StateRSI(pos);
      if(off>0)
        {
         //--- minimum of the oscillator is detected
         pos+=off;
         m_extr_pos[i]=pos;
         m_extr_osc[i]=RSI(pos);
         if(i>1)
           {
            m_extr_pr[i]=m_low.MinValue(pos-2,5,index);
            //--- form the intermediate bit-map
            map=0;
            if(m_extr_pr[i-2]<m_extr_pr[i])
               map+=1;  // set bit 0
            if(m_extr_osc[i-2]<m_extr_osc[i])
               map+=4;  // set bit 2
            //--- add the result
            m_extr_map+=map<<(4*(i-2));
           }
         else
            m_extr_pr[i]=m_low.MinValue(pos-1,4,index);
        }
      else
        {
         //--- maximum of the oscillator is detected
         pos-=off;
         m_extr_pos[i]=pos;
         m_extr_osc[i]=RSI(pos);
         if(i>1)
           {
            m_extr_pr[i]=m_high.MaxValue(pos-2,5,index);
            //--- form the intermediate bit-map
            map=0;
            if(m_extr_pr[i-2]>m_extr_pr[i])
               map+=1;  // set bit 0
            if(m_extr_osc[i-2]>m_extr_osc[i])
               map+=4;  // set bit 2
            //--- add the result
            m_extr_map+=map<<(4*(i-2));
           }
         else
            m_extr_pr[i]=m_high.MaxValue(pos-1,4,index);
        }
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Comparing the bit-map of extremums with pattern.                 |
//+------------------------------------------------------------------+
bool CSignalRSI_eLib::CompareMaps(int map,int count,bool minimax,int start)
  {
   int step =(minimax)?4:8;
   int total=step*(start+count);
//--- check input parameters for a possible going out of range of the bit-map
   if(total>32)
      return(false);
//--- bit-map of the patter is an "array" of 4-bit fields
//--- each "element of the array" definitely describes the desired ratio
//--- of current extremums of the oscillator and the price with previous ones
//--- purpose of bits of an elements of the pattern of the bit-map pattern
//--- bit 3 - is equal to if the ratio of extremums of the oscillator is insignificant for us
//---         is equal to 0 if we want to "find" the ratio of extremums of the oscillator determined by the value of bit 2
//--- bit 2 - is equal to 1 if we want to "discover" the situation when the current extremum of the "oscillator" is "more extreme" than the previous one
//---         (current peak is higher or current valley is deeper)
//---         is equal to 0 if we want to "discover" the situation when the current extremum of the oscillator is "less extreme" than the previous one
//---         (current peak is lower or current valley is less deep)
//--- bit 1 - is equal to 1 if the ratio of extremums is insignificant for us
//---         it is equal to 0 if we want to "find" the ratio of price extremums determined by the value of bit 0
//--- bit 0 - is equal to 1 if we want to "discover" the situation when the current price extremum is "more extreme" than the previous one
//---         (current peak is higher or current valley is deeper)
//---         it is equal to 0 if we want to "discover" the situation when the current price extremum is "less extreme" than the previous one
//---         (current peak is lower or current valley is less deep)
   uint inp_map,check_map;
   int  i,j;
//--- loop by extremums (4 minimums and 4 maximums)
//--- price and the oscillator are checked separately (thus, there are 16 checks)
   for(i=step*start,j=0;i<total;i+=step,j+=4)
     {
      //--- "take" two bits - patter of the corresponding extremum of the price
      inp_map=(map>>j)&3;
      //--- if the higher-order bit=1, then any ratio is suitable for us
      if(inp_map<2)
        {
         //--- "take" two bits of the corresponding extremum of the price (higher-order bit is always 0)
         check_map=(m_extr_map>>i)&3;
         if(inp_map!=check_map)
            return(false);
        }
      //--- "take" two bits - pattern of the corresponding oscillator extremum
      inp_map=(map>>(j+2))&3;
      //--- if the higher-order bit=1, then any ratio is suitable for us
      if(inp_map>=2)
         continue;
      //--- "take" two bits of the corresponding oscillator extremum (higher-order bit is always 0)
      check_map=(m_extr_map>>(i+2))&3;
      if(inp_map!=check_map)
         return(false);
     }
//--- ok
   return(true);
  }
//+------------------------------------------------------------------+
//| "Voting" that price will grow.                                   |
//+------------------------------------------------------------------+
int CSignalRSI_eLib::LongCondition(void)
  {
   int result=0;
   int motif = -1; // Pour identifier le motif ayant déclenché le vote
   int idx   =StartIndex();
//---
   if(IS_PATTERN_USAGE(6))
     {
      if(RSI(idx) >= m_seuil_medianmax && RSI(idx) <= m_seuil_maximum)
        {
         result = m_pattern_6;
         motif = 6;
        }
     }

   if(DiffRSI(idx)>m_min_rsi_change)
     {
      //--- the oscillator is directed upwards confirming the possibility of price growth
      if(IS_PATTERN_USAGE(0))
        {
         result=m_pattern_0;      // "confirming" signal number 0
         motif = 0;
        };
      //--- if the model 1 is used, search for a reverse of the oscillator upwards behind the level of overselling
      if(IS_PATTERN_USAGE(1) && DiffRSI(idx+1)<0.0 && RSI(idx+1)<m_seuilsurvendu)
        {
         result=m_pattern_1;      // signal number 1
         motif = 1;
        };
      //--- if the model 2, 3, 4 or 5 is used, perform the extended analysis of the oscillator state
      if(IS_PATTERN_USAGE(2) || IS_PATTERN_USAGE(3) || IS_PATTERN_USAGE(4) || IS_PATTERN_USAGE(5))
        {
         ExtStateRSI(idx);
         //--- search for the "failed swing" signal
         if(IS_PATTERN_USAGE(2) && RSI(idx)>m_extr_osc[1])
           {
            result=m_pattern_2;   // signal number 2
            motif = 2;
           };
         //--- search for the "divergence" signal
         if(IS_PATTERN_USAGE(3) && CompareMaps(1,1)) // 0000 0001b
           {
            result=m_pattern_3;   // signal number 3
            motif = 3;
           }
         //--- search for the "double divergence" signal
         if(IS_PATTERN_USAGE(4) && CompareMaps(0x11,2)) // 0001 0001b
           {
            result=m_pattern_4;  // signal number 4
            motif = 4;
           };
         //--- search for the "head/shoulders" signal
         if(IS_PATTERN_USAGE(5) && CompareMaps(0x62662,5,true) && RSI(idx)>m_extr_osc[1]) // 01100010011001100010b
           {
            result=m_pattern_5;   // signal number 5
            motif = 5;
           };
        }
     }

//--- return the result
   return(result);
  }
//+------------------------------------------------------------------+
//| "Voting" that price will fall.                                   |
//+------------------------------------------------------------------+
int CSignalRSI_eLib::ShortCondition(void)
  {
   int result=0;
   int motif = -1; // Pour identifier le motif ayant déclenché le vote
   int idx   =StartIndex();
//---
   if(IS_PATTERN_USAGE(6))
     {
      if(RSI(idx) <= m_seuil_medianmin && RSI(idx) >= m_seuil_minimum)
        {
         result = m_pattern_6;
         motif = 6;
        }
     }

   if(DiffRSI(idx)<-m_min_rsi_change)
     {
      //--- the oscillator is directed downwards confirming the possibility of falling of price
      if(IS_PATTERN_USAGE(0))
        {
         result=m_pattern_0;      // "confirming" signal number 0
         motif = 0;
        };
      //--- if the model 1 is used, search for a reverse of the oscillator downwards behind the level of overbuying
      if(IS_PATTERN_USAGE(1) && DiffRSI(idx+1)>0.0 && RSI(idx+1)>m_seuilsurachete)
        {
         result=m_pattern_1;      // signal number 1
         motif = 1;
        };
      //--- if the model 2, 3, 4 or 5 is used, perform the extended analysis of the oscillator state
      if(IS_PATTERN_USAGE(2) || IS_PATTERN_USAGE(3) || IS_PATTERN_USAGE(4) || IS_PATTERN_USAGE(5))
        {
         ExtStateRSI(idx);
         //--- search for the "failed swing" signal
         if(IS_PATTERN_USAGE(2) && RSI(idx)<m_extr_osc[1])
           {
            result=m_pattern_2;   // signal number 2
            motif = 2;
           };
         //--- search for the "divergence" signal
         if(IS_PATTERN_USAGE(3) && CompareMaps(1,1)) // 0000 0001b
           {
            result=m_pattern_3;   // signal number 3
            motif = 3;
           };
         //--- search for the "double divergence" signal
         if(IS_PATTERN_USAGE(4) && CompareMaps(0x11,2)) // 0001 0001b
           {
            result=m_pattern_4;  // signal number 4
            motif = 4;
           };
         //--- search for the "head/shoulders" signal
         if(IS_PATTERN_USAGE(5) && CompareMaps(0x62662,5,true) && RSI(idx)<m_extr_osc[1]) // 01100010011001100010b
           {
            result=m_pattern_5;   // signal number 5
            motif = 5;
           };
        }
     }
//--- return the result
   return(result);
  }
//+------------------------------------------------------------------+
// Fin du fichier SignalRSI_eLib.mqh
