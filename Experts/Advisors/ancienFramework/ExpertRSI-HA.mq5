//+------------------------------------------------------------------+
// Titre du fichier : ExpertRSI-HA.mqh
// Contenu du fichier :
//   * type : Expert Advisor MQL5
//   * nom : ExpertRSI-HA
//+------------------------------------------------------------------+
#property version   "1.00"
//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include <Expert\ExpertAsymetrique.mqh>
#include <Expert\Signal\SignalITF.mqh>
#include <Expert\Signal\SignalRSI-LTR.mqh>
#include <Expert\Signal\SignalHA_Am.mqh>
#include <Expert\Signal\SignalMA.mqh>
#include <Expert\Trailing\TrailingNone.mqh>
#include <Expert\Money\MoneyFixedLot.mqh>
//+------------------------------------------------------------------+
//| Inputs                                                           |
//+------------------------------------------------------------------+
//--- inputs for expert
input string Inp_Expert_Title            ="ExpertRSI-HA";// Nom du robot
input int    Expert_MagicNumber          =120300;           // Nombre magique du robot
input bool   Expert_EveryTick            =false;            // Le robot est-il appelé à chaque tick ?
input int    Inp_TakeProfit  =500;            // Take Profit des positions prises avec le signal, en points
input int    Inp_StopLoss    =200;            // Stop loss des posisions prises avec le signal, en points

//--- inputs for signal HA 1
input ENUM_TIMEFRAMES    Inp_Timeframe_HA1 = PERIOD_H4;  // Temporalité du signal ouverture HA 1
input int    Inp_HA1_Poids_Motif_0=100;                  // Poids :  "Bougie Cul plat"
input int    Inp_HA1_Poids_Motif_1=0;                    // Poids :  "Bougie Doji"
input double Inp_BCBody1 = 100;                          // Nombre de points du corps de bougie
input double Inp_BCWick1 = 2;                            // Nombre max. de points de la mèche de bougie cul plat

//--- inputs for signal HA 2
input ENUM_TIMEFRAMES    Inp_Timeframe_HA2 = PERIOD_H1;  // Temporalité du signal ouverture HA 2
input int    Inp_HA2_Poids_Motif_0=100;                  // Poids :  "Bougie Cul plat"
input int    Inp_HA2_Poids_Motif_1=0;                    // Poids :  "Bougie Doji"
input double Inp_BCBody2 = 100;                          // Nombre de points du corps de bougie
input double Inp_BCWick2 = 2;                            // Nombre max. de points de la mèche de bougie cul plat

//--- inputs for signal HA 3
input ENUM_TIMEFRAMES    Inp_Timeframe_HA3 = PERIOD_M15; // Temporalité du signal ouverture HA 3
input int    Inp_HA3_Poids_Motif_0=100;                  // Poids :  "Bougie Cul plat"
input int    Inp_HA3_Poids_Motif_1=0;                    // Poids :  "Bougie Doji"
input double Inp_BCBody3 = 100;                          // Nombre de points du corps de bougie
input double Inp_BCWick3 = 2;                            // Nombre max. de points de la mèche de bougie cul plat

//--- inputs for Signal RSI
input ENUM_TIMEFRAMES    Inp_Timeframe_RSI = PERIOD_M5;  // Temporalité du signal RSI ouverture 
input int    Inp_Periode_RSI  =14;                       // Nombre de périodes pour le calcul du RSI
input ENUM_APPLIED_PRICE    Inp_Applied  =PRICE_WEIGHTED;// Prix utilisé pour calcul du RSI
input double Inp_SeuilRSI_Sur_Vendu = 35.0;             // Seuil en-dessous duquel le marché est considéré survendu
input double Inp_SeuilRSI_Sur_Achete = 65.0;            // Seuil en-dessus duquel le marché est considéré suracheté

//input bool Inp_UsePattern0_RSI = false;                  // Activer Motif "RSI à la hausse/baisse"
//input bool Inp_UsePattern1_RSI = true;                   // Activer motif "Renv. derrière niv. de sur achat/vente"
//input bool Inp_UsePattern2_RSI = false;                  // Activer motif "Swing échoué"
//input bool Inp_UsePattern3_RSI = true;                  // Activer motif "Diverg. Prix - RSI"
//input bool Inp_UsePattern4_RSI = false;                  // Activer motif "Double div. Prix - RSI"
//input bool Inp_UsePattern5_RSI = false;                  // Activer motif "Tête - épaules"

