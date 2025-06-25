//+------------------------------------------------------------------+
//|                                          ExpertMoney_eLib.mqh    |
//|                                     Copyright 2025, Lucas TRONCY |
//+------------------------------------------------------------------+
#include <Expert/ExpertMoney.mqh>
//+------------------------------------------------------------------+
//| Class CExpertMoney_eLib.                                         |
//| Simple extension "placeholder" of CExpertMoney from MQL5         |
//| base framework                                                   |
//+------------------------------------------------------------------+
class CExpertMoney_eLib : public CExpertMoney
  {
public:
                     CExpertMoney_eLib(void);
                    ~CExpertMoney_eLib(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
void CExpertMoney_eLib::CExpertMoney_eLib(void) : CExpertMoney()
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
void CExpertMoney_eLib::~CExpertMoney_eLib(void)
  {
  }
