//+------------------------------------------------------------------+
/// @file    SignalITF_eLib.mqh
/// @brief   Time-based filtering signal class for trading signals.
/// @details This class filters trading signals according to minute, hour,
///          day of the week, and month constraints. It acts as a wrapper
///          around another signal and only allows it to pass if the time
///          conditions are met.
///
/// @author  Lucas Troncy
/// @date    2025
//+------------------------------------------------------------------+
#include <Expert\Expert_eLib\ExpertSignalMultiP.mqh>

//+------------------------------------------------------------------+
/// @class   CSignalITF_eLib
/// @brief   Intraday time filter signal class.
/// @details Filters signals based on time constraints: specific minutes,
///          hours, days of the week, and months. Inherits from
///          CExpertSignalMultiP and can wrap another signal.
///          All filters are optional and can be used independently.
//+------------------------------------------------------------------+
class CSignalITF_eLib : public CExpertSignalMultiP
  {
protected:
   int   m_good_minute_of_hour;   ///< Allowed minute of the hour (-1 = ignore)
   long  m_bad_minutes_of_hour;   ///< Bitmask of disallowed minutes
   int   m_good_hour_of_day;      ///< Allowed hour of the day (-1 = ignore)
   int   m_bad_hours_of_day;      ///< Bitmask of disallowed hours
   int   m_good_day_of_week;      ///< Allowed day of the week (-1 = ignore)
   int   m_bad_days_of_week;      ///< Bitmask of disallowed days (0 = Sunday)
   int   m_good_month_of_year;    ///< Allowed month (1–12, -1 = ignore)
   int   m_bad_months_of_year;    ///< Bitmask of disallowed months (0 = January)

public:
   /// @brief Constructor
   CSignalITF_eLib(void);

   /// @brief Destructor
   ~CSignalITF_eLib(void);
   
   /// @brief Sets the allowed minute of the hour.
   /// @param value Minute value (0–59), or -1 to disable the filter.
   void GoodMinuteOfHour(int value)  { m_good_minute_of_hour = value; }

   /// @brief Sets the disallowed minutes as a bitmask.
   /// @param value Bitmask for minutes (bit 0 = 00:00, bit 59 = 00:59).
   void BadMinutesOfHour(long value) { m_bad_minutes_of_hour = value; }

   /// @brief Sets the allowed hour of the day.
   /// @param value Hour value (0–23), or -1 to disable the filter.
   void GoodHourOfDay(int value)     { m_good_hour_of_day = value; }

   /// @brief Sets the disallowed hours as a bitmask.
   /// @param value Bitmask for hours (bit 0 = 00h, bit 23 = 23h).
   void BadHoursOfDay(int value)     { m_bad_hours_of_day = value; }

   /// @brief Sets the allowed day of the week.
   /// @param value Day value (0 = Sunday, 6 = Saturday), or -1 to disable.
   void GoodDayOfWeek(int value)     { m_good_day_of_week = value; }

   /// @brief Sets the disallowed days as a bitmask.
   /// @param value Bitmask for days (bit 0 = Sunday, bit 6 = Saturday).
   void BadDaysOfWeek(int value)     { m_bad_days_of_week = value; }

   /// @brief Sets the allowed month of the year.
   /// @param value Month (1 = January, 12 = December), or -1 to disable.
   void GoodMonthOfYear(int value)   { m_good_month_of_year = value; }

   /// @brief Sets the disallowed months as a bitmask.
   /// @param value Bitmask for months (bit 0 = January, bit 11 = December).
   void BadMonthsOfYear(int value)   { m_bad_months_of_year = value; }

   /// @brief Computes the signal direction.
   /// @return The signal score if all time filters pass; otherwise EMPTY_VALUE.
   virtual double Direction(void);
  };

//+------------------------------------------------------------------+
/// @brief Constructor implementation.
/// @details Initializes all filters to their default (inactive) values.
//+------------------------------------------------------------------+
CSignalITF_eLib::CSignalITF_eLib(void) :
   m_good_minute_of_hour(-1),
   m_bad_minutes_of_hour(0),
   m_good_hour_of_day(-1),
   m_bad_hours_of_day(0),
   m_good_day_of_week(-1),
   m_bad_days_of_week(0),
   m_good_month_of_year(-1),
   m_bad_months_of_year(0)
   //,
   //m_symbol_gmt_offset(-1),
   //m_broker_gmt_offset(0),
   //m_hour_adjustment(0)   
  {
   m_has_tf_significance = false;
  }

//+------------------------------------------------------------------+
/// @brief Destructor implementation.
//+------------------------------------------------------------------+
CSignalITF_eLib::~CSignalITF_eLib(void)
  {
  }
//+------------------------------------------------------------------+
/// @brief Main logic to evaluate time-based filters.
/// @details If any active time filter fails, the method returns EMPTY_VALUE.
///          Otherwise, it delegates to the parent signal's Direction method.
/// @return Signal score or EMPTY_VALUE if a filter blocks it.
//+------------------------------------------------------------------+
double CSignalITF_eLib::Direction(void)
  {
   MqlDateTime s_time;
   TimeCurrent(s_time);

  //int corrected_hour = (s_time.hour + m_hour_adjustment + 24) % 24;

   //--- check months conditions
   if(!((m_good_month_of_year == -1 || m_good_month_of_year == s_time.mon) &&
        !(m_bad_months_of_year & (1 << (s_time.mon - 1)))))
      return(EMPTY_VALUE);

   //--- check days conditions
   if(!((m_good_day_of_week == -1 || m_good_day_of_week == s_time.day_of_week) &&
        !(m_bad_days_of_week & (1 << s_time.day_of_week))))
      return(EMPTY_VALUE);

   //--- check hours conditions
   if(!((m_good_hour_of_day == -1 || m_good_hour_of_day == s_time.hour) &&
        !(m_bad_hours_of_day & (1 << s_time.hour))))
      return(EMPTY_VALUE);

   //--- check minutes conditions
   if(!((m_good_minute_of_hour == -1 || m_good_minute_of_hour == s_time.min) &&
        !(m_bad_minutes_of_hour & (1 << s_time.min))))
      return(EMPTY_VALUE);

   //-- If the trading time is validated, call of the Direction() method on SignalITF_eLib and its filters
   double direction = CExpertSignalMultiP::Direction();
   return direction;
  }
