//+------------------------------------------------------------------+
//|                                              testTimeCurrent.mq5 |
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
//--- déclare la variable MqlDateTime devant être remplie avec la date et l'heure, et récupère l'heure de la dernière cotation depuis la fenêtre du Market Watch 
   MqlDateTime tm={}; 
   datetime    time1=TimeCurrent();    // première forme de l'appel : l'heure de la dernière cotation de l'un des symboles de la fenêtre du Market Watch 
   datetime    time2=TimeCurrent(tm);  // deuxième forme d'appel : l'heure de la dernière cotation de l'un des symboles dans la fenêtre du Market Watch avec la structure MqlDateTime remplie 
    
//--- affiche le résultat de la réception de la date/heure et remplit la structure avec les données correspondantes dans le journal 
   PrintFormat("Tick time: %s\n- Year: %u\n- Month: %02u\n- Day: %02u\n- Hour: %02u\n- Min: %02u\n- Sec: %02u\n- Day of Year: %03u\n- Day of Week: %u (%s)", 
               (string)time1, tm.year, tm.mon, tm.day, tm.hour, tm.min, tm.sec, tm.day_of_year, tm.day_of_week, EnumToString((ENUM_DAY_OF_WEEK)tm.day_of_week)); 
  /* 
  Résultat : 
   Tick time: 2024.04.18 15:40:06 
   - Year: 2024 
   - Month: 04 
   - Day: 18 
   - Hour: 15 
   - Min: 40 
   - Sec: 06 
   - Day of Year: 108 
   - Day of Week: 4 (THURSDAY) 
  */ 
  }
//+------------------------------------------------------------------+
