//+------------------------------------------------------------------+
//|                                       TrailingFixedPips_eLib.mqh |
//|                                     Copyright 2025, Lucas TRONCY |
//+------------------------------------------------------------------+
#include <Expert/Trailing/TrailingFixedPips.mqh>
//+------------------------------------------------------------------+
//| Class CTrailingFixedPips_eLib.                                   |
//| Simple extension "placeholder" of CTrailingFixedPips from MQL5   |
//| base framework + inclusion of m_has_timeframe_signifiance        |
//+------------------------------------------------------------------+
class CTrailingFixedPips_eLib : public CTrailingFixedPips
  {
public:
                     CTrailingFixedPips_eLib(void);
                    ~CTrailingFixedPips_eLib(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTrailingFixedPips_eLib::CTrailingFixedPips_eLib(void) : CTrailingFixedPips()
  {
   m_has_tf_significance = false;
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CTrailingFixedPips_eLib::~CTrailingFixedPips_eLib(void)
  {
  }
//+------------------------------------------------------------------+

