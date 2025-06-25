//+------------------------------------------------------------------+
//|                                              TrailingMA_eLib.mqh |
//|                                     Copyright 2025, Lucas TRONCY |
//+------------------------------------------------------------------+
#include <Expert/Trailing/TrailingMA.mqh>
//+------------------------------------------------------------------+
//| Class CTrailingMA_eLib.                                          |
//| Simple extension "placeholder" of CTrailingMA from MQL5          |
//| base framework                                                   |
//+------------------------------------------------------------------+
class CTrailingMA_eLib : public CTrailingMA
  {
public:
                     CTrailingMA_eLib(void);
                    ~CTrailingMA_eLib(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTrailingMA_eLib::CTrailingMA_eLib(void) : CTrailingMA()
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CTrailingMA_eLib::~CTrailingMA_eLib(void)
  {
  }
//+------------------------------------------------------------------+