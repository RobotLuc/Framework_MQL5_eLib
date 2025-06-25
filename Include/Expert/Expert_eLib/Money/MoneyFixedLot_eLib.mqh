//+------------------------------------------------------------------+
//|                                           MoneyFixedLot_eLib.mqh |
//|                                     Copyright 2025, Lucas TRONCY |
//+------------------------------------------------------------------+
#include <Expert/Money/MoneyFixedLot.mqh>
//+------------------------------------------------------------------+
//| Class CMoneyFixedLot_eLib.                                       |
//| Simple extension "placeholder" of CMoneyFixedLot from MQL5       |
//| base framework                                                   |
//+------------------------------------------------------------------+
class CMoneyFixedLot_eLib : public CMoneyFixedLot
  {
public:
                     CMoneyFixedLot_eLib(void);
                    ~CMoneyFixedLot_eLib(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CMoneyFixedLot_eLib::CMoneyFixedLot_eLib(void) : CMoneyFixedLot()
  {
   m_has_tf_significance = false;
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CMoneyFixedLot_eLib::~CMoneyFixedLot_eLib(void)
  {
  }
//+------------------------------------------------------------------+
