//+------------------------------------------------------------------+
//|                                          MoneyFixedRisk_eLib.mqh |
//|                                     Copyright 2025, Lucas TRONCY |
//+------------------------------------------------------------------+
#include <Expert/Money/MoneyFixedRisk.mqh>
//+------------------------------------------------------------------+
//| Class CMoneyFixedRisk_eLib.                                      |
//| Simple extension "placeholder" of CMoneyFixedRisk from MQL5      |
//| base framework                                                   |
//+------------------------------------------------------------------+
class CMoneyFixedRisk_eLib : public CMoneyFixedRisk
  {
public:
                     CMoneyFixedRisk_eLib(void);
                    ~CMoneyFixedRisk_eLib(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CMoneyFixedRisk_eLib::CMoneyFixedRisk_eLib(void) : CMoneyFixedRisk()
  {
   m_has_tf_significance = false;
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CMoneyFixedRisk_eLib::~CMoneyFixedRisk_eLib(void)
  {
  }
//+------------------------------------------------------------------+