//+------------------------------------------------------------------+
//| Titre du fichier:Expert-Complet-2025-07-22.mqh                   |
//| Contenu du fichier :                                             |
//|   * type : Expert Advisor MQL5                                   |
//+------------------------------------------------------------------+
#property version   "1.0"
#property copyright "Copyright 2025, Lucas Troncy"
//+------------------------------------------------------------------+
//| Includes                                                         |
//+------------------------------------------------------------------+
#include <Expert\Expert_eLib\ExpertAsymetriqueDirectionnel.mqh>
#include <Expert\Expert_eLib\Signal\BuilderSignal.mqh>
#include <Expert\Expert_eLib\Config\SignalsConfig.mqh>
#include <Expert\Expert_eLib\Config\SignalConfigFactory.mqh>
#include <Expert\Expert_eLib\Money\MoneyFixedRisk.mqh>
#include <Expert\Expert_eLib\Trailing\TrailingAmpliedPips.mqh>
//+------------------------------------------------------------------+
//| Inputs                                                           |
//+------------------------------------------------------------------+
input string Inp_Expert_Title            ="EA-Complet-2025-07-25";         // Nom du robot
input int    Expert_MagicNumber          =320000;                          // Nombre magique du robot
input bool   Expert_EveryTick            =false;                           // Le robot est-il appelé à chaque tick ?
input bool   Inp_Allow_Long              =true;                            // Le robot peut-il Longuer ?
input bool   Inp_Allow_Short             =true;                            // Le robot peut-il Shorter ?

input int    Inp_TakeProfit            = 5000;          // Take Profit des positions prises avec le signal, en points
input int    Inp_StopLoss              = 2000;          // Stop loss des positions prises avec le signal, en points
input double Inp_PourcentRisque        = 0.05;          // Risque max. (en % du compte) pris à chaque position
input int    Inp_SeuilOuverture        = 100;           // Note minimale pour ouvrir une position (long ou short)
input int    Inp_SeuilFermeture        = 100;           // Note minimale pour clore une position (long ou short)
input double Inp_Price_Level           = 0.0;           // Ecart (points) entre prix marché et bid

//--- inputs for signal HA 1
input string __SIGNAL_HA1__ = "-------------Signal Heiken Ashi 1 prise de positions------";
input bool            Inp_HA1_Active = false;               // Ce signal est-il à prendre en compte ?
input ENUM_TIMEFRAMES Inp_Timeframe_HA1     = PERIOD_H4;    // Temporalité du signal ouverture HA 1

//--- Paramétrage des motifs HA1
input bool Inp_HA1_Enabled_Motif_0 = false;    // Activer le motif 0 : Bougie directionnelle
input int  Inp_HA1_Poids_Motif_0   = 100;      // Poids : Bougie directionnelle
input bool Inp_HA1_Enabled_Motif_1 = false;    // Activer le motif 1 : Bougie grand corps
input int  Inp_HA1_Poids_Motif_1   = 100;      // Poids : Bougie grand corps
input bool Inp_HA1_Enabled_Motif_2 = false;    // Activer le motif 2 : Bougie cul plat
input int  Inp_HA1_Poids_Motif_2   = 100;      // Poids : Bougie cul plat
input bool Inp_HA1_Enabled_Motif_3 = false;    // Activer le motif 3 : Doji classique
input int  Inp_HA1_Poids_Motif_3   = 100;      // Poids : Doji classique
input bool Inp_HA1_Enabled_Motif_4 = false;    // Activer le motif 4 : Doji pied long
input int  Inp_HA1_Poids_Motif_4   = 100;      // Poids : Doji pied long
input bool Inp_HA1_Enabled_Motif_5 = false;    // Activer le motif 5 : Doji libellule / tombeau
input int  Inp_HA1_Poids_Motif_5   = 100;      // Poids : Doji libellule / tombeau

//--- Paramètres de détection des motifs
input bool   Inp_HA1_auto_fullsize   = true;  // Mode relatif (true) ou absolu (false)
input double Inp_HA1_fullsize_pts    = 0.0;   // Taille de référence en points si mode absolu
input double Inp_HA1_pct_big_body    = 0.7;   // Valeur min. pour corps bougie "grand corps" (0.7 = 70%)
input double Inp_HA1_pct_medium_body = 0.5;   // Valeur min. pour corps bougie  "cul plat"
input double Inp_HA1_pct_doji_body   = 0.1;   // Valeur max. pour corps de "doji"
input double Inp_HA1_pct_tiny_wick   = 0.05;  // Val. max. très petite mèche (doji libellule ou tombeau)
input double Inp_HA1_pct_small_wick  = 0.1;   // Val. mèche petite (min. doji simple ou max. bougie grand corps)
input double Inp_HA1_pct_long_wick   = 0.4;   // Val. min. mèche longue (cul plat / doji gd pied ou libellule)
input int    Inp_HA1_dojibefore      = 3;     // Nombre de bougies précédentes pour valider un doji

//--- inputs for signal HA 2
input string __SIGNAL_HA2__ = "-------------Signal Heiken Ashi 2 prise de positions------";
input bool            Inp_HA2_Active = false;               // Ce signal est-il à prendre en compte ?
input ENUM_TIMEFRAMES Inp_Timeframe_HA2     = PERIOD_H1;    // Temporalité du signal ouverture HA 2

//--- Poids des motifs 0 à 5
//--- Paramétrage des motifs HA2
input bool Inp_HA2_Enabled_Motif_0 = false;    // Activer le motif 0 : Bougie directionnelle
input int  Inp_HA2_Poids_Motif_0   = 100;      // Poids : Bougie directionnelle
input bool Inp_HA2_Enabled_Motif_1 = false;    // Activer le motif 1 : Bougie grand corps
input int  Inp_HA2_Poids_Motif_1   = 100;      // Poids : Bougie grand corps
input bool Inp_HA2_Enabled_Motif_2 = false;    // Activer le motif 2 : Bougie cul plat
input int  Inp_HA2_Poids_Motif_2   = 100;      // Poids : Bougie cul plat
input bool Inp_HA2_Enabled_Motif_3 = false;    // Activer le motif 3 : Doji classique
input int  Inp_HA2_Poids_Motif_3   = 100;      // Poids : Doji classique
input bool Inp_HA2_Enabled_Motif_4 = false;    // Activer le motif 4 : Doji pied long
input int  Inp_HA2_Poids_Motif_4   = 100;      // Poids : Doji pied long
input bool Inp_HA2_Enabled_Motif_5 = false;    // Activer le motif 5 : Doji libellule / tombeau
input int  Inp_HA2_Poids_Motif_5   = 100;      // Poids : Doji libellule / tombeau

//--- Paramètres de détection des motifs
input bool   Inp_HA2_auto_fullsize   = true;  // Mode relatif (true) ou absolu (false)
input double Inp_HA2_fullsize_pts    = 0.0;   // Taille de référence en points si mode absolu
input double Inp_HA2_pct_big_body    = 0.7;   // Valeur min. pour corps bougie "grand corps" (0.7 = 70%)
input double Inp_HA2_pct_medium_body = 0.5;   // Valeur min. pour corps bougie  "cul plat"
input double Inp_HA2_pct_doji_body   = 0.1;   // Valeur max. pour corps de "doji"
input double Inp_HA2_pct_tiny_wick   = 0.05;  // Val. max. très petite mèche (doji libellule ou tombeau)
input double Inp_HA2_pct_small_wick  = 0.1;   // Val. mèche petite (min. doji simple ou max. bougie grand corps)
input double Inp_HA2_pct_long_wick   = 0.4;   // Val. min. mèche longue (cul plat / doji gd pied ou libellule)
input int    Inp_HA2_dojibefore      = 1;     // Nombre de bougies précédentes pour valider un doji

//--- inputs for signal HA 3
input string __SIGNAL_HA3__ = "-------------Signal Heiken Ashi 3 prise de positions------";
input bool            Inp_HA3_Active = false;               // Ce signal est-il à prendre en compte ?
input ENUM_TIMEFRAMES Inp_Timeframe_HA3     = PERIOD_M15;  // Temporalité du signal ouverture HA 3

//--- Paramétrage des motifs HA3
input bool Inp_HA3_Enabled_Motif_0 = false;    // Activer le motif 0 : Bougie directionnelle
input int  Inp_HA3_Poids_Motif_0   = 100;      // Poids : Bougie directionnelle
input bool Inp_HA3_Enabled_Motif_1 = false;    // Activer le motif 1 : Bougie grand corps
input int  Inp_HA3_Poids_Motif_1   = 100;      // Poids : Bougie grand corps
input bool Inp_HA3_Enabled_Motif_2 = false;    // Activer le motif 2 : Bougie cul plat
input int  Inp_HA3_Poids_Motif_2   = 100;      // Poids : Bougie cul plat
input bool Inp_HA3_Enabled_Motif_3 = false;    // Activer le motif 3 : Doji classique
input int  Inp_HA3_Poids_Motif_3   = 100;      // Poids : Doji classique
input bool Inp_HA3_Enabled_Motif_4 = false;    // Activer le motif 4 : Doji pied long
input int  Inp_HA3_Poids_Motif_4   = 100;      // Poids : Doji pied long
input bool Inp_HA3_Enabled_Motif_5 = false;    // Activer le motif 5 : Doji libellule / tombeau
input int  Inp_HA3_Poids_Motif_5   = 100;      // Poids : Doji libellule / tombeau

