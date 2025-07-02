//+------------------------------------------------------------------+
//|                                                 PositionInfo.mqh |
//|                             Copyright 2000-2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
/// @file Trade/PositionInfo.mqh
/// @brief Wrapper for MQL5 position access and formatting.
/// @details
/// This file defines the CPositionInfo class, a high-level wrapper around
/// the MQL5 native position API (PositionGetXXX). It provides simplified
/// access to trading position data and includes utilities for formatting
/// and change detection.
//+------------------------------------------------------------------+
/// @class CPositionInfo
/// @brief Wrapper class for accessing and managing trading position information.
/// @details
/// This class provides a high-level object-oriented interface to retrieve
/// properties of the current open position using MQL5 system functions
/// such as PositionGetInteger, PositionGetDouble, and PositionGetString.
///
/// It simplifies access to the current trading position and acts as a facade
/// over the native position API. Additionally, it provides snapshot capabilities
/// to store and compare the state of a position over time (e.g., for change detection).
///
/// ### Main Responsibilities:
/// - Encapsulate position property retrieval (volume, price, SL/TP, etc.)
/// - Provide formatted string descriptions of positions
/// - Allow position selection by symbol, magic number, ticket or index
/// - Store and check a snapshot of position state for comparison
///
/// ### Usage Example:
/// @code
///    CPositionInfo pos;
///    if(pos.Select(_Symbol))
///    {
///       double open = pos.PriceOpen();
///       double sl   = pos.StopLoss();
///       PrintFormat("Open: %f  SL: %f", open, sl);
///    }
/// @endcode
//+------------------------------------------------------------------+

#include <Object.mqh>
//+------------------------------------------------------------------+
//| Class CPositionInfo.                                             |
//| Appointment: Class for access to position info.                  |
//|              Derives from class CObject.                         |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
/// @class CPositionInfo
/// @brief Wrapper for accessing and monitoring trading position data.
/// @details
/// This class encapsulates all relevant information related to the current trading position.
/// It wraps around the native MQL5 functions (e.g., PositionGetInteger, PositionGetDouble)
/// to provide simplified access to position properties. It also allows for snapshot comparison
/// to detect changes in position state.
///
/// The class supports:
/// - Fast access to numeric, string, and enum-based position properties
/// - Selection of specific positions by symbol, ticket, index, or magic number
/// - State caching and change detection
/// - String formatting for display/logging
///
/// @note This class operates in read-only mode; it does not modify positions directly.
//+------------------------------------------------------------------+
class CPositionInfo : public CObject
  {
protected:
   /// @brief Stored position type (used for state comparison).
   ENUM_POSITION_TYPE m_type;

   /// @brief Stored position volume (used for state comparison).
   double            m_volume;

   /// @brief Stored position open price (used for state comparison).
   double            m_price;

   /// @brief Stored stop loss (used for state comparison).
   double            m_stop_loss;

   /// @brief Stored take profit (used for state comparison).
   double            m_take_profit;

public:
   /// @brief Default constructor.
                     CPositionInfo(void);

   /// @brief Destructor.
                    ~CPositionInfo(void);

   //--- Fast access to integer-based properties

   /// @brief Returns the ticket ID of the current position.
   ulong             Ticket(void) const;

   /// @brief Returns the open time of the position (seconds).
   datetime          Time(void) const;

   /// @brief Returns the open time of the position (milliseconds).
   ulong             TimeMsc(void) const;

   /// @brief Returns the last update time of the position (seconds).
   datetime          TimeUpdate(void) const;

   /// @brief Returns the last update time of the position (milliseconds).
   ulong             TimeUpdateMsc(void) const;

   /// @brief Returns the position type (buy/sell).
   ENUM_POSITION_TYPE PositionType(void) const;

   /// @brief Returns a string describing the position type.
   string            TypeDescription(void) const;

   /// @brief Returns the magic number of the position.
   long              Magic(void) const;

   /// @brief Returns the internal identifier of the position.
   long              Identifier(void) const;

   //--- Fast access to double-based properties

   /// @brief Returns the current volume of the position.
   double            Volume(void) const;

   /// @brief Returns the open price of the position.
   double            PriceOpen(void) const;

   /// @brief Returns the current stop loss level.
   double            StopLoss(void) const;

   /// @brief Returns the current take profit level.
   double            TakeProfit(void) const;

   /// @brief Returns the current market price of the position.
   double            PriceCurrent(void) const;

   /// @brief Returns the commission of the position (deprecated).
   double            Commission(void) const;

   /// @brief Returns the accumulated swap of the position.
   double            Swap(void) const;

   /// @brief Returns the current profit of the position.
   double            Profit(void) const;

   //--- Fast access to string-based properties

   /// @brief Returns the symbol name of the position.
   string            Symbol(void) const;

   /// @brief Returns the user-defined comment of the position.
   string            Comment(void) const;

   //--- Generic access to native MQL5 functions

   /// @brief Gets an integer property of the position.
   bool              InfoInteger(const ENUM_POSITION_PROPERTY_INTEGER prop_id,long &var) const;

   /// @brief Gets a double property of the position.
   bool              InfoDouble(const ENUM_POSITION_PROPERTY_DOUBLE prop_id,double &var) const;

   /// @brief Gets a string property of the position.
   bool              InfoString(const ENUM_POSITION_PROPERTY_STRING prop_id,string &var) const;

   //--- Utility methods

   /// @brief Converts the position type to string format.
   string            FormatType(string &str,const uint type) const;

   /// @brief Returns a full description of the current position.
   string            FormatPosition(string &str) const;

   //--- Position selection methods

   /// @brief Selects the position by symbol.
   bool              Select(const string symbol);

   /// @brief Selects a position by symbol and magic number.
   bool              SelectByMagic(const string symbol,const ulong magic);

   /// @brief Selects a position by ticket ID.
   bool              SelectByTicket(const ulong ticket);

   /// @brief Selects a position by index in the position list.
   bool              SelectByIndex(const int index);

   //--- State management

   /// @brief Stores a snapshot of the current position state.
   void              StoreState(void);

   /// @brief Compares the current position to the stored snapshot.
   bool              CheckState(void);
  };

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
/// @brief Default constructor.
/// @constructor
/// @details Initializes the internal state snapshot variables to default values.
/// These are used for later comparison via CheckState().
///
/// The constructor does not perform any position selection or API call.
/// Use Select() or related methods to load a position.
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CPositionInfo::CPositionInfo(void) : m_type(WRONG_VALUE),
   m_volume(0.0),
   m_price(0.0),
   m_stop_loss(0.0),
   m_take_profit(0.0)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CPositionInfo::~CPositionInfo(void)
  {
  }
