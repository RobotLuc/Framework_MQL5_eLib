//+------------------------------------------------------------------+
//|                                              TrailingMA_eLib.mqh |
//+------------------------------------------------------------------+
#include <Expert/Trailing/TrailingMA.mqh>
//+------------------------------------------------------------------+
//| Class CTrailingMA_eLib.                                          |
//| Purpose: Class of trailing stops based on MA.                    |
//|              Derives from class CExpertTrailing.                 |
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
void CTrailingMA_eLib::CTrailingMA_eLib(void) : CTrailingMA()
  {
     m_has_tf_significance = true;
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
void CTrailingMA_eLib::~CTrailingMA_eLib(void)
  {
  }