input int    Inp_Poids_Motif_0=0;                       // Poids : "L'oscillateur a la direction requise"
input int    Inp_Poids_Motif_1=100;                     // Poids : "Renversement derrière le niveau de surachat/survente"
input int    Inp_Poids_Motif_2=0;                       // Poids : "Swing échoué"
input int    Inp_Poids_Motif_3=100;                     // Poids : "Divergence Prix-RSI"
input int    Inp_Poids_Motif_4=0;                       // Poids : "Double divergence Prix-RSI"
input int    Inp_Poids_Motif_5=0;                       // Poids : "Motif Tête/épaules"

//--- inputs for signal HA fermeture
input ENUM_TIMEFRAMES    Inp_Timeframe_HAf = PERIOD_H4;  // Temporalité du signal fermeture HA
input int    Inp_HAf_Poids_Motif_0=100;                  // Poids :  "Bougie Cul plat"
input int    Inp_HAf_Poids_Motif_1=0;                    // Poids :  "Bougie Doji"
input double Inp_BCBodyf = 100;                          // Nombre de points du corps de bougie
input double Inp_BCWickf = 2;                            // Nombre max. de points de la mèche de bougie cul plat

//--- inputs for Signal RSI fermeture
input ENUM_TIMEFRAMES    Inp_Timeframe_RSIf = PERIOD_M5;  // Temporalité du signal RSI fermeture 
input int    Inp_Periode_RSIf  =14;                       // Nombre de périodes pour le calcul du RSI
input ENUM_APPLIED_PRICE    Inp_Appliedf  =PRICE_WEIGHTED;// Prix utilisé pour calcul du RSI
input double Inp_SeuilRSI_Sur_Venduf = 35.0;             // Seuil en-dessous duquel le marché est considéré survendu
input double Inp_SeuilRSI_Sur_Achetef = 65.0;            // Seuil en-dessus duquel le marché est considéré suracheté

//input bool Inp_UsePattern0_RSIf = false;                  // Activer Motif "RSI à la hausse/baisse"
//input bool Inp_UsePattern1_RSIf = true;                   // Activer motif "Renv. derrière niv. de sur achat/vente"
//input bool Inp_UsePattern2_RSIf = false;                  // Activer motif "Swing échoué"
//input bool Inp_UsePattern3_RSIf = true;                  // Activer motif "Diverg. Prix - RSI"
//input bool Inp_UsePattern4_RSIf = false;                  // Activer motif "Double div. Prix - RSI"
//input bool Inp_UsePattern5_RSIf = false;                  // Activer motif "Tête - épaules"

input int    Inp_Poids_Motif_0f=0;                       // Poids : "L'oscillateur a la direction requise"
input int    Inp_Poids_Motif_1f=100;                      // Poids : "Renversement derrière le niveau de surachat/survente"
input int    Inp_Poids_Motif_2f=0;                       // Poids : "Swing échoué"
input int    Inp_Poids_Motif_3f=100;                     // Poids : "Divergence Prix-RSI"
input int    Inp_Poids_Motif_4f=0;                       // Poids : "Double divergence Prix-RSI"
input int    Inp_Poids_Motif_5f=0;                       // Poids : "Motif Tête/épaules"

//---inputs for Money
input double nbr_lots = 3.0;                  // Nombre de lots pris à chaque position
input int    Inp_SeuilOuverture = 100;         // Note minimale pour ouvrir une position (long ou short)
input int    Inp_SeuilFermeture = 100;         // Note minimale pour clore la position (long ou short)

input bool Inp_Ouvert_Lundi    = true;                  // Trader le lundi
input bool Inp_Ouvert_Mardi    = true;                  // Trader le mardi
input bool Inp_Ouvert_Mercredi = true;                  // Trader le mercredi
input bool Inp_Ouvert_Jeudi    = true;                  // Trader le jeudi
input bool Inp_Ouvert_Vendredi = true;                  // Trader le vendredi
input bool Inp_Ouvert_Samedi   = false;                 // Trader le samedi
input bool Inp_Ouvert_Dimanche = false;                 // Trader le dimanche

input int  Inp_Heure_Ouverture = 8;      // Heure d'ouverture du marché
input int  Inp_Heure_Fermeture = 17;     // Heure de fermeture du marché
input int  Inp_Debut_Pause_Dej = -1;     // Heure début déjeuner (-1 : pas de déjeuner)
input int  Inp_Fin_Pause_Dej = -1;       // Heure fin déjeuner (-1 : pas de déjeuner)