//--- Paramètres de détection des motifs
input bool   Inp_HA3_auto_fullsize   = true;  // Mode relatif (true) ou absolu (false)
input double Inp_HA3_fullsize_pts    = 0.0;   // Taille de référence en points si mode absolu
input double Inp_HA3_pct_big_body    = 0.7;   // Valeur min. pour corps bougie "grand corps" (0.7 = 70%)
input double Inp_HA3_pct_medium_body = 0.5;   // Valeur min. pour corps bougie  "cul plat"
input double Inp_HA3_pct_doji_body   = 0.1;   // Valeur max. pour corps de "doji"
input double Inp_HA3_pct_tiny_wick   = 0.05;  // Val. max. très petite mèche (doji libellule ou tombeau)
input double Inp_HA3_pct_small_wick  = 0.1;   // Val. mèche petite (min. doji simple ou max. bougie grand corps)
input double Inp_HA3_pct_long_wick   = 0.4;   // Val. min. mèche longue (cul plat / doji gd pied ou libellule)
input int    Inp_HA3_dojibefore      = 1;     // Nombre de bougies précédentes pour valider un doji

//--- inputs for Signal RSI 1
input string __SIGNAL_RSIO__ = "-------------Signal RSI 1 prise de positions--------------";
input bool                Inp_RSIO_Active = false;              // Ce signal est-il à prendre en compte ?
input ENUM_TIMEFRAMES     Inp_Timeframe_RSI = PERIOD_M5;        // Temporalité du signal RSI ouverture
input int                 Inp_Periode_RSI    = 14;              // Nombre de périodes pour le calcul du RSI
input ENUM_APPLIED_PRICE  Inp_Applied        = PRICE_WEIGHTED;  // Prix utilisé pour calcul du RSI
input double              Inp_SeuilRSI_Sur_Vendu  = 30.0;       // Seuil en-dessous duquel le marché est considéré survendu
input double              Inp_SeuilRSI_Sur_Achete = 70.0;       // Seuil en-dessus duquel le marché est considéré suracheté

//--- Configuration des motifs du signal RSI 1 ouverture
input bool Inp_RSIO_Enabled_Motif_0 = false;    // Activer le motif 0 : L'oscillateur a la direction requise
input int  Inp_RSIO_Poids_Motif_0   = 100;      // Poids motif 0
input bool Inp_RSIO_Enabled_Motif_1 = false;    // Activer le motif 1 : Renversement derrière le niveau de surachat/survente
input int  Inp_RSIO_Poids_Motif_1   = 100;      // Poids motif 1
bool Inp_RSIO_Enabled_Motif_2 = false;          // Activer le motif 2 : Swing échoué
int  Inp_RSIO_Poids_Motif_2   = 100;            // Poids motif 2
bool Inp_RSIO_Enabled_Motif_3 = false;          // Activer le motif 3 : Divergence Prix-RSI
int  Inp_RSIO_Poids_Motif_3   = 100;            // Poids motif 3
bool Inp_RSIO_Enabled_Motif_4 = false;          // Activer le motif 4 : Double divergence Prix-RSI
int  Inp_RSIO_Poids_Motif_4   = 100;            // Poids motif 4
bool Inp_RSIO_Enabled_Motif_5 = false;          // Activer le motif 5 : Motif Tête/épaules
int  Inp_RSIO_Poids_Motif_5   = 100;            // Poids motif 5
input bool Inp_RSIO_Enabled_Motif_6 = false;    // Activer le motif 6 : Bande d'évolution du RSI
input int  Inp_RSIO_Poids_Motif_6   = 100;      // Poids motif 6

input double             Inp_MinVar_RSIO = 0.5;             // Variation minimale du RSI pour détecter une tendance
input double             Inp_SeuilRSIO_max = 70.0;          // Seuil maximum pour tendance RSI Longue (motif 6)
input double             Inp_SeuilRSIO_medianmax = 55.0;    // Seuil minimum pour tendance RSI Longue (motif 6)
input double             Inp_SeuilRSIO_medianmin = 45.0;    // Seuil maximum pour tendance RSI Courte (motif 6)
input double             Inp_SeuilRSIO_min = 30.0;          // Seuil minimum pour tendance RSI Courte (motif 6)

//--- inputs for Signal RSI 2
input string __SIGNAL_RSIO2__ = "-------------Signal RSI 2 prise de positions--------------";
input bool                Inp_RSIO2_Active = false;                  // Ce signal est-il à prendre en compte ?
input ENUM_TIMEFRAMES     Inp_Timeframe_RSIO2 = PERIOD_M5;           // Temporalité du signal RSI ouverture
input int                 Inp_Periode_RSIO2    = 14;                 // Nombre de périodes pour le calcul du RSI
input ENUM_APPLIED_PRICE  Inp_Applied_RSIO2        = PRICE_WEIGHTED; // Prix utilisé pour calcul du RSI
input double              Inp_SeuilRSIO2_Sur_Vendu  = 30.0;          // Seuil en-dessous duquel le marché est considéré survendu
input double              Inp_SeuilRSIO2_Sur_Achete = 70.0;          // Seuil en-dessus duquel le marché est considéré suracheté

//--- Configuration des motifs du signal RSI 2 ouverture
input bool Inp_RSIO2_Enabled_Motif_0 = false;         // Activer le motif 0 : L'oscillateur a la direction requise
input int  Inp_RSIO2_Poids_Motif_0   = 100;           // Poids motif 0
input bool Inp_RSIO2_Enabled_Motif_1 = false;         // Activer le motif 1 : Renversement derrière le niveau de surachat/survente
input int  Inp_RSIO2_Poids_Motif_1   = 100;           // Poids motif 1
bool Inp_RSIO2_Enabled_Motif_2 = false;               // Activer le motif 2 : Swing échoué
int  Inp_RSIO2_Poids_Motif_2   = 100;                 // Poids motif 2
bool Inp_RSIO2_Enabled_Motif_3 = false;               // Activer le motif 3 : Divergence Prix-RSI
int  Inp_RSIO2_Poids_Motif_3   = 100;                 // Poids motif 3
bool Inp_RSIO2_Enabled_Motif_4 = false;               // Activer le motif 4 : Double divergence Prix-RSI
int  Inp_RSIO2_Poids_Motif_4   = 100;                 // Poids motif 4
bool Inp_RSIO2_Enabled_Motif_5 = false;               // Activer le motif 5 : Motif Tête/épaules
int  Inp_RSIO2_Poids_Motif_5   = 100;                 // Poids motif 5
input bool Inp_RSIO2_Enabled_Motif_6 = false;         // Activer le motif 6 : Bande d'évolution du RSI
input int  Inp_RSIO2_Poids_Motif_6   = 100;           // Poids motif 6

input double             Inp_MinVar_RSIO2 = 0.5;            // Variation minimale du RSI pour détecter une tendance
input double             Inp_SeuilRSIO2_max = 70.0;         // Seuil maximum pour tendance RSI Longue (motif 6)
input double             Inp_SeuilRSIO2_medianmax = 55.0;   // Seuil minimum pour tendance RSI Longue (motif 6)
input double             Inp_SeuilRSIO2_medianmin = 45.0;   // Seuil maximum pour tendance RSI Courte (motif 6)
input double             Inp_SeuilRSIO2_min = 30.0;         // Seuil minimum pour tendance RSI Courte (motif 6)

//--- inputs for Signal RSI 3
input string __SIGNAL_RSIO3__ = "-------------Signal RSI 3 prise de positions--------------";
input bool                Inp_RSIO3_Active = false;                  // Ce signal est-il à prendre en compte ?
input ENUM_TIMEFRAMES     Inp_Timeframe_RSIO3 = PERIOD_M5;           // Temporalité du signal RSI ouverture
input int                 Inp_Periode_RSIO3    = 14;                 // Nombre de périodes pour le calcul du RSI
input ENUM_APPLIED_PRICE  Inp_Applied_RSIO3        = PRICE_WEIGHTED; // Prix utilisé pour calcul du RSI
input double              Inp_SeuilRSIO3_Sur_Vendu  = 30.0;          // Seuil en-dessous duquel le marché est considéré survendu
input double              Inp_SeuilRSIO3_Sur_Achete = 70.0;          // Seuil en-dessus duquel le marché est considéré suracheté

