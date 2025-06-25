//+------------------------------------------------------------------+
//|                                    TrailingParabolicSAR_eLib.mqh |
//|                                     Copyright 2025, Lucas TRONCY |
//+------------------------------------------------------------------+
#include <Expert/Trailing/TrailingParabolicSAR.mqh>
//+------------------------------------------------------------------+
//| Class CTrailingParabolicSAR_eLib.                                |
//| Simple extension "placeholder" of CTrailingParabolicSAR from MQL5|
//| base framework                                                   |
//+------------------------------------------------------------------+
class CTrailingPSAR_eLib : public CTrailingPSAR
  {
public:
                     CTrailingPSAR_eLib(void);
                    ~CTrailingPSAR_eLib(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTrailingPSAR_eLib::CTrailingPSAR_eLib(void) : CTrailingPSAR()
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CTrailingPSAR_eLib::~CTrailingPSAR_eLib(void)
  {
  }
//+------------------------------------------------------------------+