//+------------------------------------------------------------------+
//| Get the property value "POSITION_TICKET"                         |
//+------------------------------------------------------------------+
ulong CPositionInfo::Ticket(void) const
  {
   return((ulong)PositionGetInteger(POSITION_TICKET));
  }
//+------------------------------------------------------------------+
//| Get the property value "POSITION_TIME"                           |
//+------------------------------------------------------------------+
datetime CPositionInfo::Time(void) const
  {
   return((datetime)PositionGetInteger(POSITION_TIME));
  }
//+------------------------------------------------------------------+
//| Get the property value "POSITION_TIME_MSC"                       |
//+------------------------------------------------------------------+
ulong CPositionInfo::TimeMsc(void) const
  {
   return((ulong)PositionGetInteger(POSITION_TIME_MSC));
  }
//+------------------------------------------------------------------+
//| Get the property value "POSITION_TIME_UPDATE"                    |
//+------------------------------------------------------------------+
datetime CPositionInfo::TimeUpdate(void) const
  {
   return((datetime)PositionGetInteger(POSITION_TIME_UPDATE));
  }
//+------------------------------------------------------------------+
//| Get the property value "POSITION_TIME_UPDATE_MSC"                |
//+------------------------------------------------------------------+
ulong CPositionInfo::TimeUpdateMsc(void) const
  {
   return((ulong)PositionGetInteger(POSITION_TIME_UPDATE_MSC));
  }
//+------------------------------------------------------------------+
//| Get the property value "POSITION_TYPE"                           |
//+------------------------------------------------------------------+
ENUM_POSITION_TYPE CPositionInfo::PositionType(void) const
  {
   return((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE));
  }
//+------------------------------------------------------------------+
//| Get the property value "POSITION_TYPE" as string                 |
//+------------------------------------------------------------------+
string CPositionInfo::TypeDescription(void) const
  {
   string str;
//---
   return(FormatType(str,PositionType()));
  }
//+------------------------------------------------------------------+
//| Get the property value "POSITION_MAGIC"                          |
//+------------------------------------------------------------------+
long CPositionInfo::Magic(void) const
  {
   return(PositionGetInteger(POSITION_MAGIC));
  }
//+------------------------------------------------------------------+
//| Get the property value "POSITION_IDENTIFIER"                     |
//+------------------------------------------------------------------+
long CPositionInfo::Identifier(void) const
  {
   return(PositionGetInteger(POSITION_IDENTIFIER));
  }
