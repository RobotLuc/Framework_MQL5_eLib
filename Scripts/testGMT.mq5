//+------------------------------------------------------------------+
//|                                                      testGMT.mq5 |
//|                                     Copyright 2025, Lucas Troncy |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Lucas Troncy"
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
   MqlDateTime tm={};
   datetime    time1=TimeLocal();            // heure locale du PC
   datetime    time2=TimeGMT(tm);            // heure GMT calculée
   int         shift=int(time1-time2)/3600;  // décalage horaire en heures

   PrintFormat("Time Local: %s\nTime GMT: %s\n- Year: %u\n- Month: %02u\n- Day: %02u\n"+
               "- Hour: %02u\n- Min: %02u\n- Sec: %02u\n- Day of Year: %03u\n- Day of Week: %u (%s)\nLocal time offset relative to GMT: %+d",
               (string)time1, (string)time2, tm.year, tm.mon, tm.day, tm.hour, tm.min, tm.sec,
               tm.day_of_year, tm.day_of_week,
               EnumToString((ENUM_DAY_OF_WEEK)tm.day_of_week), shift);
  }
//+------------------------------------------------------------------+