//--- Configuration des motifs du signal RSI 3 ouverture
input bool Inp_RSIO3_Enabled_Motif_0 = false;            // Activer le motif 0 : L'oscillateur a la direction requise
input int  Inp_RSIO3_Poids_Motif_0   = 100;              // Poids motif 0
input bool Inp_RSIO3_Enabled_Motif_1 = false;            // Activer le motif 1 : Renversement derrière le niveau de surachat/survente
input int  Inp_RSIO3_Poids_Motif_1   = 100;              // Poids motif 1
bool Inp_RSIO3_Enabled_Motif_2 = false;                  // Activer le motif 2 : Swing échoué
int  Inp_RSIO3_Poids_Motif_2   = 100;                    // Poids motif 2
bool Inp_RSIO3_Enabled_Motif_3 = false;                  // Activer le motif 3 : Divergence Prix-RSI
int  Inp_RSIO3_Poids_Motif_3   = 100;                    // Poids motif 3
bool Inp_RSIO3_Enabled_Motif_4 = false;                  // Activer le motif 4 : Double divergence Prix-RSI
int  Inp_RSIO3_Poids_Motif_4   = 100;                    // Poids motif 4
bool Inp_RSIO3_Enabled_Motif_5 = false;                  // Activer le motif 5 : Motif Tête/épaules
int  Inp_RSIO3_Poids_Motif_5   = 100;                    // Poids motif 5
input bool Inp_RSIO3_Enabled_Motif_6 = false;            // Activer le motif 6 : Bande d'évolution du RSI
input int  Inp_RSIO3_Poids_Motif_6   = 100;              // Poids motif 6

input double             Inp_MinVar_RSIO3 = 0.5;            // Variation minimale du RSI pour détecter une tendance
input double             Inp_SeuilRSIO3_max = 70.0;         // Seuil maximum pour tendance RSI Longue (motif 6)
input double             Inp_SeuilRSIO3_medianmax = 55.0;   // Seuil minimum pour tendance RSI Longue (motif 6)
input double             Inp_SeuilRSIO3_medianmin = 45.0;   // Seuil maximum pour tendance RSI Courte (motif 6)
input double             Inp_SeuilRSIO3_min = 30.0;         // Seuil minimum pour tendance RSI Courte (motif 6)

//--- inputs for Signal RSI1 Arrêt urgence
input string __SIGNAL_RSIAUO1__ = "-------------Signal RSI Arrêt urgence prise de positions--------------";
input bool                Inp_RSIAUO1_Active = false;                  // Ce signal est-il à prendre en compte ?
input ENUM_TIMEFRAMES     Inp_Timeframe_RSIAUO1 = PERIOD_M5;           // Temporalité du signal RSI ouverture
input int                 Inp_Periode_RSIAUO1    = 14;                 // Nombre de périodes pour le calcul du RSI
input ENUM_APPLIED_PRICE  Inp_Applied_RSIAUO1        = PRICE_WEIGHTED; // Prix utilisé pour calcul du RSI
input double              Inp_SeuilRSIAUO1_Min_AU  = 30.0;             // Seuil en-dessous duquel l'AU se déclenche
input double              Inp_SeuilRSIAUO1_Max_AU = 70.0;              // Seuil en-dessus duquel l'AU se déclenche

//--- inputs for Signal RSI2 Arrêt urgence
input string __SIGNAL_RSIAUO2__ = "-------------Signal RSI Arrêt urgence prise de positions--------------";
input bool                Inp_RSIAUO2_Active = false;                  // Ce signal est-il à prendre en compte ?
input ENUM_TIMEFRAMES     Inp_Timeframe_RSIAUO2 = PERIOD_M5;           // Temporalité du signal RSI ouverture
input int                 Inp_Periode_RSIAUO2    = 14;                 // Nombre de périodes pour le calcul du RSI
input ENUM_APPLIED_PRICE  Inp_Applied_RSIAUO2        = PRICE_WEIGHTED; // Prix utilisé pour calcul du RSI
input double              Inp_SeuilRSIAUO2_Min_AU  = 30.0;             // Seuil en-dessous duquel l'AU se déclenche
input double              Inp_SeuilRSIAUO2_Max_AU = 70.0;              // Seuil en-dessus duquel l'AU se déclenche

//--- inputs for Signal RSI3 Arrêt urgence
input string __SIGNAL_RSIAUO3__ = "-------------Signal RSI Arrêt urgence prise de positions--------------";
input bool                Inp_RSIAUO3_Active = false;                  // Ce signal est-il à prendre en compte ?
input ENUM_TIMEFRAMES     Inp_Timeframe_RSIAUO3 = PERIOD_M5;           // Temporalité du signal RSI ouverture
input int                 Inp_Periode_RSIAUO3    = 14;                 // Nombre de périodes pour le calcul du RSI
input ENUM_APPLIED_PRICE  Inp_Applied_RSIAUO3        = PRICE_WEIGHTED; // Prix utilisé pour calcul du RSI
input double              Inp_SeuilRSIAUO3_Min_AU  = 30.0;             // Seuil en-dessous duquel l'AU se déclenche
input double              Inp_SeuilRSIAUO3_Max_AU = 70.0;              // Seuil en-dessus duquel l'AU se déclenche

//--- inputs for Signal MA1 ouverture
input string __SIGNAL_MA1__ = "-------------Signal Moyenne Mobile 1 prise de positions--------------";
input bool                Inp_MA1_Active = false;              // Ce signal est-il à prendre en compte ?
input ENUM_TIMEFRAMES     Inp_Timeframe_MA1 = PERIOD_M5;       // Temporalité du signal Moy. Mobile ouverture

input int                Inp_Signal_MA1_Period   =28;             // Nombre de périodes pour calcul de la MM
input int                Inp_Signal_MA1_Shift    =0;              // Décalage temporel de la MM
input ENUM_MA_METHOD     Inp_Signal_MA1_Method   =MODE_EMA;       // Mode de calcul de la MM
input ENUM_APPLIED_PRICE Inp_Signal_MA1_Applied  =PRICE_WEIGHTED; // Prix sur lequel la MM est calculé
input double             Inp_MA1_MinChange = 0.5;                 // Seuil minimum de variation de la MM pour validation de motif
input double             Inp_MA1_DiffPrice = 1000;                // Diff. (unités) entre prix de cloture et MM pour validation signal

input bool Inp_MA1_Enabled_Motif_0 = false;     // Activer le motif 0 : Prix du bon côté de la MM
input int  Inp_MA1_Poids_Motif_0   = 100;       // Poids motif 0
input bool Inp_MA1_Enabled_Motif_1 = false;     // Activer le motif 1 : croisement prix-MM en direction opposée
input int  Inp_MA1_Poids_Motif_1   = 100;       // Poids motif 1
input bool Inp_MA1_Enabled_Motif_2 = false;     // Activer le motif 2 : croisement prix-MM en même direction
input int  Inp_MA1_Poids_Motif_2   = 100;       // Poids motif 2
input bool Inp_MA1_Enabled_Motif_3 = false;     // Activer le motif 3 : Percée de la MM par le prix
input int  Inp_MA1_Poids_Motif_3   = 100;       // Poids motif 3
input bool Inp_MA1_Enabled_Motif_4 = false;     // Activer le motif 4 : Distance max. autorisée entre prix de cloture et MM
input int  Inp_MA1_Poids_Motif_4   = 100;       // Poids motif 4

//--- inputs for Signal MA2 ouverture
input string __SIGNAL_MA2__ = "-------------Signal Moyenne Mobile 2 prise de positions--------------";
input bool                Inp_MA2_Active = false;              // Ce signal est-il à prendre en compte ?
input ENUM_TIMEFRAMES     Inp_Timeframe_MA2 = PERIOD_M5;       // Temporalité du signal Moy. Mobile ouverture

input int                Inp_Signal_MA2_Period   =28;             // Nombre de périodes pour calcul de la MM
input int                Inp_Signal_MA2_Shift    =0;              // Décalage temporel de la MM
input ENUM_MA_METHOD     Inp_Signal_MA2_Method   =MODE_EMA;       // Mode de calcul de la MM
input ENUM_APPLIED_PRICE Inp_Signal_MA2_Applied  =PRICE_WEIGHTED; // Prix sur lequel la MM est calculé
input double             Inp_MA2_MinChange = 0.5;                 // Seuil minimum de variation de la MM pour validation de motif
input double             Inp_MA2_DiffPrice = 1000;                // Diff. (unités) entre prix de cloture et MM pour validation signal

