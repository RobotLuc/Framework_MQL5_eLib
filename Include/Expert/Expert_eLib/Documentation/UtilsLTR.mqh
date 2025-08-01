//+------------------------------------------------------------------+
//|                                              CUtilsLTR.mqh       |
//|                         Utilitaires généraux pour EA MQL5        |
//|                                                                  |
//| Description :                                                    |
//|   - Fonctions statiques diverses (PGCD, bitmask, etc.)           |
//|   - Classe interne CJournal pour logging fichier                 |
//+------------------------------------------------------------------+
#ifndef __CUTILSLTR_MQH__
#define __CUTILSLTR_MQH__
//+------------------------------------------------------------------+
//| Utility class for static methods (bitmasking, time conversion)   |
//+------------------------------------------------------------------+
class CUtilsLTR
  {
public:
   /**
    * @brief Compute the greatest common divisor (GCD) of two integers.
    * @param a First integer
    * @param b Second integer
    * @return The GCD of a and b
    */
   static int GCD(int a, int b);

   /**
    * @brief Convert a timeframe enum into its duration in minutes.
    * @param period ENUM_TIMEFRAMES value
    * @return Equivalent number of minutes
    */
   static int TimeframeToMinutes(ENUM_TIMEFRAMES period);

   /**
    * @brief Convert a duration in minutes to its associated OBJ_PERIOD_* flag.
    * @param minutes Timeframe duration in minutes
    * @return Corresponding OBJ_PERIOD_* flag, or WRONG_VALUE if not supported
    */
   static int ConvertMinutesToFlag(int minutes);

   /**
    * @brief Encode closed trading days into a bitmask from a boolean array.
    * @param jours_ouverts Boolean array of 7 elements, one per weekday (Sunday to Saturday)
    * @return Bitmask with bits set for closed days (bit i = 1 if day i is closed)
    */
   static int EncodeDaysClosed(const bool &jours_ouverts[]);

   /**
    * @brief Encode closed trading days into a bitmask from individual booleans.
    * @param dimanche Closed on Sunday
    * @param lundi Closed on Monday
    * @param mardi Closed on Tuesday
    * @param mercredi Closed on Wednesday
    * @param jeudi Closed on Thursday
    * @param vendredi Closed on Friday
    * @param samedi Closed on Saturday
    * @return Bitmask with bits set for closed days (bit i = 1 if day i is closed)
    */
   static int EncodeDaysClosed(bool dimanche, bool lundi, bool mardi,
                               bool mercredi, bool jeudi, bool vendredi, bool samedi);

   /**
    * @brief Generate a bitmask of closed hours in a day.
    * @param ouverture Hour (0–23) when trading opens
    * @param fermeture Hour (0–24) when trading closes
    * @param pause_debut Optional pause start hour (default = -1 = none)
    * @param pause_fin Optional pause end hour (default = -1 = none)
    * @return Bitmask with bits set for hours that are closed
    */
   static int GenerateBadHoursOfDay(int ouverture, int fermeture, int pause_debut = -1, int pause_fin = -1);

   /**
    * @brief Encode a boolean pattern array into a bitmask.
    * @param patterns Boolean array (length n) where each true sets bit i
    * @return Bitmask representation
    */
   static int EncodeBitmask(const bool &patterns[]);

   /**
    * @brief Log a message to a text file on the Desktop (via CJournal).
    * @param logMessage The message to log
    */
   static void LogToDesktop(const string &logMessage);

   /**
    * @brief Placeholder method. Does nothing in this version.
    */
   static void Close();

   /**
    * @brief Encode closed months into a bitmask.
    * @param months Boolean array of 12 elements where each element represents if the corresponding month is open (January to December)
    * @return Bitmask with bits set for closed months (bit i = 1 if month i is closed)
    */
   static int EncodeMonthsClosed(const bool &months[]);

   /**
    * @brief Encode closed months into a bitmask from individual boolean flags.
    * @param jan Closed in January
    * @param feb Closed in February
    * @param mar Closed in March
    * @param apr Closed in April
    * @param may Closed in May
    * @param jun Closed in June
    * @param jul Closed in July
    * @param aug Closed in August
    * @param sep Closed in September
    * @param oct Closed in October
    * @param nov Closed in November
    * @param dec Closed in December
    * @return Bitmask with bits set for closed months (bit i = 1 if month i is closed)
    */
   static int EncodeMonthsClosed(bool jan, bool feb, bool mar, bool apr, bool may, bool jun,
                                 bool jul, bool aug, bool sep, bool oct, bool nov, bool dec);
//+---------------------------------------------------------------+
//| Internal class for file-based logging                         |
//+---------------------------------------------------------------+
   class CJournal
     {
   public:
      /**
       * @brief Write a message with timestamp to the log file.
       * @param message Message to log
       */
      static void Log(string message);

      /**
       * @brief Placeholder method. File is automatically closed after each write.
       */
      static void Close();
     };
  };

