//+------------------------------------------------------------------+
//|                                               MoneyNone_eLib.mqh |
//|                                     Copyright 2025, Lucas TRONCY |
//+------------------------------------------------------------------+
#include <Expert/Money/MoneyNone.mqh>
//+------------------------------------------------------------------+
//| Class CMoneyNone_eLib.                                           |
//| Simple extension "placeholder" of CMoneyNone from MQL5           |
//| base framework                                                   |
//+------------------------------------------------------------------+
class CMoneyNone_eLib : public CMoneyNone
  {
public:
                     CMoneyNone_eLib(void);
                    ~CMoneyNone_eLib(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CMoneyNone_eLib::CMoneyNone_eLib(void) : CMoneyNone()
  {
   m_has_tf_significance = false;
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CMoneyNone_eLib::~CMoneyNone_eLib(void)
  {
  }
//+------------------------------------------------------------------+