input bool Inp_MA2_Enabled_Motif_0 = false;     // Activer le motif 0 : Prix du bon côté de la MM
input int  Inp_MA2_Poids_Motif_0   = 100;       // Poids motif 0
input bool Inp_MA2_Enabled_Motif_1 = false;     // Activer le motif 1 : croisement prix-MM en direction opposée
input int  Inp_MA2_Poids_Motif_1   = 100;       // Poids motif 1
input bool Inp_MA2_Enabled_Motif_2 = false;     // Activer le motif 2 : croisement prix-MM en même direction
input int  Inp_MA2_Poids_Motif_2   = 100;       // Poids motif 2
input bool Inp_MA2_Enabled_Motif_3 = false;     // Activer le motif 3 : Percée de la MM par le prix
input int  Inp_MA2_Poids_Motif_3   = 100;       // Poids motif 3
input bool Inp_MA2_Enabled_Motif_4 = false;     // Activer le motif 4 : Distance max. autorisée entre prix de cloture et MM
input int  Inp_MA2_Poids_Motif_4   = 100;       // Poids motif 4

//--- inputs for Signal MA3 ouverture
input string __SIGNAL_MA3__ = "-------------Signal Moyenne Mobile 3 prise de positions--------------";
input bool                Inp_MA3_Active = false;              // Ce signal est-il à prendre en compte ?
input ENUM_TIMEFRAMES     Inp_Timeframe_MA3 = PERIOD_M5;       // Temporalité du signal Moy. Mobile ouverture

input int                Inp_Signal_MA3_Period   =28;             // Nombre de périodes pour calcul de la MM
input int                Inp_Signal_MA3_Shift    =0;              // Décalage temporel de la MM
input ENUM_MA_METHOD     Inp_Signal_MA3_Method   =MODE_EMA;       // Mode de calcul de la MM
input ENUM_APPLIED_PRICE Inp_Signal_MA3_Applied  =PRICE_WEIGHTED; // Prix sur lequel la MM est calculé
input double             Inp_MA3_MinChange = 0.5;                 // Seuil minimum de variation de la MM pour validation de motif
input double             Inp_MA3_DiffPrice = 1000;                // Diff. (unités) entre prix de cloture et MM pour validation signal

input bool Inp_MA3_Enabled_Motif_0 = false;     // Activer le motif 0 : Prix du bon côté de la MM
input int  Inp_MA3_Poids_Motif_0   = 100;       // Poids motif 0
input bool Inp_MA3_Enabled_Motif_1 = false;     // Activer le motif 1 : croisement prix-MM en direction opposée
input int  Inp_MA3_Poids_Motif_1   = 100;       // Poids motif 1
input bool Inp_MA3_Enabled_Motif_2 = false;     // Activer le motif 2 : croisement prix-MM en même direction
input int  Inp_MA3_Poids_Motif_2   = 100;       // Poids motif 2
input bool Inp_MA3_Enabled_Motif_3 = false;     // Activer le motif 3 : Percée de la MM par le prix
input int  Inp_MA3_Poids_Motif_3   = 100;       // Poids motif 3
input bool Inp_MA3_Enabled_Motif_4 = false;     // Activer le motif 4 : Distance max. autorisée entre prix de cloture et MM
input int  Inp_MA3_Poids_Motif_4   = 100;       // Poids motif 4

//--- inputs for Signal STO ouverture
input string __SIGNAL_STO__ = "-------------Signal Stochastique prise de positions--------------";
input bool                Inp_ST1_Active = false;               // Ce signal est-il à prendre en compte ?
input ENUM_TIMEFRAMES     Inp_Timeframe_ST1 = PERIOD_M5;        // Temporalité du signal Stochastique ouverture
input ENUM_STO_PRICE      Inp_ST1_AppliedPrice  =STO_LOWHIGH;   // Prix sur lequel le stochastique K est calculé
input int                 Inp_ST1_mperiodK = 14;                // Nombre de bougies de calcul du K
input int                 Inp_ST1_mperiodslow = 8;              // Nombre de bougies de lissage du signal rapide K
input int                 Inp_ST1_mperiodD = 8;                 // Nombre de bougie de calcul du signal lent

input bool Inp_ST1_Enabled_Motif_0 = false;     // Activer le motif 0 : K est dans la bonne direction'
input int  Inp_ST1_Poids_Motif_0   = 100;       // Poids motif 0
input bool Inp_ST1_Enabled_Motif_1 = false;     // Activer le motif 1 : renversement du K
input int  Inp_ST1_Poids_Motif_1   = 100;       // Poids motif 1
input bool Inp_ST1_Enabled_Motif_2 = false;     // Activer le motif 2 : croisement K-D
input int  Inp_ST1_Poids_Motif_2   = 100;       // Poids motif 2
input bool Inp_ST1_Enabled_Motif_3 = false;     // Activer le motif 3 : divergence Prix-K
input int  Inp_ST1_Poids_Motif_3   = 100;       // Poids motif 3
input bool Inp_ST1_Enabled_Motif_4 = false;     // Activer le motif 4 : double divergence Prix-K
input int  Inp_ST1_Poids_Motif_4   = 100;       // Poids motif 4

//--- inputs for Signal Crossing MA
input string __SIGNAL_CROISMA__ = "-------------Signal Croisement de MM de prise de positions--------------";
input bool               Inp_CSMA1_Active = false;              // Ce signal est-il à prendre en compte ?
input ENUM_TIMEFRAMES    Inp_Timeframe_CSMA1 = PERIOD_M5;       // Temporalité de la MM croisement à l'ouverture
// Paramètres de la MA rapide
input   int                Inp_CSMA1_Period_Fast=8;               // Nombre de périodes pour calcul de la MM rapide
input   int                Inp_CSMA1_Shift_Fast=0;                // Décalage temporel de la MM rapide
input   ENUM_MA_METHOD     Inp_CSMA1_Method_Fast=MODE_EMA;        // Mode de calcul de la MM rapide
input   ENUM_APPLIED_PRICE Inp_CSMA1_Price_Fast=PRICE_WEIGHTED;   // Prix sur lequel la MM rapide est calculé
// Paramètres de la MA lente
input   int                Inp_CSMA1_Period_Slow=28;              // Nombre de périodes pour calcul de la MM lente
input   int                Inp_CSMA1_Shift_Slow=0;                // Décalage temporel de la MM lente
input   ENUM_MA_METHOD     Inp_CSMA1_Method_Slow=MODE_EMA;        // Mode de calcul de la MM lente
input   ENUM_APPLIED_PRICE Inp_CSMA1_Price_Slow=PRICE_WEIGHTED;   // Prix sur lequel la MM lente est calculé
input   double             Inp_CSMA1_PcChange=0.2;          // Pourcentage (en points) de variation de la MA lente pour valider signal

//input bool Inp_CSMA1_Enabled_Motif_0 = false;   // Activer le motif 0 : croisement des MM
input int  Inp_CSMA1_Poids_Motif_0   = 100;     // Poids motif 0

//--- inputs for signal HA fermeture
input string __SIGNAL_HA4__ = "-------------Signal Heiken Ashi cloture de positions------";
input bool            Inp_HAf_Active = false;               // Ce signal est-il à prendre en compte ?
input ENUM_TIMEFRAMES Inp_Timeframe_HAf     = PERIOD_H4;    // Temporalité du signal fermeture HA

//--- Paramétrage des motifs HA4 (fermeture)
input bool Inp_HAf_Enabled_Motif_0 = false;     // Activer le motif 0 : Bougie directionnelle
input int  Inp_HAf_Poids_Motif_0   = 100;       // Poids : Bougie directionnelle
input bool Inp_HAf_Enabled_Motif_1 = false;     // Activer le motif 1 : Bougie grand corps
input int  Inp_HAf_Poids_Motif_1   = 100;       // Poids : Bougie grand corps
input bool Inp_HAf_Enabled_Motif_2 = false;     // Activer le motif 2 : Bougie cul plat
input int  Inp_HAf_Poids_Motif_2   = 100;       // Poids : Bougie cul plat
input bool Inp_HAf_Enabled_Motif_3 = false;     // Activer le motif 3 : Doji classique
input int  Inp_HAf_Poids_Motif_3   = 100;       // Poids : Doji classique
input bool Inp_HAf_Enabled_Motif_4 = false;     // Activer le motif 4 : Doji pied long
input int  Inp_HAf_Poids_Motif_4   = 100;       // Poids : Doji pied long
input bool Inp_HAf_Enabled_Motif_5 = false;     // Activer le motif 5 : Doji libellule / tombeau
input int  Inp_HAf_Poids_Motif_5   = 100;       // Poids : Doji libellule / tombeau

//--- Paramètres de détection des motifs
input bool   Inp_HAf_auto_fullsize   = true;  // Mode relatif (true) ou absolu (false)
input double Inp_HAf_fullsize_pts    = 0.0;   // Taille de référence en points si mode absolu
input double Inp_HAf_pct_big_body    = 0.7;   // Valeur min. pour corps bougie "grand corps" (0.7 = 70%)
input double Inp_HAf_pct_medium_body = 0.5;   // Valeur min. pour corps bougie  "cul plat"
input double Inp_HAf_pct_doji_body   = 0.1;   // Valeur max. pour corps de "doji"
input double Inp_HAf_pct_tiny_wick   = 0.05;  // Val. max. très petite mèche (doji libellule ou tombeau)
input double Inp_HAf_pct_small_wick  = 0.1;   // Val. mèche petite (min. doji simple ou max. bougie grand corps)
input double Inp_HAf_pct_long_wick   = 0.4;   // Val. min. mèche longue (cul plat / doji gd pied ou libellule)
input int    Inp_HAf_dojibefore      = 1;     // Nombre de bougies précédentes pour valider un doji