//+------------------------------------------------------------------+
//| Global expert object                                             |
//+------------------------------------------------------------------+
CExpert ExtExpert;
//+------------------------------------------------------------------+
//| Initialization function of the expert                            |
//+------------------------------------------------------------------+
int OnInit(void)
  {    
  
//--- Initializing expert
   if(!ExtExpert.Init(Symbol(),Period(),Expert_EveryTick,Expert_MagicNumber))
     {
      //--- failed
      printf(__FUNCTION__+": error initializing expert");
      ExtExpert.Deinit();
      return(-1);
     }

//--- Creation of open and close signal objects : base is always ITF signal
   CSignalITF *signal_open = new CSignalITF;
   CSignalITF *signal_close = new CSignalITF;  
 
   if(signal_open==NULL || signal_close == NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating signal ITF");
      ExtExpert.Deinit();
      return(-2);
     }  

//--- Creation of filters signal objects on open signal
   CSignalHAm *f1_signal_open=new CSignalHAm;
   CSignalHAm *f2_signal_open=new CSignalHAm;   
   CSignalHAm *f3_signal_open=new CSignalHAm;
   CSignalRSI *f4_signal_open=new CSignalRSI;

//--- Creation of filters signal objects on close signal  
   CSignalHAm *f1_signal_close = new CSignalHAm;
   CSignalRSI *f2_signal_close = new CSignalRSI;  
   
   if(f1_signal_open==NULL || 
         f2_signal_open ==NULL || 
            f3_signal_open ==NULL ||             
               f4_signal_open ==NULL ||             
            f1_signal_close == NULL ||
         f2_signal_close == NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating signal added to ITF Signal");
      ExtExpert.Deinit();
      return(-2);
     }
     
//--- Add signal to expert (will be deleted automatically))
   if(!ExtExpert.InitSignalOpen(signal_open) || !ExtExpert.InitSignalClose(signal_close))
     {
      //--- failed
      printf(__FUNCTION__+": error initializing signal");
      ExtExpert.Deinit();
      return(-3);
     }
               
//--- Ajouter filtre au signal d'entrée
   if(!signal_open.AddFilter(f1_signal_open) || 
         !signal_open.AddFilter(f2_signal_open) ||
                     !signal_open.AddFilter(f3_signal_open) ||
                              !signal_open.AddFilter(f4_signal_open))
   {
      Print("Erreur lors de l'ajout de filtres au signal_open !");
      return INIT_FAILED;
   }     

//--- Ajouter filtre au signal de sortie
   if(!signal_close.AddFilter(f1_signal_close) || !signal_close.AddFilter(f2_signal_close))
   {
      Print("Erreur lors de l'ajout de filtres au signal_close !");
      return INIT_FAILED;
   }

//---- Réglage des signaux

/////////
// ATTENTION - MANQUE SIGNAL CLOSE
//////


//--- Set signals period  
   if (!f4_signal_open.Period(Inp_Timeframe_RSI) ||
         !f1_signal_open.Period(Inp_Timeframe_HA1) ||
            !f2_signal_open.Period(Inp_Timeframe_HA2) ||
               !f3_signal_open.Period(Inp_Timeframe_HA3) || 
                  !f1_signal_close.Period(Inp_Timeframe_HAf) ||
                     !f2_signal_close.Period(Inp_Timeframe_RSIf)
       )     
     {
      //--- failed
      printf(__FUNCTION__+": error setting timeframe filter signals");
      ExtExpert.Deinit();
      return(-4);
     } 

//---- Temporal filter parameters setting
   signal_open.BadDaysOfWeek(CUtilsLTR::EncodeDaysClosed(
      Inp_Ouvert_Dimanche,
      Inp_Ouvert_Lundi,
      Inp_Ouvert_Mardi,
      Inp_Ouvert_Mercredi,
      Inp_Ouvert_Jeudi,
      Inp_Ouvert_Vendredi,
      Inp_Ouvert_Samedi
   ));
   
   signal_open.BadHoursOfDay(CUtilsLTR::GenerateBadHoursOfDay(
      Inp_Heure_Ouverture,
      Inp_Heure_Fermeture,
      Inp_Debut_Pause_Dej,
      Inp_Fin_Pause_Dej
      ));
   
   signal_close.BadDaysOfWeek(CUtilsLTR::EncodeDaysClosed(
      Inp_Ouvert_Dimanche,
      Inp_Ouvert_Lundi,
      Inp_Ouvert_Mardi,
      Inp_Ouvert_Mercredi,
      Inp_Ouvert_Jeudi,
      Inp_Ouvert_Vendredi,
      Inp_Ouvert_Samedi
   ));
   signal_close.BadHoursOfDay(CUtilsLTR::GenerateBadHoursOfDay(
      Inp_Heure_Ouverture,
      Inp_Heure_Fermeture,
      Inp_Debut_Pause_Dej,
      Inp_Fin_Pause_Dej
      ));
      
//---- Trading signal setting     
   signal_open.ThresholdOpen(Inp_SeuilOuverture);
   signal_open.ThresholdClose(Inp_SeuilFermeture);
   
   signal_close.ThresholdOpen(Inp_SeuilOuverture);
   signal_close.ThresholdClose(Inp_SeuilFermeture);
      
   signal_open.TakeLevel(Inp_TakeProfit);
   signal_open.StopLevel(Inp_StopLoss);
   
   signal_close.TakeLevel(Inp_TakeProfit);
   signal_close.StopLevel(Inp_StopLoss);       
     
//--- Set signal_open parameters

   f1_signal_open.Pattern_0(Inp_HA1_Poids_Motif_0);
   f1_signal_open.Pattern_1(Inp_HA1_Poids_Motif_1);
   f1_signal_open.BCBody(Inp_BCBody1);
   f1_signal_open.BCWick_bottom(Inp_BCWick1);

   f2_signal_open.Pattern_0(Inp_HA2_Poids_Motif_0);
   f2_signal_open.Pattern_1(Inp_HA2_Poids_Motif_1);
   f2_signal_open.BCBody(Inp_BCBody2);
   f2_signal_open.BCWick_bottom(Inp_BCWick2);

   f3_signal_open.Pattern_0(Inp_HA3_Poids_Motif_0);
   f3_signal_open.Pattern_1(Inp_HA3_Poids_Motif_1);
   f3_signal_open.BCBody(Inp_BCBody3);
   f3_signal_open.BCWick_bottom(Inp_BCWick3);

   bool motifs_RSI_utilises[] = {
      Inp_Poids_Motif_0==0?false:true,
      Inp_Poids_Motif_1==0?false:true,
      Inp_Poids_Motif_2==0?false:true,
      Inp_Poids_Motif_3==0?false:true,
      Inp_Poids_Motif_4==0?false:true,
      Inp_Poids_Motif_5==0?false:true,
   };

   f4_signal_open.PeriodRSI(Inp_Periode_RSI);
   f4_signal_open.Applied(Inp_Applied);
   f4_signal_open.PatternsUsage(CUtilsLTR::EncodeBitmask(motifs_RSI_utilises));
   f4_signal_open.Pattern_0(Inp_Poids_Motif_0);
   f4_signal_open.Pattern_1(Inp_Poids_Motif_1);
   f4_signal_open.Pattern_2(Inp_Poids_Motif_2);
   f4_signal_open.Pattern_3(Inp_Poids_Motif_3);
   f4_signal_open.Pattern_4(Inp_Poids_Motif_4);
   f4_signal_open.Pattern_5(Inp_Poids_Motif_5);
   f4_signal_open.SeuilSurAchete(Inp_SeuilRSI_Sur_Achete);
   f4_signal_open.SeuilSurVendu(Inp_SeuilRSI_Sur_Vendu);

//--- Set signal_close parameters
   f1_signal_close.Pattern_0(Inp_HAf_Poids_Motif_0);
   f1_signal_close.Pattern_1(Inp_HAf_Poids_Motif_1);
   f1_signal_close.BCBody(Inp_BCBodyf);
   f1_signal_close.BCWick_bottom(Inp_BCWickf);

   bool motifs_RSIf_utilises[] = {
      Inp_Poids_Motif_0f==0?false:true,
      Inp_Poids_Motif_1f==0?false:true,
      Inp_Poids_Motif_2f==0?false:true,
      Inp_Poids_Motif_3f==0?false:true,
      Inp_Poids_Motif_4f==0?false:true,
      Inp_Poids_Motif_5f==0?false:true,
   };

   f2_signal_close.PeriodRSI(Inp_Periode_RSIf);
   f2_signal_close.Applied(Inp_Appliedf);
   f2_signal_close.PatternsUsage(CUtilsLTR::EncodeBitmask(motifs_RSIf_utilises));
   f2_signal_close.Pattern_0(Inp_Poids_Motif_0f);
   f2_signal_close.Pattern_1(Inp_Poids_Motif_1f);
   f2_signal_close.Pattern_2(Inp_Poids_Motif_2f);
   f2_signal_close.Pattern_3(Inp_Poids_Motif_3f);
   f2_signal_close.Pattern_4(Inp_Poids_Motif_4f);
   f2_signal_close.Pattern_5(Inp_Poids_Motif_5f);
   f2_signal_close.SeuilSurAchete(Inp_SeuilRSI_Sur_Achetef);
   f2_signal_close.SeuilSurVendu(Inp_SeuilRSI_Sur_Venduf);

//--- Check signal parameters
   if(!signal_open.ValidationSettings() || !signal_close.ValidationSettings())
     {
      //--- failed
      printf(__FUNCTION__+": error signal parameters");
      ExtExpert.Deinit();
      return(-5);
     }
//--- Check filter parameters
   if(!f1_signal_open.ValidationSettings() || 
   !f2_signal_open.ValidationSettings() ||
   !f3_signal_open.ValidationSettings() ||
   !f4_signal_open.ValidationSettings() ||
   !f1_signal_close.ValidationSettings() ||
   !f2_signal_close.ValidationSettings())
     {
      //--- failed
      printf(__FUNCTION__+": error signal filter parameters");
      ExtExpert.Deinit();
      return(-5);
     }         
     
//--- Creation of trailing object
   CTrailingNone *trailing=new CTrailingNone;
   if(trailing==NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating trailing");
      ExtExpert.Deinit();
      return(-6);
     }
//--- Add trailing to expert (will be deleted automatically))
   if(!ExtExpert.InitTrailing(trailing))
     {
      //--- failed
      printf(__FUNCTION__+": error initializing trailing");
      ExtExpert.Deinit();
      return(-7);
     }
//--- Set trailing parameters
//--- Check trailing parameters
   if(!trailing.ValidationSettings())
     {
      //--- failed
      printf(__FUNCTION__+": error trailing parameters");
      ExtExpert.Deinit();
      return(-8);
     }
//--- Creation of money object
   CMoneyFixedLot *money=new CMoneyFixedLot;
   if(money==NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating money");
      ExtExpert.Deinit();
      return(-9);
     }
//--- Add money to expert (will be deleted automatically))
   if(!ExtExpert.InitMoney(money))
     {
      //--- failed
      printf(__FUNCTION__+": error initializing money");
      ExtExpert.Deinit();
      return(-10);
     }
//--- Set money parameters
   money.Lots(nbr_lots);
   
//--- Check money parameters
   if(!money.ValidationSettings())
     {
      //--- failed
      printf(__FUNCTION__+": error money parameters");
      ExtExpert.Deinit();
      return(-11);
     }
    
//--- Setting Expert Period
   if(!ExtExpert.Period(MathMin(signal_open.SignalMinPeriod(),signal_close.SignalMinPeriod())))
     {
      //--- failed
      printf(__FUNCTION__+": error setting expert period");
      ExtExpert.Deinit();
      return(-12);
     }
     else {
     
     printf(__FUNCTION__+": ok setting expert period : %i", MathMin(signal_open.SignalMinPeriod(),signal_close.SignalMinPeriod()));
     }             
          
//--- Tuning of all necessary indicators
   if(!ExtExpert.InitIndicators())
     {
      //--- failed
      printf(__FUNCTION__+": error initializing indicators");
      ExtExpert.Deinit();
      return(-13);
     }
     
   Print("TERMINAL_PATH = ",TerminalInfoString(TERMINAL_PATH)); 
   Print("TERMINAL_DATA_PATH = ",TerminalInfoString(TERMINAL_DATA_PATH)); 
   Print("TERMINAL_COMMONDATA_PATH = ",TerminalInfoString(TERMINAL_COMMONDATA_PATH)); 
//--- succeed
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Deinitialization function of the expert                          |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   ExtExpert.Deinit();
  }
//+------------------------------------------------------------------+
//| Function-event handler "tick"                                    |
//+------------------------------------------------------------------+
void OnTick(void)
  {
   ExtExpert.OnTick();
  }
//+------------------------------------------------------------------+
//| Function-event handler "trade"                                   |
//+------------------------------------------------------------------+
void OnTrade(void)
  {
   ExtExpert.OnTrade();
  }
//+------------------------------------------------------------------+
//| Function-event handler "timer"                                   |
//+------------------------------------------------------------------+
void OnTimer(void)
  {
   ExtExpert.OnTimer();
  }
//+------------------------------------------------------------------+
// Fin du fichier ExpertRSI.mqh
//+------------------------------------------------------------------+