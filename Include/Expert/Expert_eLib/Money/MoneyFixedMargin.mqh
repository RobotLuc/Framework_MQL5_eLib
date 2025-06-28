//+------------------------------------------------------------------+
//|                                        MoneyFixedMargin_eLib.mqh |
//|                                     Copyright 2025, Lucas TRONCY |
//+------------------------------------------------------------------+
#include <Expert/Money/MoneyFixedMargin.mqh>
//+------------------------------------------------------------------+
//| Class CMoneyFixedMargin_eLib.                                    |
//| Simple extension "placeholder" of CMoneyFixedMargin from MQL5    |
//| base framework                                                   |
//+------------------------------------------------------------------+
class CMoneyFixedMargin_eLib : public CMoneyFixedMargin
  {
public:
                     CMoneyFixedMargin_eLib(void);
                    ~CMoneyFixedMargin_eLib(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CMoneyFixedMargin_eLib::CMoneyFixedMargin_eLib(void) : CMoneyFixedMargin()
  {
   m_has_tf_significance = false;
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CMoneyFixedMargin_eLib::~CMoneyFixedMargin_eLib(void)
  {
  }
//+------------------------------------------------------------------+