//--- inputs for Signal RSI fermeture
input string __SIGNAL_RSIF__ = "-------------Signal RSI cloture de positions--------------";
input bool                Inp_RSIF_Active = false;                // Ce signal est-il à prendre en compte ?
input ENUM_TIMEFRAMES     Inp_Timeframe_RSIf = PERIOD_M5;         // Temporalité du signal RSI fermeture
input int                 Inp_Periode_RSIf    = 14;               // Nombre de périodes pour le calcul du RSI
input ENUM_APPLIED_PRICE  Inp_Appliedf        = PRICE_WEIGHTED;   // Prix utilisé pour calcul du RSI
input double              Inp_SeuilRSI_Sur_Venduf  = 30.0;        // Seuil en-dessous duquel le marché est considéré survendu
input double              Inp_SeuilRSI_Sur_Achetef = 70.0;        // Seuil en-dessus duquel le marché est considéré suracheté

//--- Configuration des motifs du signal RSI fermeture
input bool Inp_RSIF_Enabled_Motif_0 = false;    // Activer le motif 0 : L'oscillateur a la direction requise
input int  Inp_RSIF_Poids_Motif_0   = 100;      // Poids motif 0
input bool Inp_RSIF_Enabled_Motif_1 = false;    // Activer le motif 1 : Renversement derrière le niveau de surachat/survente
input int  Inp_RSIF_Poids_Motif_1   = 100;      // Poids motif 1
bool Inp_RSIF_Enabled_Motif_2 = false;          // Activer le motif 2 : Swing échoué
int  Inp_RSIF_Poids_Motif_2   = 100;            // Poids motif 2
bool Inp_RSIF_Enabled_Motif_3 = false;          // Activer le motif 3 : Divergence Prix-RSI
int  Inp_RSIF_Poids_Motif_3   = 100;            // Poids motif 3
bool Inp_RSIF_Enabled_Motif_4 = false;          // Activer le motif 4 : Double divergence Prix-RSI
int  Inp_RSIF_Poids_Motif_4   = 100;            // Poids motif 4
bool Inp_RSIF_Enabled_Motif_5 = false;          // Activer le motif 5 : Motif Tête/épaules
int  Inp_RSIF_Poids_Motif_5   = 100;            // Poids motif 5
input bool Inp_RSIF_Enabled_Motif_6 = false;    // Activer le motif 6 : Bande d'évolution du RSI
input int  Inp_RSIF_Poids_Motif_6   = 100;      // Poids motif 6

input double             Inp_MinVar_RSIF = 0.5;          // Variation minimale du RSI pour détecter une tendance
input double             Inp_SeuilRSIF_max = 70.0;       // Seuil maximum pour tendance RSI Longue (motif 6)
input double             Inp_SeuilRSIF_medianmax = 55.0; // Seuil minimum pour tendance RSI Longue (motif 6)
input double             Inp_SeuilRSIF_medianmin = 45.0; // Seuil maximum pour tendance RSI Courte (motif 6)
input double             Inp_SeuilRSIF_min = 30.0;       // Seuil minimum pour tendance RSI Courte (motif 6)
//--- inputs for Signal MA fermeture
input string __SIGNAL_MAF__ = "-------------Signal Moyenne Mobile cloture de positions--------------";
input bool                Inp_MAF_Active = false;              // Ce signal est-il à prendre en compte ?
input ENUM_TIMEFRAMES     Inp_Timeframe_MAF = PERIOD_M5;       // Temporalité du signal Moy. Mobile fermeture

input int                Inp_Signal_MAF_Period   =28;                // Nombre de périodes pour calcul de la MM
input int                Inp_Signal_MAF_Shift    =0;                 // Décalage temporel de la MM
input ENUM_MA_METHOD     Inp_Signal_MAF_Method   =MODE_EMA;          // Mode de calcul de la MM
input ENUM_APPLIED_PRICE Inp_Signal_MAF_Applied  =PRICE_WEIGHTED;    // Prix sur lequel la MM est calculé
input double             Inp_MAF_MinChange = 0.5;                    // Seuil minimum de variation de la MM pour validation de motif
input double             Inp_MAF_DiffPrice = 1000;                   // Diff. (unités) entre prix de cloture et MM pour validation signal

//--- Configuration des motifs du signal MM cloture de position
input bool Inp_MAF_Enabled_Motif_0 = false;     // Activer le motif 0 : Prix du bon côté de la MM
input int  Inp_MAF_Poids_Motif_0   = 100;       // Poids motif 0
input bool Inp_MAF_Enabled_Motif_1 = false;     // Activer le motif 1 : croisement prix-MM en direction opposée
input int  Inp_MAF_Poids_Motif_1   = 100;       // Poids motif 1
input bool Inp_MAF_Enabled_Motif_2 = false;     // Activer le motif 2 : croisement prix-MM en même direction
input int  Inp_MAF_Poids_Motif_2   = 100;       // Poids motif 2
input bool Inp_MAF_Enabled_Motif_3 = false;     // Activer le motif 3 : Percée de la MM par le prix
input int  Inp_MAF_Poids_Motif_3   = 100;       // Poids motif 3
input bool Inp_MAF_Enabled_Motif_4 = false;     // Activer le motif 4 : Distance max. autorisée entre prix de cloture et MM
input int  Inp_MAF_Poids_Motif_4   = 100;       // Poids motif 4

//--- inputs for Signal Crossing MA cloture
input string __SIGNAL_CROISMAF__ = "-------------Signal Croisement de MM de cloture de positions--------------";
input bool               Inp_CSMA1F_Active = false;              // Ce signal est-il à prendre en compte ?
input ENUM_TIMEFRAMES    Inp_Timeframe_CSMA1F = PERIOD_M5;       // Temporalité de la MM croisement à la fermeture
// Paramètres de la MA rapide
input   int                Inp_CSMA1F_Period_Fast=8;               // Nombre de périodes pour calcul de la MM rapide
input   int                Inp_CSMA1F_Shift_Fast=0;                // Décalage temporel de la MM rapide
input   ENUM_MA_METHOD     Inp_CSMA1F_Method_Fast=MODE_EMA;        // Mode de calcul de la MM rapide
input   ENUM_APPLIED_PRICE Inp_CSMA1F_Price_Fast=PRICE_WEIGHTED;   // Prix sur lequel la MM rapide est calculé
// Paramètres de la MA lente
input   int                Inp_CSMA1F_Period_Slow=28;              // Nombre de périodes pour calcul de la MM lente
input   int                Inp_CSMA1F_Shift_Slow=0;                // Décalage temporel de la MM lente
input   ENUM_MA_METHOD     Inp_CSMA1F_Method_Slow=MODE_EMA;        // Mode de calcul de la MM lente
input   ENUM_APPLIED_PRICE Inp_CSMA1F_Price_Slow=PRICE_WEIGHTED;   // Prix sur lequel la MM lente est calculé
input   double             Inp_CSMA1F_PcChange=0.2;          // Pourcentage (en points) de variation de la MA lente pour valider signal

//input bool Inp_CSMA1F_Enabled_Motif_0 = false;   // Activer le motif 0 : croisement des MM
input int  Inp_CSMA1F_Poids_Motif_0   = 100;     // Poids motif 0

//--- inputs for Trailing
input string __STOP_SUIVEUR__ = "-------------Configuration du stop suiveur--------------";
input int Inp_StopLevel   = 1500;            // Nombre de points entre le SL et le prix marché
input int Inp_ProfilLevel = 5000;            // Nombre de points entre le TP et le prix marché
input int Inp_SeuilAmplification = 200;      // Nbr points min. entre le prix d'achat et le prix marché pour amplifier
input double Inp_CoefAmpli = 2.0;            // Coeficient d'amplication du nbr pts stop suiveur

input string __JOURS_TRADING__ = "---Configuration des jours et heures de trading--------";
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
CExpertDir ExtExpert;
//+------------------------------------------------------------------+
//| OnInit utilisant ConfigFactory & Builder                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   printf(__FUNCTION__+"Démarrage de l’EA");
   if(!ExtExpert.Init(Symbol(),Period(),Expert_EveryTick,Expert_MagicNumber))
      return INIT_FAILED;

//--- Configuration de l'expert directionnel
   ExtExpert.AllowLong(Inp_Allow_Long);
   ExtExpert.AllowShort(Inp_Allow_Short);