#endif // __CUTILSLTR_MQH__

#ifdef __CUTILSLTR_MQH__
//+------------------------------------------------------------------+
//|    PGCD                                                          |
//+------------------------------------------------------------------+
int CUtilsLTR::GCD(int a, int b)
  {
   while(b != 0)
     {
      int temp = b;
      b = a % b;
      a = temp;
     }
   return(a);
  }
//+------------------------------------------------------------------+
//|    Conversion timeframes -> minutes                              |
//+------------------------------------------------------------------+
int CUtilsLTR::TimeframeToMinutes(ENUM_TIMEFRAMES period)
  {
   switch(period)
     {
      case PERIOD_M1:
         return 1;
      case PERIOD_M2:
         return 2;
      case PERIOD_M3:
         return 3;
      case PERIOD_M4:
         return 4;
      case PERIOD_M5:
         return 5;
      case PERIOD_M6:
         return 6;
      case PERIOD_M10:
         return 10;
      case PERIOD_M12:
         return 12;
      case PERIOD_M15:
         return 15;
      case PERIOD_M20:
         return 20;
      case PERIOD_M30:
         return 30;
      case PERIOD_H1:
         return 60;
      case PERIOD_H2:
         return 120;
      case PERIOD_H3:
         return 180;
      case PERIOD_H4:
         return 240;
      case PERIOD_H6:
         return 360;
      case PERIOD_H8:
         return 480;
      case PERIOD_H12:
         return 720;
      case PERIOD_D1:
         return 1440;
      case PERIOD_W1:
         return 10080;
      case PERIOD_MN1:
         return 43200;
      default:
         return 0;
     }
  }
//+------------------------------------------------------------------+
//|    Conversion minutes -> OBJ_PERIOD_* (flags)                    |
//+------------------------------------------------------------------+
int CUtilsLTR::ConvertMinutesToFlag(int minutes)
  {
   switch(minutes)
     {
      case 1:
         return OBJ_PERIOD_M1;
      case 2:
         return OBJ_PERIOD_M2;
      case 3:
         return OBJ_PERIOD_M3;
      case 4:
         return OBJ_PERIOD_M4;
      case 5:
         return OBJ_PERIOD_M5;
      case 6:
         return OBJ_PERIOD_M6;
      case 10:
         return OBJ_PERIOD_M10;
      case 12:
         return OBJ_PERIOD_M12;
      case 15:
         return OBJ_PERIOD_M15;
      case 20:
         return OBJ_PERIOD_M20;
      case 30:
         return OBJ_PERIOD_M30;
      case 60:
         return OBJ_PERIOD_H1;
      case 120:
         return OBJ_PERIOD_H2;
      case 180:
         return OBJ_PERIOD_H3;
      case 240:
         return OBJ_PERIOD_H4;
      case 360:
         return OBJ_PERIOD_H6;
      case 480:
         return OBJ_PERIOD_H8;
      case 720:
         return OBJ_PERIOD_H12;
      case 1440:
         return OBJ_PERIOD_D1;
      case 10080:
         return OBJ_PERIOD_W1;
      case 43200:
         return OBJ_PERIOD_MN1;
      default:
         return WRONG_VALUE;
     }
  }

//+------------------------------------------------------------------+
//|    Bitmask des mois fermés (0 = janvier, 11 = décembre)          |
//+------------------------------------------------------------------+
int CUtilsLTR::EncodeMonthsClosed(const bool &months[])
  {
   int mask = 0;
   for(int i = 0; i < 12; i++)
      if(!months[i])
         mask |= (1 << i);
   return mask;
  }
//+------------------------------------------------------------------+
//|    Tableau des mois fermés depuis tableau bouléen                |
//+------------------------------------------------------------------+
int CUtilsLTR::EncodeMonthsClosed(bool jan, bool feb, bool mar, bool apr, bool may, bool jun,
                                  bool jul, bool aug, bool sep, bool oct, bool nov, bool dec)
  {
   bool months[12] = {jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec};
   return EncodeMonthsClosed(months);
  }
