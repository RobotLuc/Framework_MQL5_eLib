//+------------------------------------------------------------------+
//|                                                    testDelta.mq5 |
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
   datetime t_broker = TimeTradeServer();  // heure serveur
   datetime t_gmt    = TimeGMT();          // heure GMT calculée
   int offset_sec    = (int)(t_broker - t_gmt);
   int offset_hours  = offset_sec / 3600;

   PrintFormat("TimeTradeServer: %s", TimeToString(t_broker, TIME_DATE | TIME_MINUTES));
   PrintFormat("TimeGMT        : %s", TimeToString(t_gmt, TIME_DATE | TIME_MINUTES));
   PrintFormat("Offset broker vs GMT: %+d heures", offset_hours);
  }

//+------------------------------------------------------------------+