//---Création des signaux d'ouverture et de fermeture
   CSignalITF_eLib *signal_open = new CSignalITF_eLib;
   CSignalITF_eLib *signal_close = new CSignalITF_eLib;

   if(signal_open==NULL || signal_close==NULL)
      return INIT_FAILED;

   if(!ExtExpert.InitSignalOpen(signal_open) || !ExtExpert.InitSignalClose(signal_close))
     {
      printf(__FUNCTION__+": error initializing signal");
      ExtExpert.Deinit();
      return(-3);
     }

//--- Configuration du filtre temporel : jours interdits
   int bad_days = CUtilsLTR::EncodeDaysClosed(
                     Inp_Ouvert_Dimanche,
                     Inp_Ouvert_Lundi,
                     Inp_Ouvert_Mardi,
                     Inp_Ouvert_Mercredi,
                     Inp_Ouvert_Jeudi,
                     Inp_Ouvert_Vendredi,
                     Inp_Ouvert_Samedi);

   signal_open.BadDaysOfWeek(bad_days);
   signal_close.BadDaysOfWeek(bad_days);

//--- Configuration du filtre temporel : heures interdites
   int bad_hours = CUtilsLTR::GenerateBadHoursOfDay(
                      Inp_Heure_Ouverture,
                      Inp_Heure_Fermeture,
                      Inp_Debut_Pause_Dej,
                      Inp_Fin_Pause_Dej);

   signal_open.BadHoursOfDay(bad_hours);
   signal_close.BadHoursOfDay(bad_hours);

   signal_open.ThresholdOpen(Inp_SeuilOuverture);
   signal_open.ThresholdClose(Inp_SeuilFermeture);
   signal_open.TakeLevel(Inp_TakeProfit);
   signal_open.StopLevel(Inp_StopLoss);

   signal_close.ThresholdOpen(Inp_SeuilOuverture);
   signal_close.ThresholdClose(Inp_SeuilFermeture);
   signal_close.TakeLevel(Inp_TakeProfit);
   signal_close.StopLevel(Inp_StopLoss);

   signal_open.PriceLevel(Inp_Price_Level);

//--- Signal HA1 - Prise de position
   if(!CSignalBuilder::BuildAndAddFilter(signal_open,
                                         CSignalConfigFactory::CreateHAConfig(Inp_Timeframe_HA1,
                                               Inp_HA1_Poids_Motif_0, Inp_HA1_Poids_Motif_1, Inp_HA1_Poids_Motif_2, Inp_HA1_Poids_Motif_3, Inp_HA1_Poids_Motif_4, Inp_HA1_Poids_Motif_5,
                                               Inp_HA1_Enabled_Motif_0, Inp_HA1_Enabled_Motif_1, Inp_HA1_Enabled_Motif_2, Inp_HA1_Enabled_Motif_3, Inp_HA1_Enabled_Motif_4, Inp_HA1_Enabled_Motif_5,
                                               Inp_HA1_pct_big_body, Inp_HA1_pct_medium_body, Inp_HA1_pct_doji_body,
                                               Inp_HA1_pct_tiny_wick, Inp_HA1_pct_small_wick, Inp_HA1_pct_long_wick,
                                               Inp_HA1_dojibefore, Inp_HA1_auto_fullsize, Inp_HA1_fullsize_pts),
                                         Inp_HA1_Active))
     {
      Print(__FUNCTION__, ": erreur création filtre HA1");
      ExtExpert.Deinit();
      return INIT_FAILED;
     }
//--- Signal HA2 - Prise de position
   if(!CSignalBuilder::BuildAndAddFilter(signal_open,
                                         CSignalConfigFactory::CreateHAConfig(Inp_Timeframe_HA2,
                                               Inp_HA2_Poids_Motif_0, Inp_HA2_Poids_Motif_1, Inp_HA2_Poids_Motif_2, Inp_HA2_Poids_Motif_3, Inp_HA2_Poids_Motif_4, Inp_HA2_Poids_Motif_5,
                                               Inp_HA2_Enabled_Motif_0, Inp_HA2_Enabled_Motif_1, Inp_HA2_Enabled_Motif_2, Inp_HA2_Enabled_Motif_3, Inp_HA2_Enabled_Motif_4, Inp_HA2_Enabled_Motif_5,
                                               Inp_HA2_pct_big_body, Inp_HA2_pct_medium_body, Inp_HA2_pct_doji_body,
                                               Inp_HA2_pct_tiny_wick, Inp_HA2_pct_small_wick, Inp_HA2_pct_long_wick,
                                               Inp_HA2_dojibefore, Inp_HA2_auto_fullsize, Inp_HA2_fullsize_pts),
                                         Inp_HA2_Active))

     {
      Print(__FUNCTION__, ": erreur création filtre HA2");
      ExtExpert.Deinit();
      return INIT_FAILED;
     }
//--- Signal HA3 - Prise de position
   if(!CSignalBuilder::BuildAndAddFilter(signal_open,
                                         CSignalConfigFactory::CreateHAConfig(Inp_Timeframe_HA3,
                                               Inp_HA3_Poids_Motif_0, Inp_HA3_Poids_Motif_1, Inp_HA3_Poids_Motif_2, Inp_HA3_Poids_Motif_3, Inp_HA3_Poids_Motif_4, Inp_HA3_Poids_Motif_5,
                                               Inp_HA3_Enabled_Motif_0, Inp_HA3_Enabled_Motif_1, Inp_HA3_Enabled_Motif_2, Inp_HA3_Enabled_Motif_3, Inp_HA3_Enabled_Motif_4, Inp_HA3_Enabled_Motif_5,
                                               Inp_HA3_pct_big_body, Inp_HA3_pct_medium_body, Inp_HA3_pct_doji_body,
                                               Inp_HA3_pct_tiny_wick, Inp_HA3_pct_small_wick, Inp_HA3_pct_long_wick,
                                               Inp_HA3_dojibefore, Inp_HA3_auto_fullsize, Inp_HA3_fullsize_pts),
                                         Inp_HA3_Active))

     {
      Print(__FUNCTION__, ": erreur création filtre HA3");
      ExtExpert.Deinit();
      return INIT_FAILED;
     }
//--- Filtre RSI Open 1
   if(!CSignalBuilder::BuildAndAddFilter(signal_open,
                                         CSignalConfigFactory::CreateRSIConfig(Inp_Timeframe_RSI,
                                               Inp_RSIO_Poids_Motif_0, Inp_RSIO_Poids_Motif_1,
                                               Inp_RSIO_Poids_Motif_2, Inp_RSIO_Poids_Motif_3,
                                               Inp_RSIO_Poids_Motif_4, Inp_RSIO_Poids_Motif_5,
                                               Inp_RSIO_Poids_Motif_6,
                                               Inp_RSIO_Enabled_Motif_0, Inp_RSIO_Enabled_Motif_1,
                                               Inp_RSIO_Enabled_Motif_2, Inp_RSIO_Enabled_Motif_3,
                                               Inp_RSIO_Enabled_Motif_4, Inp_RSIO_Enabled_Motif_5,
                                               Inp_RSIO_Enabled_Motif_6,
                                               Inp_Periode_RSI,
                                               Inp_Applied,
                                               Inp_SeuilRSI_Sur_Achete,
                                               Inp_SeuilRSI_Sur_Vendu,
                                               Inp_MinVar_RSIO,
                                               Inp_SeuilRSIO_medianmax,
                                               Inp_SeuilRSIO_max,
                                               Inp_SeuilRSIO_medianmin,
                                               Inp_SeuilRSIO_min),
                                         Inp_RSIO_Active))
     {
      Print(__FUNCTION__, ": erreur création filtre RSI O1");
      ExtExpert.Deinit();
      return INIT_FAILED;
     }
//--- Filtre RSI Open 2
   if(!CSignalBuilder::BuildAndAddFilter(signal_open,
                                         CSignalConfigFactory::CreateRSIConfig(Inp_Timeframe_RSIO2,
                                               Inp_RSIO2_Poids_Motif_0, Inp_RSIO2_Poids_Motif_1,
                                               Inp_RSIO2_Poids_Motif_2, Inp_RSIO2_Poids_Motif_3,
                                               Inp_RSIO2_Poids_Motif_4, Inp_RSIO2_Poids_Motif_5,
                                               Inp_RSIO2_Poids_Motif_6,
                                               Inp_RSIO2_Enabled_Motif_0, Inp_RSIO2_Enabled_Motif_1,
                                               Inp_RSIO2_Enabled_Motif_2, Inp_RSIO2_Enabled_Motif_3,
                                               Inp_RSIO2_Enabled_Motif_4, Inp_RSIO2_Enabled_Motif_5,
                                               Inp_RSIO2_Enabled_Motif_6,
                                               Inp_Periode_RSIO2,
                                               Inp_Applied_RSIO2,
                                               Inp_SeuilRSIO2_Sur_Achete,
                                               Inp_SeuilRSIO2_Sur_Vendu,
                                               Inp_MinVar_RSIO2,
                                               Inp_SeuilRSIO2_medianmax,
                                               Inp_SeuilRSIO2_max,
                                               Inp_SeuilRSIO2_medianmin,
                                               Inp_SeuilRSIO2_min),
                                         Inp_RSIO2_Active))
     {
      Print(__FUNCTION__, ": erreur création filtre RSI O2");
      ExtExpert.Deinit();
      return INIT_FAILED;
     }
