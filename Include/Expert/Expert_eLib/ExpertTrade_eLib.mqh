//+------------------------------------------------------------------+
//|                                          ExpertTrade_eLib.mqh    |
//|                                     Copyright 2025, Lucas TRONCY |
//+------------------------------------------------------------------+
#include <Expert/ExpertTrade.mqh>
//+------------------------------------------------------------------+
//| Class CExpertTrade_eLib.                                         |
//| Simple extension "placeholder" of CExpertTrade from MQL5         |
//| base framework                                                   |
//+------------------------------------------------------------------+
class CExpertTrade_eLib : public CExpertTrade
  {
public:
                     CExpertTrade_eLib(void);
                    ~CExpertTrade_eLib(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CExpertTrade_eLib::CExpertTrade_eLib(void) : CExpertTrade()
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CExpertTrade_eLib::~CExpertTrade_eLib(void)
  {
  }
//+------------------------------------------------------------------+