//+------------------------------------------------------------------+
//| Get the property value "POSITION_VOLUME"                         |
//+------------------------------------------------------------------+
double CPositionInfo::Volume(void) const
  {
   return(PositionGetDouble(POSITION_VOLUME));
  }
//+------------------------------------------------------------------+
//| Get the property value "POSITION_PRICE_OPEN"                     |
//+------------------------------------------------------------------+
double CPositionInfo::PriceOpen(void) const
  {
   return(PositionGetDouble(POSITION_PRICE_OPEN));
  }
//+------------------------------------------------------------------+
//| Get the property value "POSITION_SL"                             |
//+------------------------------------------------------------------+
double CPositionInfo::StopLoss(void) const
  {
   return(PositionGetDouble(POSITION_SL));
  }
//+------------------------------------------------------------------+
//| Get the property value "POSITION_TP"                             |
//+------------------------------------------------------------------+
double CPositionInfo::TakeProfit(void) const
  {
   return(PositionGetDouble(POSITION_TP));
  }
//+------------------------------------------------------------------+
//| Get the property value "POSITION_PRICE_CURRENT"                  |
//+------------------------------------------------------------------+
double CPositionInfo::PriceCurrent(void) const
  {
   return(PositionGetDouble(POSITION_PRICE_CURRENT));
  }
//+------------------------------------------------------------------+
//| Get the property value "POSITION_COMMISSION"                     |
//+------------------------------------------------------------------+
double CPositionInfo::Commission(void) const
  {
//--- property POSITION_COMMISSION is deprecated
   SetUserError(ERR_FUNCTION_NOT_ALLOWED);
   return(0);
  }
//+------------------------------------------------------------------+
//| Get the property value "POSITION_SWAP"                           |
//+------------------------------------------------------------------+
double CPositionInfo::Swap(void) const
  {
   return(PositionGetDouble(POSITION_SWAP));
  }
//+------------------------------------------------------------------+
//| Get the property value "POSITION_PROFIT"                         |
//+------------------------------------------------------------------+
double CPositionInfo::Profit(void) const
  {
   return(PositionGetDouble(POSITION_PROFIT));
  }
//+------------------------------------------------------------------+
//| Get the property value "POSITION_SYMBOL"                         |
//+------------------------------------------------------------------+
string CPositionInfo::Symbol(void) const
  {
   return(PositionGetString(POSITION_SYMBOL));
  }
//+------------------------------------------------------------------+
//| Get the property value "POSITION_COMMENT"                        |
//+------------------------------------------------------------------+
string CPositionInfo::Comment(void) const
  {
   return(PositionGetString(POSITION_COMMENT));
  }
//+------------------------------------------------------------------+
//| Access functions PositionGetInteger(...)                         |
//+------------------------------------------------------------------+
bool CPositionInfo::InfoInteger(const ENUM_POSITION_PROPERTY_INTEGER prop_id,long &var) const
  {
   return(PositionGetInteger(prop_id,var));
  }
//+------------------------------------------------------------------+
//| Access functions PositionGetDouble(...)                          |
//+------------------------------------------------------------------+
bool CPositionInfo::InfoDouble(const ENUM_POSITION_PROPERTY_DOUBLE prop_id,double &var) const
  {
   return(PositionGetDouble(prop_id,var));
  }
//+------------------------------------------------------------------+
//| Access functions PositionGetString(...)                          |
//+------------------------------------------------------------------+
bool CPositionInfo::InfoString(const ENUM_POSITION_PROPERTY_STRING prop_id,string &var) const
  {
   return(PositionGetString(prop_id,var));
  }
//+------------------------------------------------------------------+
//| Converts the position type to text                               |
//+------------------------------------------------------------------+
string CPositionInfo::FormatType(string &str,const uint type) const
  {
//--- see the type
   switch(type)
     {
      case POSITION_TYPE_BUY:
         str="buy";
         break;
      case POSITION_TYPE_SELL:
         str="sell";
         break;
      default:
         str="unknown position type "+(string)type;
     }
//--- return the result
   return(str);
  }