//--- Filtre RSI Open 3
   if(!CSignalBuilder::BuildAndAddFilter(signal_open,
                                         CSignalConfigFactory::CreateRSIConfig(Inp_Timeframe_RSIO3,
                                               Inp_RSIO3_Poids_Motif_0, Inp_RSIO3_Poids_Motif_1,
                                               Inp_RSIO3_Poids_Motif_2, Inp_RSIO3_Poids_Motif_3,
                                               Inp_RSIO3_Poids_Motif_4, Inp_RSIO3_Poids_Motif_5,
                                               Inp_RSIO3_Poids_Motif_6,
                                               Inp_RSIO3_Enabled_Motif_0, Inp_RSIO3_Enabled_Motif_1,
                                               Inp_RSIO3_Enabled_Motif_2, Inp_RSIO3_Enabled_Motif_3,
                                               Inp_RSIO3_Enabled_Motif_4, Inp_RSIO3_Enabled_Motif_5,
                                               Inp_RSIO3_Enabled_Motif_6,
                                               Inp_Periode_RSIO3,
                                               Inp_Applied_RSIO3,
                                               Inp_SeuilRSIO3_Sur_Achete,
                                               Inp_SeuilRSIO3_Sur_Vendu,
                                               Inp_MinVar_RSIO3,
                                               Inp_SeuilRSIO3_medianmax,
                                               Inp_SeuilRSIO3_max,
                                               Inp_SeuilRSIO3_medianmin,
                                               Inp_SeuilRSIO3_min),
                                         Inp_RSIO3_Active))
     {
      Print(__FUNCTION__, ": erreur création filtre RSI O3");
      ExtExpert.Deinit();
      return INIT_FAILED;
     }
//--- Filtre RSI Arrêt urgence ouverture 1
   if(!CSignalBuilder::BuildAndAddFilter(signal_open,
                                         CSignalConfigFactory::CreateRSI_ESConfig(Inp_Timeframe_RSIAUO1,
                                               Inp_Periode_RSIAUO1,
                                               Inp_Applied_RSIAUO1,
                                               Inp_SeuilRSIAUO1_Max_AU,
                                               Inp_SeuilRSIAUO1_Min_AU,
                                               Inp_RSIAUO1_Active),
                                         Inp_RSIAUO1_Active))
     {
      Print(__FUNCTION__, ": erreur création filtre RSI 1 arrêt urgence");
      ExtExpert.Deinit();
      return INIT_FAILED;
     }     
//--- Filtre RSI Arrêt urgence ouverture 2
   if(!CSignalBuilder::BuildAndAddFilter(signal_open,
                                         CSignalConfigFactory::CreateRSI_ESConfig(Inp_Timeframe_RSIAUO2,
                                               Inp_Periode_RSIAUO2,
                                               Inp_Applied_RSIAUO2,
                                               Inp_SeuilRSIAUO2_Max_AU,
                                               Inp_SeuilRSIAUO2_Min_AU,
                                               Inp_RSIAUO2_Active),
                                         Inp_RSIAUO2_Active))
     {
      Print(__FUNCTION__, ": erreur création filtre RSI 2 arrêt urgence");
      ExtExpert.Deinit();
      return INIT_FAILED;
     }  
//--- Filtre RSI Arrêt urgence ouverture 3
   if(!CSignalBuilder::BuildAndAddFilter(signal_open,
                                         CSignalConfigFactory::CreateRSI_ESConfig(Inp_Timeframe_RSIAUO3,
                                               Inp_Periode_RSIAUO3,
                                               Inp_Applied_RSIAUO3,
                                               Inp_SeuilRSIAUO3_Max_AU,
                                               Inp_SeuilRSIAUO3_Min_AU,
                                               Inp_RSIAUO3_Active),
                                         Inp_RSIAUO3_Active))
     {
      Print(__FUNCTION__, ": erreur création filtre RSI 3 arrêt urgence");
      ExtExpert.Deinit();
      return INIT_FAILED;
     }          
       
//--- Filtre MA1 Open
   if(!CSignalBuilder::BuildAndAddFilter(signal_open,
                                         CSignalConfigFactory::CreateMAConfig(Inp_Timeframe_MA1,
                                               Inp_MA1_Poids_Motif_0, Inp_MA1_Poids_Motif_1,
                                               Inp_MA1_Poids_Motif_2, Inp_MA1_Poids_Motif_3,
                                               Inp_MA1_Poids_Motif_4,
                                               Inp_MA1_Enabled_Motif_0, Inp_MA1_Enabled_Motif_1,
                                               Inp_MA1_Enabled_Motif_2, Inp_MA1_Enabled_Motif_3,
                                               Inp_MA1_Enabled_Motif_4,
                                               Inp_Signal_MA1_Period,
                                               Inp_Signal_MA1_Shift,
                                               Inp_Signal_MA1_Method,
                                               Inp_Signal_MA1_Applied,
                                               Inp_MA1_MinChange,
                                               Inp_MA1_DiffPrice),
                                         Inp_MA1_Active))
     {
      Print(__FUNCTION__, ": erreur création filtre MA 1");
      ExtExpert.Deinit();
      return INIT_FAILED;
     }
//--- Filtre MA2 Open
   if(!CSignalBuilder::BuildAndAddFilter(signal_open,
                                         CSignalConfigFactory::CreateMAConfig(Inp_Timeframe_MA2,
                                               Inp_MA2_Poids_Motif_0, Inp_MA2_Poids_Motif_1,
                                               Inp_MA2_Poids_Motif_2, Inp_MA2_Poids_Motif_3,
                                               Inp_MA2_Poids_Motif_4,
                                               Inp_MA2_Enabled_Motif_0, Inp_MA2_Enabled_Motif_1,
                                               Inp_MA2_Enabled_Motif_2, Inp_MA2_Enabled_Motif_3,
                                               Inp_MA2_Enabled_Motif_4,
                                               Inp_Signal_MA2_Period,
                                               Inp_Signal_MA2_Shift,
                                               Inp_Signal_MA2_Method,
                                               Inp_Signal_MA2_Applied,
                                               Inp_MA2_MinChange,
                                               Inp_MA2_DiffPrice),
                                         Inp_MA2_Active))
     {
      Print(__FUNCTION__, ": erreur création filtre MA 2");
      ExtExpert.Deinit();
      return INIT_FAILED;
     }
//--- Filtre MA3 Open
   if(!CSignalBuilder::BuildAndAddFilter(signal_open,
                                         CSignalConfigFactory::CreateMAConfig(Inp_Timeframe_MA3,
                                               Inp_MA3_Poids_Motif_0, Inp_MA3_Poids_Motif_1,
                                               Inp_MA3_Poids_Motif_2, Inp_MA3_Poids_Motif_3,
                                               Inp_MA3_Poids_Motif_4,
                                               Inp_MA3_Enabled_Motif_0, Inp_MA3_Enabled_Motif_1,
                                               Inp_MA3_Enabled_Motif_2, Inp_MA3_Enabled_Motif_3,
                                               Inp_MA3_Enabled_Motif_4,
                                               Inp_Signal_MA3_Period,
                                               Inp_Signal_MA3_Shift,
                                               Inp_Signal_MA3_Method,
                                               Inp_Signal_MA3_Applied,
                                               Inp_MA3_MinChange,
                                               Inp_MA3_DiffPrice),
                                         Inp_MA3_Active))
     {
      Print(__FUNCTION__, ": erreur création filtre MA 3");
      ExtExpert.Deinit();
      return INIT_FAILED;
     }
//--- Filtre Stochastique Open
   if(!CSignalBuilder::BuildAndAddFilter(signal_open,
                                         CSignalConfigFactory::CreateStochConfig(Inp_Timeframe_ST1,
                                               Inp_ST1_Poids_Motif_0,
                                               Inp_ST1_Poids_Motif_1,
                                               Inp_ST1_Poids_Motif_2,
                                               Inp_ST1_Poids_Motif_3,
                                               Inp_ST1_Poids_Motif_4,
                                               Inp_ST1_Enabled_Motif_0,
                                               Inp_ST1_Enabled_Motif_1,
                                               Inp_ST1_Enabled_Motif_2,
                                               Inp_ST1_Enabled_Motif_3,
                                               Inp_ST1_Enabled_Motif_4,
                                               Inp_ST1_mperiodK,
                                               Inp_ST1_mperiodD,
                                               Inp_ST1_mperiodslow,
                                               Inp_ST1_AppliedPrice
                                               ),
                                         Inp_ST1_Active))

     {
      Print(__FUNCTION__, ": erreur création filtre Stochastique 1");
      ExtExpert.Deinit();
      return INIT_FAILED;
     }