//+------------------------------------------------------------------+
//|    Bitmask des jours fermés                                      |
//+------------------------------------------------------------------+
int CUtilsLTR::EncodeDaysClosed(const bool &jours_ouverts[])
  {
   int mask = 0;
   for(int i = 0; i < 7; i++)
      if(!jours_ouverts[i])
         mask |= (1 << i);
   return mask;
  }
//+------------------------------------------------------------------+
//|    Tableau des jours fermés depuis tableau bouléen               |
//+------------------------------------------------------------------+
int CUtilsLTR::EncodeDaysClosed(bool dimanche, bool lundi, bool mardi,
                                bool mercredi, bool jeudi, bool vendredi, bool samedi)
  {
   bool j[7] = {dimanche, lundi, mardi, mercredi, jeudi, vendredi, samedi};
   return EncodeDaysClosed(j);
  }
//+------------------------------------------------------------------+
//|    Bitmask des heures fermées                                    |
//+------------------------------------------------------------------+
int CUtilsLTR::GenerateBadHoursOfDay(int ouverture, int fermeture, int pause_debut, int pause_fin)
  {
   bool heures_ouvertes[24];
   ArrayInitialize(heures_ouvertes, false);

   if(ouverture < 0 || ouverture > 23 || fermeture < 0 || fermeture > 24 || ouverture >= fermeture)
     {
      Print("Paramètres d'ouverture/fermeture invalides");
      return 0;
     }

   for(int h = ouverture; h < fermeture; h++)
      heures_ouvertes[h] = true;

   if(pause_debut >= 0 && pause_fin >= 0 && pause_debut <= pause_fin && pause_fin <= 23)
      for(int h = pause_debut; h <= pause_fin; h++)
         heures_ouvertes[h] = false;

   int mask = 0;
   for(int h = 0; h < 24; h++)
      if(!heures_ouvertes[h])
         mask |= (1 << h);

   return mask;
  }
//+------------------------------------------------------------------+
//|    Encode un tableau bouléen en bitmask                          |
//+------------------------------------------------------------------+
int CUtilsLTR::EncodeBitmask(const bool &patterns[])
  {
   int mask = 0;
   for(int i = 0; i < ArraySize(patterns); i++)
      if(patterns[i])
         mask |= (1 << i);
   return mask;
  }

//--- UTILISATION D'UN CHEMIN COMPLET POUR ÉVITER LE LOCKING FTMO ---
// NOTE : Assure-toi d'avoir "Allow Dll imports" si tu reçois une erreur 5004.
//        Sinon, le terminal FTMO peut restreindre l'accès hors MQL5\Files.
//        Ajuste le chemin ci-dessous à ta convenance.
#define RELATIVE_FILENAME  "Journal_FTMO.txt"

//--- Nouvelle version de CJournal::Log ---
// Ouvre le fichier, écrit la ligne, flush puis ferme immédiatement, évitant ainsi de garder le fichier verrouillé.
void CUtilsLTR::CJournal::Log(string message)
  {
// Ouvre le fichier en mode lecture/écriture, texte et ANSI.
   int fileHandle = FileOpen(RELATIVE_FILENAME, FILE_WRITE | FILE_READ | FILE_TXT | FILE_ANSI);
   if(fileHandle == INVALID_HANDLE)
     {
      Print("Erreur ouverture fichier ", RELATIVE_FILENAME, " : ", GetLastError());
      return;
     }

// Place le curseur à la fin pour ajouter la nouvelle entrée
   FileSeek(fileHandle, 0, SEEK_END);

   datetime currentTime = TimeCurrent();
   string timestamp = TimeToString(currentTime, TIME_DATE | TIME_MINUTES | TIME_SECONDS);
   FileWrite(fileHandle, "[" + timestamp + "] " + message);

   FileFlush(fileHandle);
   FileClose(fileHandle);
  }

// Dans cette version, CJournal::Close n'a plus rien à faire.
void CUtilsLTR::CJournal::Close()
  {
   Print("[CJournal] Close() appelé, mais non nécessaire dans la nouvelle version (fichier déjà fermé après chaque écriture).");
  }

// Appel statique externe depuis l'EA
void CUtilsLTR::LogToDesktop(const string &logMessage)
  {
   CUtilsLTR::CJournal::Log(logMessage);
  }

// La fonction Close() externe devient une simple redirection (inutile ici)
void CUtilsLTR::Close()
  {
   CUtilsLTR::CJournal::Close();
  }

#endif // __CUTILSLTR_MQH__