//+------------------------------------------------------------------+
//| Converts the position parameters to text                         |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
/// @brief Generates a formatted string describing the current position.
/// @details
/// Builds a human-readable string summarizing key attributes of the selected position,
/// including type, volume, symbol, open price, and optionally SL/TP if present.
///
/// The format adapts based on the account margin mode (e.g., shows ticket number in hedging mode).
///
/// @param str Reference to a string that will receive the formatted description.
/// @return The formatted string.
///
/// @note Digits are adjusted according to the symbol precision.
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string CPositionInfo::FormatPosition(string &str) const
  {
   string tmp,type;
   long   tmp_long;
   ENUM_ACCOUNT_MARGIN_MODE margin_mode=(ENUM_ACCOUNT_MARGIN_MODE)AccountInfoInteger(ACCOUNT_MARGIN_MODE);
//--- set up
   string symbol_name=this.Symbol();
   int    digits=_Digits;
   if(SymbolInfoInteger(symbol_name,SYMBOL_DIGITS,tmp_long))
      digits=(int)tmp_long;
//--- form the position description
   if(margin_mode==ACCOUNT_MARGIN_MODE_RETAIL_HEDGING)
      str=StringFormat("#%I64u %s %s %s %s",
                       Ticket(),
                       FormatType(type,PositionType()),
                       DoubleToString(Volume(),2),
                       symbol_name,
                       DoubleToString(PriceOpen(),digits+3));
   else
      str=StringFormat("%s %s %s %s",
                       FormatType(type,PositionType()),
                       DoubleToString(Volume(),2),
                       symbol_name,
                       DoubleToString(PriceOpen(),digits+3));
//--- add stops if there are any
   double sl=StopLoss();
   double tp=TakeProfit();
   if(sl!=0.0)
     {
      tmp=StringFormat(" sl: %s",DoubleToString(sl,digits));
      str+=tmp;
     }
   if(tp!=0.0)
     {
      tmp=StringFormat(" tp: %s",DoubleToString(tp,digits));
      str+=tmp;
     }
//--- return the result
   return(str);
  }
//+------------------------------------------------------------------+
//| Access functions PositionSelect(...)                             |
//+------------------------------------------------------------------+
bool CPositionInfo::Select(const string symbol)
  {
   return(PositionSelect(symbol));
  }
//+------------------------------------------------------------------+
//| Access functions SelectByMagic(...)                              |
//+------------------------------------------------------------------+
/// @brief Selects a position based on symbol and magic number.
/// @details
/// Iterates through all open positions to find one that matches both the specified
/// symbol and the given magic number. If found, the position becomes the current selection.
///
/// @param symbol The symbol to match (e.g., "EURUSD").
/// @param magic The magic number associated with the desired position.
/// @return true if a matching position is found, false otherwise.
///
/// @note In hedging mode, multiple positions can exist per symbol; this function only selects
/// the first match found.
/// This method is reliable in Netting mode, where only one position can exist per symbol.
/// In Hedging mode, it returns the first matching position found with the given magic number,
/// which may not be deterministic or unique. Use with caution in that context.
bool CPositionInfo::SelectByMagic(const string symbol,const ulong magic)
  {
   bool res=false;
   uint total=PositionsTotal();
//---
   for(uint i=0; i<total; i++)
     {
      string position_symbol=PositionGetSymbol(i);
      if(position_symbol==symbol && magic==PositionGetInteger(POSITION_MAGIC))
        {
         res=true;
         break;
        }
     }
//---
   return(res);
  }
//+------------------------------------------------------------------+
//| Access functions PositionSelectByTicket(...)                     |
//+------------------------------------------------------------------+
bool CPositionInfo::SelectByTicket(const ulong ticket)
  {
   return(PositionSelectByTicket(ticket));
  }
//+------------------------------------------------------------------+
//| Select a position on the index                                   |
//+------------------------------------------------------------------+
bool CPositionInfo::SelectByIndex(const int index)
  {
   ulong ticket=PositionGetTicket(index);
   return(ticket>0);
  }
//+------------------------------------------------------------------+
//| Stored position's current state                                  |
//+------------------------------------------------------------------+
/// @brief Stores a snapshot of the current position state.
/// @details
/// Saves key attributes of the currently selected position (type, volume, price,
/// stop loss and take profit) into internal variables. This allows detecting changes
/// later using CheckState().
///
/// @note Ensure a valid position is selected before calling this method.
void CPositionInfo::StoreState(void)
  {
   m_type       =PositionType();
   m_volume     =Volume();
   m_price      =PriceOpen();
   m_stop_loss  =StopLoss();
   m_take_profit=TakeProfit();
  }
//+------------------------------------------------------------------+
//| Check position change                                            |
//+------------------------------------------------------------------+
/// @brief Compares the current position with the stored snapshot.
/// @details
/// Checks whether any of the key attributes (type, volume, price, stop loss, take profit)
/// have changed since the last call to StoreState().
///
/// @return true if any difference is detected, false if the state is unchanged.
///
/// @note If StoreState() has not been called previously, this may yield inaccurate results.

bool CPositionInfo::CheckState(void)
  {
   if(m_type==PositionType()  &&
      m_volume==Volume()      &&
      m_price==PriceOpen()    &&
      m_stop_loss==StopLoss() &&
      m_take_profit==TakeProfit())
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