//--- Filtre CrossMA Open
   if(!CSignalBuilder::BuildAndAddFilter(signal_open,
                                         CSignalConfigFactory::CreateCrossMAConfig(Inp_Timeframe_CSMA1,
                                               Inp_CSMA1_Poids_Motif_0, 
                                               Inp_CSMA1_Active, 
                                               Inp_CSMA1_Period_Fast,
                                               Inp_CSMA1_Shift_Fast,
                                               Inp_CSMA1_Method_Fast,
                                               Inp_CSMA1_Price_Fast,
                                               Inp_CSMA1_Period_Slow,
                                               Inp_CSMA1_Shift_Slow,
                                               Inp_CSMA1_Method_Slow,
                                               Inp_CSMA1_Price_Slow,
                                               Inp_CSMA1_PcChange),
                                         Inp_CSMA1_Active))
     {
      Print(__FUNCTION__, ": erreur création filtre CrossMA Open");
      ExtExpert.Deinit();
      return INIT_FAILED;
     }
//--- Signal HA4 - Clôture de position
   if(!CSignalBuilder::BuildAndAddFilter(signal_close,
                                         CSignalConfigFactory::CreateHAConfig(Inp_Timeframe_HAf,
                                               Inp_HAf_Poids_Motif_0, Inp_HAf_Poids_Motif_1, Inp_HAf_Poids_Motif_2, Inp_HAf_Poids_Motif_3, Inp_HAf_Poids_Motif_4, Inp_HAf_Poids_Motif_5,
                                               Inp_HAf_Enabled_Motif_0, Inp_HAf_Enabled_Motif_1, Inp_HAf_Enabled_Motif_2, Inp_HAf_Enabled_Motif_3, Inp_HAf_Enabled_Motif_4, Inp_HAf_Enabled_Motif_5,
                                               Inp_HAf_pct_big_body, Inp_HAf_pct_medium_body, Inp_HAf_pct_doji_body,
                                               Inp_HAf_pct_tiny_wick, Inp_HAf_pct_small_wick, Inp_HAf_pct_long_wick,
                                               Inp_HAf_dojibefore, Inp_HAf_auto_fullsize, Inp_HAf_fullsize_pts),
                                         Inp_HAf_Active))
     {
      Print(__FUNCTION__, ": erreur création filtre HA1 Fermeture");
      ExtExpert.Deinit();
      return INIT_FAILED;
     }
//--- Filtre RSI Close
   if(!CSignalBuilder::BuildAndAddFilter(signal_close,
                                         CSignalConfigFactory::CreateRSIConfig(Inp_Timeframe_RSIf,
                                               Inp_RSIF_Poids_Motif_0, Inp_RSIF_Poids_Motif_1,
                                               Inp_RSIF_Poids_Motif_2, Inp_RSIF_Poids_Motif_3,
                                               Inp_RSIF_Poids_Motif_4, Inp_RSIF_Poids_Motif_5,
                                               Inp_RSIF_Poids_Motif_6,
                                               Inp_RSIF_Enabled_Motif_0, Inp_RSIF_Enabled_Motif_1,
                                               Inp_RSIF_Enabled_Motif_2, Inp_RSIF_Enabled_Motif_3,
                                               Inp_RSIF_Enabled_Motif_4, Inp_RSIF_Enabled_Motif_5,
                                               Inp_RSIF_Enabled_Motif_6,
                                               Inp_Periode_RSIf,
                                               Inp_Appliedf,
                                               Inp_SeuilRSI_Sur_Achetef,
                                               Inp_SeuilRSI_Sur_Venduf,
                                               Inp_MinVar_RSIF,
                                               Inp_SeuilRSIF_medianmax,
                                               Inp_SeuilRSIF_max,
                                               Inp_SeuilRSIF_medianmin,
                                               Inp_SeuilRSIF_min),
                                         Inp_RSIF_Active))
     {
      Print(__FUNCTION__, ": erreur création filtre RSI F");
      ExtExpert.Deinit();
      return INIT_FAILED;
     }
//--- Filtre MA Close
   if(!CSignalBuilder::BuildAndAddFilter(signal_close,
                                         CSignalConfigFactory::CreateMAConfig(Inp_Timeframe_MAF,
                                               Inp_MAF_Poids_Motif_0, Inp_MAF_Poids_Motif_1,
                                               Inp_MAF_Poids_Motif_2, Inp_MAF_Poids_Motif_3,
                                               Inp_MAF_Poids_Motif_4,
                                               Inp_MAF_Enabled_Motif_0, Inp_MAF_Enabled_Motif_1,
                                               Inp_MAF_Enabled_Motif_2, Inp_MAF_Enabled_Motif_3,
                                               Inp_MAF_Enabled_Motif_4,
                                               Inp_Signal_MAF_Period,
                                               Inp_Signal_MAF_Shift,
                                               Inp_Signal_MAF_Method,
                                               Inp_Signal_MAF_Applied,
                                               Inp_MAF_MinChange,
                                               Inp_MAF_DiffPrice),
                                         Inp_MAF_Active))
     {
      Print(__FUNCTION__, ": erreur création filtre MA F");
      ExtExpert.Deinit();
      return INIT_FAILED;
     }
//--- Filtre CrossMA Close
   if(!CSignalBuilder::BuildAndAddFilter(signal_close,
                                         CSignalConfigFactory::CreateCrossMAConfig(Inp_Timeframe_CSMA1F,
                                               Inp_CSMA1F_Poids_Motif_0,
                                               Inp_CSMA1F_Active, 
                                               Inp_CSMA1F_Period_Fast,
                                               Inp_CSMA1F_Shift_Fast,
                                               Inp_CSMA1F_Method_Fast,
                                               Inp_CSMA1F_Price_Fast,
                                               Inp_CSMA1F_Period_Slow,
                                               Inp_CSMA1F_Shift_Slow,
                                               Inp_CSMA1F_Method_Slow,
                                               Inp_CSMA1F_Price_Slow,
                                               Inp_CSMA1F_PcChange),
                                         Inp_CSMA1F_Active))
     {
      Print(__FUNCTION__, ": erreur création filtre CrossMA Close");
      ExtExpert.Deinit();
      return INIT_FAILED;
     }
//--- Trailing
   CTrailingAmpliedPips *trailing = new CTrailingAmpliedPips;
   if(trailing==NULL)
     {
      printf(__FUNCTION__+": error creating trailing");
      ExtExpert.Deinit();
      return(-6);
     }
   if(!ExtExpert.InitTrailing(trailing))
     {
      printf(__FUNCTION__+": error initializing trailing");
      ExtExpert.Deinit();
      return(-7);
     }
   trailing.StopLevel(Inp_StopLevel);
   trailing.ProfitLevel(Inp_ProfilLevel);
   trailing.AmplificationFactor(Inp_CoefAmpli);
   trailing.SLThreshold(Inp_SeuilAmplification);

   if(!trailing.ValidationSettings())
     {
      printf(__FUNCTION__+": error trailing parameters");
      ExtExpert.Deinit();
      return(-8);
     }

//--- Money management
   CMoneyFixedRisk_eLib *money=new CMoneyFixedRisk_eLib;
   if(money==NULL)
     {
      printf(__FUNCTION__+": error creating money");
      ExtExpert.Deinit();
      return(-9);
     }
   if(!ExtExpert.InitMoney(money))
     {
      printf(__FUNCTION__+": error initializing money");
      ExtExpert.Deinit();
      return(-10);
     }
   money.Percent(Inp_PourcentRisque);
   if(!money.ValidationSettings())
     {
      printf(__FUNCTION__+": error money parameters");
      ExtExpert.Deinit();
      return(-11);
     }

//--- Initialisation des indicateurs
   if(!ExtExpert.InitIndicators())
     {
      Print("error initializing indicators");
      ExtExpert.Deinit();
      return(-12);
     }

//--- Calcul de la période minimale
   if(!ExtExpert.InitExpertMinPeriod())
     {
      Print("error initializing min period");
      ExtExpert.Deinit();
      return(-12);
     }

   Print("TERMINAL_PATH = ",TerminalInfoString(TERMINAL_PATH));
   Print("TERMINAL_DATA_PATH = ",TerminalInfoString(TERMINAL_DATA_PATH));
   Print("TERMINAL_COMMONDATA_PATH = ",TerminalInfoString(TERMINAL_COMMONDATA_PATH));

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
void OnTick()
  {
   ExtExpert.OnTick();
  }

//+------------------------------------------------------------------+
//| Function-event handler "trade"                                   |
//+------------------------------------------------------------------+
void OnTrade()
  {
   ExtExpert.OnTrade();
  }

//+------------------------------------------------------------------+
//| Function-event handler "timer"                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
   ExtExpert.OnTimer();
  }

//+------------------------------------------------------------------+
//| Fin du fichier Expert                                            |
