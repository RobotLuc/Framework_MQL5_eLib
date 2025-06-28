//+------------------------------------------------------------------+
//|                                      MoneySizeOptimized_eLib.mqh |
//|                                     Copyright 2025, Lucas TRONCY |
//+------------------------------------------------------------------+
#include <Expert/Money/MoneySizeOptimized.mqh>
//+------------------------------------------------------------------+
//| Class CMoneySizeOptimized_eLib.                                  |
//| Simple extension "placeholder" of CMoneySizeOptimized from MQL5  |
//| base framework                                                   |
//+------------------------------------------------------------------+
class CMoneySizeOptimized_eLib : public CMoneySizeOptimized
  {
public:
                     CMoneySizeOptimized_eLib(void);
                    ~CMoneySizeOptimized_eLib(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CMoneySizeOptimized_eLib::CMoneySizeOptimized_eLib(void) : CMoneySizeOptimized()
  {
   m_has_tf_significance = false;
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CMoneySizeOptimized_eLib::~CMoneySizeOptimized_eLib(void)
  {
  }
//+------------------------------------------------------------------+