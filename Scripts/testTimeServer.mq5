//+------------------------------------------------------------------+
//|                                               testTimeServer.mq5 |
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
//--- déclare la variable MqlDateTime à remplir avec des données de date/heure et obtient l'heure de la dernière cotation et l'heure actuelle estimée du serveur de trading 
   MqlDateTime tm={}; 
   datetime    time_current=TimeCurrent();                  // première forme de l'appel : heure de la dernière cotation d'un des symboles de la fenêtre du Market Watch  
   datetime    time_server =TimeTradeServer(tm);            // deuxième forme d'appel : heure actuelle estimée du serveur de trading avec le remplissage de la structure MqlDateTime 
   int         difference  =int(time_current-time_server);  // différence entre Time Current et Time Trade Server 
    
//--- affiche l'heure de la dernière cotation et l'heure actuelle estimée du serveur de trading avec les données de la structure MqlDateTime remplie dans le journal 
   PrintFormat("Time Current: %s\nTime Trade Server: %s\n- Year: %u\n- Month: %02u\n- Day: %02u\n"+ 
               "- Hour: %02u\n- Min: %02u\n- Sec: %02u\n- Day of Year: %03u\n- Day of Week: %u (%s)\nDifference between Time Current and Time Trade Server: %+d", 
               (string)time_current, (string)time_server, tm.year, tm.mon, tm.day, tm.hour, tm.min, tm.sec, tm.day_of_year, tm.day_of_week, 
               EnumToString((ENUM_DAY_OF_WEEK)tm.day_of_week), difference); 
  /* 
  Résultat : 
   Time Current: 2024.04.18 16:10:14 
   Time Trade Server: 2024.04.18 16:10:15 
   - Year: 2024 
   - Month: 04 
   - Day: 18 
   - Hour: 16 
   - Min: 10 
   - Sec: 15 
   - Day of Year: 108 
   - Day of Week: 4 (THURSDAY) 
   Difference between Time Current and Time Trade Server: -1 
  */ 
  }
//+------------------------------------------------------------------+
