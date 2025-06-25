//+------------------------------------------------------------------+
//|                                            TrailingNone_eLib.mqh |
//|                                     Copyright 2025, Lucas TRONCY |
//+------------------------------------------------------------------+
#include <Expert/Trailing/TrailingNone.mqh>
//+------------------------------------------------------------------+
//| Class CTrailingNone_eLib.                                        |
//| Simple extension "placeholder" of CTrailingNone from MQL5        |
//| base framework                                                   |
//+------------------------------------------------------------------+
class CTrailingNone_eLib : public CTrailingNone
  {
public:
                     CTrailingNone_eLib(void);
                    ~CTrailingNone_eLib(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTrailingNone_eLib::CTrailingNone_eLib(void) : CTrailingNone()
  {
   m_has_tf_significance = false;
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CTrailingNone_eLib::~CTrailingNone_eLib(void)
  {
  }
//+------------------------------------------------------------------+