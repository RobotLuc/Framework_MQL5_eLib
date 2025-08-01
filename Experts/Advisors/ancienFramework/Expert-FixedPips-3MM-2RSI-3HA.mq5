//+------------------------------------------------------------------+
//| Titre du fichier : Expert-FixedPips-3MM-2RSI-3HA.mqh             |
//| Contenu du fichier :                                             |
//|   * type : Expert Advisor MQL5                                   |
//+------------------------------------------------------------------+
#property version   "1.0"
#property copyright "Copyright 2025, Lucas Troncy"

//+------------------------------------------------------------------+
//| Includes                                                         |
//+------------------------------------------------------------------+
#include <Expert\ExpertAsymetrique.mqh>
#include <Expert\Signal\BuilderSignal.mqh>
#include <Expert\Config\SignalsConfig.mqh>
#include <Expert\Config\SignalConfigFactory.mqh>
#include <Expert\Money\MoneyFixedLot.mqh>
#include <Expert\Trailing\TrailingFixedPips.mqh>

//+------------------------------------------------------------------+
//| Inputs                                                           |
//+------------------------------------------------------------------+
input string Inp_Expert_Title            ="Expert-3MM-2RSI";// Nom du robot
input int    Expert_MagicNumber          =120700;           // Nombre magique du robot
input bool   Expert_EveryTick            =false;            // Le robot est-il appelé à chaque tick ?

input int    Inp_TakeProfit            = 5000;            // Take Profit des positions prises avec le signal, en points
input int    Inp_StopLoss              = 2000;            // Stop loss des positions prises avec le signal, en points
input double nbr_lots                  = 3.0;            // Nombre de lots pris à chaque position
input int    Inp_SeuilOuverture        = 100;            // Note minimale pour ouvrir une position (long ou short)
input int    Inp_SeuilFermeture        = 100;            // Note minimale pour clore une position (long ou short)
input double Inp_Price_Level           = 0.0;            // Ecart (points) entre prix marché et bid

//--- inputs for signal HA 1
input string __SIGNAL_HA1__ = "-------------Signal Heiken Ashi 1 prise de positions------";
input bool            Inp_HA1_Active = false;               // Ce signal est-il à prendre en compte ?
input ENUM_TIMEFRAMES Inp_Timeframe_HA1     = PERIOD_H4;   // Temporalité du signal ouverture HA 1

//--- Paramétrage des motifs HA1
input bool Inp_HA1_Enabled_Motif_0 = false;   // Activer le motif 0 : Bougie directionnelle
input int  Inp_HA1_Poids_Motif_0   = 100;      // Poids : Bougie directionnelle
input bool Inp_HA1_Enabled_Motif_1 = false;   // Activer le motif 1 : Bougie grand corps
input int  Inp_HA1_Poids_Motif_1   = 100;      // Poids : Bougie grand corps
input bool Inp_HA1_Enabled_Motif_2 = false;   // Activer le motif 2 : Bougie cul plat
input int  Inp_HA1_Poids_Motif_2   = 100;    // Poids : Bougie cul plat
input bool Inp_HA1_Enabled_Motif_3 = false;   // Activer le motif 3 : Doji classique
input int  Inp_HA1_Poids_Motif_3   = 100;      // Poids : Doji classique
input bool Inp_HA1_Enabled_Motif_4 = false;   // Activer le motif 4 : Doji pied long
input int  Inp_HA1_Poids_Motif_4   = 100;      // Poids : Doji pied long
input bool Inp_HA1_Enabled_Motif_5 = false;   // Activer le motif 5 : Doji libellule / tombeau
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
input ENUM_TIMEFRAMES Inp_Timeframe_HA2     = PERIOD_H1;   // Temporalité du signal ouverture HA 2

//--- Poids des motifs 0 à 5
//--- Paramétrage des motifs HA2
input bool Inp_HA2_Enabled_Motif_0 = false;   // Activer le motif 0 : Bougie directionnelle
input int  Inp_HA2_Poids_Motif_0   = 100;      // Poids : Bougie directionnelle
input bool Inp_HA2_Enabled_Motif_1 = false;   // Activer le motif 1 : Bougie grand corps
input int  Inp_HA2_Poids_Motif_1   = 100;      // Poids : Bougie grand corps
input bool Inp_HA2_Enabled_Motif_2 = false;   // Activer le motif 2 : Bougie cul plat
input int  Inp_HA2_Poids_Motif_2   = 100;    // Poids : Bougie cul plat
input bool Inp_HA2_Enabled_Motif_3 = false;   // Activer le motif 3 : Doji classique
input int  Inp_HA2_Poids_Motif_3   = 100;      // Poids : Doji classique
input bool Inp_HA2_Enabled_Motif_4 = false;   // Activer le motif 4 : Doji pied long
input int  Inp_HA2_Poids_Motif_4   = 100;      // Poids : Doji pied long
input bool Inp_HA2_Enabled_Motif_5 = false;   // Activer le motif 5 : Doji libellule / tombeau
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
input bool Inp_HA3_Enabled_Motif_0 = false;   // Activer le motif 0 : Bougie directionnelle
input int  Inp_HA3_Poids_Motif_0   = 100;      // Poids : Bougie directionnelle
input bool Inp_HA3_Enabled_Motif_1 = false;   // Activer le motif 1 : Bougie grand corps
input int  Inp_HA3_Poids_Motif_1   = 100;      // Poids : Bougie grand corps
input bool Inp_HA3_Enabled_Motif_2 = false;   // Activer le motif 2 : Bougie cul plat
input int  Inp_HA3_Poids_Motif_2   = 100;    // Poids : Bougie cul plat
input bool Inp_HA3_Enabled_Motif_3 = false;   // Activer le motif 3 : Doji classique
input int  Inp_HA3_Poids_Motif_3   = 100;      // Poids : Doji classique
input bool Inp_HA3_Enabled_Motif_4 = false;   // Activer le motif 4 : Doji pied long
input int  Inp_HA3_Poids_Motif_4   = 100;      // Poids : Doji pied long
input bool Inp_HA3_Enabled_Motif_5 = false;   // Activer le motif 5 : Doji libellule / tombeau
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
input ENUM_TIMEFRAMES     Inp_Timeframe_RSI = PERIOD_M5;       // Temporalité du signal RSI ouverture
input int                 Inp_Periode_RSI    = 14;              // Nombre de périodes pour le calcul du RSI
input ENUM_APPLIED_PRICE  Inp_Applied        = PRICE_WEIGHTED; // Prix utilisé pour calcul du RSI
input double              Inp_SeuilRSI_Sur_Vendu  = 35.0;       // Seuil en-dessous duquel le marché est considéré survendu
input double              Inp_SeuilRSI_Sur_Achete = 65.0;       // Seuil en-dessus duquel le marché est considéré suracheté

//--- Configuration des motifs du signal RSI ouverture
input bool Inp_RSIO_Enabled_Motif_0 = false;   // Activer le motif 0 : L'oscillateur a la direction requise
input int  Inp_RSIO_Poids_Motif_0   = 100;      // Poids motif 0
input bool Inp_RSIO_Enabled_Motif_1 = false;   // Activer le motif 1 : Renversement derrière le niveau de surachat/survente
input int  Inp_RSIO_Poids_Motif_1   = 100;    // Poids motif 1
input bool Inp_RSIO_Enabled_Motif_2 = false;   // Activer le motif 2 : Swing échoué
input int  Inp_RSIO_Poids_Motif_2   = 100;      // Poids motif 2
input bool Inp_RSIO_Enabled_Motif_3 = false;   // Activer le motif 3 : Divergence Prix-RSI
input int  Inp_RSIO_Poids_Motif_3   = 100;    // Poids motif 3
input bool Inp_RSIO_Enabled_Motif_4 = false;   // Activer le motif 4 : Double divergence Prix-RSI
input int  Inp_RSIO_Poids_Motif_4   = 100;      // Poids motif 4
input bool Inp_RSIO_Enabled_Motif_5 = false;   // Activer le motif 5 : Motif Tête/épaules
input int  Inp_RSIO_Poids_Motif_5   = 100;      // Poids motif 5
input bool Inp_RSIO_Enabled_Motif_6 = false;   // Activer le motif 6 : Bande d'évolution du RSI
input int  Inp_RSIO_Poids_Motif_6   = 100;      // Poids motif 6

input double             Inp_MinVar_RSIO = 0.5; // Variation minimale du RSI pour détecter une tendance
input double             Inp_SeuilRSIO_medianmax = 55.0;  // Seuil minimum pour tendance RSI Longue (motif 6)
input double             Inp_SeuilRSIO_max = 70.0; // Seuil maximum pour tendance RSI Longue (motif 6)
input double             Inp_SeuilRSIO_medianmin = 45.0; // Seuil maximum pour tendance RSI Courte (motif 6)
input double             Inp_SeuilRSIO_min = 30.0; // Seuil minimum pour tendance RSI Courte (motif 6)

//--- inputs for Signal RSI 2
input string __SIGNAL_RSIO2__ = "-------------Signal RSI 2 prise de positions--------------";
input bool                Inp_RSIO2_Active = false;              // Ce signal est-il à prendre en compte ?
input ENUM_TIMEFRAMES     Inp_Timeframe_RSIO2 = PERIOD_M5;       // Temporalité du signal RSI ouverture
input int                 Inp_Periode_RSIO2    = 14;              // Nombre de périodes pour le calcul du RSI
input ENUM_APPLIED_PRICE  Inp_Applied_RSIO2        = PRICE_WEIGHTED; // Prix utilisé pour calcul du RSI
input double              Inp_SeuilRSIO2_Sur_Vendu  = 35.0;       // Seuil en-dessous duquel le marché est considéré survendu
input double              Inp_SeuilRSIO2_Sur_Achete = 65.0;       // Seuil en-dessus duquel le marché est considéré suracheté

//--- Configuration des motifs du signal RSI ouverture
input bool Inp_RSIO2_Enabled_Motif_0 = false;   // Activer le motif 0 : L'oscillateur a la direction requise
input int  Inp_RSIO2_Poids_Motif_0   = 100;      // Poids motif 0
input bool Inp_RSIO2_Enabled_Motif_1 = false;   // Activer le motif 1 : Renversement derrière le niveau de surachat/survente
input int  Inp_RSIO2_Poids_Motif_1   = 100;    // Poids motif 1
input bool Inp_RSIO2_Enabled_Motif_2 = false;   // Activer le motif 2 : Swing échoué
input int  Inp_RSIO2_Poids_Motif_2   = 100;      // Poids motif 2
input bool Inp_RSIO2_Enabled_Motif_3 = false;   // Activer le motif 3 : Divergence Prix-RSI
input int  Inp_RSIO2_Poids_Motif_3   = 100;    // Poids motif 3
input bool Inp_RSIO2_Enabled_Motif_4 = false;   // Activer le motif 4 : Double divergence Prix-RSI
input int  Inp_RSIO2_Poids_Motif_4   = 100;      // Poids motif 4
input bool Inp_RSIO2_Enabled_Motif_5 = false;   // Activer le motif 5 : Motif Tête/épaules
input int  Inp_RSIO2_Poids_Motif_5   = 100;      // Poids motif 5
input bool Inp_RSIO2_Enabled_Motif_6 = false;   // Activer le motif 6 : Bande d'évolution du RSI
input int  Inp_RSIO2_Poids_Motif_6   = 100;      // Poids motif 6

input double             Inp_MinVar_RSIO2 = 0.5; // Variation minimale du RSI pour détecter une tendance
input double             Inp_SeuilRSIO2_medianmax = 55.0;  // Seuil minimum pour tendance RSI Longue (motif 6)
input double             Inp_SeuilRSIO2_max = 70.0; // Seuil maximum pour tendance RSI Longue (motif 6)
input double             Inp_SeuilRSIO2_medianmin = 45.0; // Seuil maximum pour tendance RSI Courte (motif 6)
input double             Inp_SeuilRSIO2_min = 30.0; // Seuil minimum pour tendance RSI Courte (motif 6)

//--- inputs for Signal MA1 ouverture
input string __SIGNAL_MA1__ = "-------------Signal Moyenne Mobile 1 prise de positions--------------";
input bool                Inp_MA1_Active = false;              // Ce signal est-il à prendre en compte ?
input ENUM_TIMEFRAMES     Inp_Timeframe_MA1 = PERIOD_M5;       // Temporalité du signal Moy. Mobile ouverture

input int                Inp_Signal_MA1_Period   =28;    // Nombre de périodes pour calcul de la MM
input int                Inp_Signal_MA1_Shift    =0;     // Décalage temporel de la MM
input ENUM_MA_METHOD     Inp_Signal_MA1_Method   =MODE_SMA; // Mode de calcul de la MM
input ENUM_APPLIED_PRICE Inp_Signal_MA1_Applied  =PRICE_CLOSE; // Prix sur lequel la MM est calculé
input double             Inp_MA1_MinChange = 0.5; // Seuil minimum de variation de la MM pour validation de motif

input bool Inp_MA1_Enabled_Motif_0 = false;   // Activer le motif 0 : Prix du bon côté de l'indicateur
input int  Inp_MA1_Poids_Motif_0   = 100;      // Poids motif 0
input bool Inp_MA1_Enabled_Motif_1 = false;   // Activer le motif 1 : croisement prix-ma en direction opposée
input int  Inp_MA1_Poids_Motif_1   = 100;    // Poids motif 1
input bool Inp_MA1_Enabled_Motif_2 = false;   // Activer le motif 2 : croisement prix-ma en même direction
input int  Inp_MA1_Poids_Motif_2   = 100;      // Poids motif 2
input bool Inp_MA1_Enabled_Motif_3 = false;   // Activer le motif 3 : Percée de la ma par le prix
input int  Inp_MA1_Poids_Motif_3   = 100;    // Poids motif 3

//--- inputs for Signal MA2 ouverture
input string __SIGNAL_MA2__ = "-------------Signal Moyenne Mobile 2 prise de positions--------------";
input bool                Inp_MA2_Active = false;              // Ce signal est-il à prendre en compte ?
input ENUM_TIMEFRAMES     Inp_Timeframe_MA2 = PERIOD_M5;       // Temporalité du signal Moy. Mobile ouverture

input int                Inp_Signal_MA2_Period   =28;    // Nombre de périodes pour calcul de la MM
input int                Inp_Signal_MA2_Shift    =0;     // Décalage temporel de la MM
input ENUM_MA_METHOD     Inp_Signal_MA2_Method   =MODE_SMA; // Mode de calcul de la MM
input ENUM_APPLIED_PRICE Inp_Signal_MA2_Applied  =PRICE_CLOSE; // Prix sur lequel la MM est calculé
input double             Inp_MA2_MinChange = 0.5; // Seuil minimum de variation de la MM pour validation de motif

input bool Inp_MA2_Enabled_Motif_0 = false;   // Activer le motif 0 : Prix du bon côté de l'indicateur
input int  Inp_MA2_Poids_Motif_0   = 100;      // Poids motif 0
input bool Inp_MA2_Enabled_Motif_1 = false;   // Activer le motif 1 : croisement prix-ma en direction opposée
input int  Inp_MA2_Poids_Motif_1   = 100;    // Poids motif 1
input bool Inp_MA2_Enabled_Motif_2 = false;   // Activer le motif 2 : croisement prix-ma en même direction
input int  Inp_MA2_Poids_Motif_2   = 100;      // Poids motif 2
input bool Inp_MA2_Enabled_Motif_3 = false;   // Activer le motif 3 : Percée de la ma par le prix
input int  Inp_MA2_Poids_Motif_3   = 100;    // Poids motif 3

//--- inputs for Signal MA3 ouverture
input string __SIGNAL_MA3__ = "-------------Signal Moyenne Mobile 3 prise de positions--------------";
input bool                Inp_MA3_Active = false;              // Ce signal est-il à prendre en compte ?
input ENUM_TIMEFRAMES     Inp_Timeframe_MA3 = PERIOD_M5;       // Temporalité du signal Moy. Mobile ouverture

input int                Inp_Signal_MA3_Period   =28;    // Nombre de périodes pour calcul de la MM
input int                Inp_Signal_MA3_Shift    =0;     // Décalage temporel de la MM
input ENUM_MA_METHOD     Inp_Signal_MA3_Method   =MODE_SMA; // Mode de calcul de la MM
input ENUM_APPLIED_PRICE Inp_Signal_MA3_Applied  =PRICE_CLOSE; // Prix sur lequel la MM est calculé
input double             Inp_MA3_MinChange = 0.5; // Seuil minimum de variation de la MM pour validation de motif

input bool Inp_MA3_Enabled_Motif_0 = false;   // Activer le motif 0 : Prix du bon côté de l'indicateur
input int  Inp_MA3_Poids_Motif_0   = 100;      // Poids motif 0
input bool Inp_MA3_Enabled_Motif_1 = false;   // Activer le motif 1 : croisement prix-ma en direction opposée
input int  Inp_MA3_Poids_Motif_1   = 100;    // Poids motif 1
input bool Inp_MA3_Enabled_Motif_2 = false;   // Activer le motif 2 : croisement prix-ma en même direction
input int  Inp_MA3_Poids_Motif_2   = 100;      // Poids motif 2
input bool Inp_MA3_Enabled_Motif_3 = false;   // Activer le motif 3 : Percée de la ma par le prix
input int  Inp_MA3_Poids_Motif_3   = 100;    // Poids motif 3

//--- inputs for signal HA fermeture
input string __SIGNAL_HA4__ = "-------------Signal Heiken Ashi cloture de positions------";
input bool            Inp_HAf_Active = false;               // Ce signal est-il à prendre en compte ?
input ENUM_TIMEFRAMES Inp_Timeframe_HAf     = PERIOD_H4;   // Temporalité du signal fermeture HA

//--- Paramétrage des motifs HA4 (fermeture)
input bool Inp_HAf_Enabled_Motif_0 = false;   // Activer le motif 0 : Bougie directionnelle
input int  Inp_HAf_Poids_Motif_0   = 100;      // Poids : Bougie directionnelle
input bool Inp_HAf_Enabled_Motif_1 = false;   // Activer le motif 1 : Bougie grand corps
input int  Inp_HAf_Poids_Motif_1   = 100;      // Poids : Bougie grand corps
input bool Inp_HAf_Enabled_Motif_2 = false;   // Activer le motif 2 : Bougie cul plat
input int  Inp_HAf_Poids_Motif_2   = 100;    // Poids : Bougie cul plat
input bool Inp_HAf_Enabled_Motif_3 = false;   // Activer le motif 3 : Doji classique
input int  Inp_HAf_Poids_Motif_3   = 100;      // Poids : Doji classique
input bool Inp_HAf_Enabled_Motif_4 = false;   // Activer le motif 4 : Doji pied long
input int  Inp_HAf_Poids_Motif_4   = 100;      // Poids : Doji pied long
input bool Inp_HAf_Enabled_Motif_5 = false;   // Activer le motif 5 : Doji libellule / tombeau
input int  Inp_HAf_Poids_Motif_5   = 100;      // Poids : Doji libellule / tombeau

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
input bool                Inp_RSIF_Active = false;               // Ce signal est-il à prendre en compte ?
input ENUM_TIMEFRAMES     Inp_Timeframe_RSIf = PERIOD_M5;       // Temporalité du signal RSI fermeture
input int                 Inp_Periode_RSIf    = 14;              // Nombre de périodes pour le calcul du RSI
input ENUM_APPLIED_PRICE  Inp_Appliedf        = PRICE_WEIGHTED; // Prix utilisé pour calcul du RSI
input double              Inp_SeuilRSI_Sur_Venduf  = 35.0;       // Seuil en-dessous duquel le marché est considéré survendu
input double              Inp_SeuilRSI_Sur_Achetef = 65.0;       // Seuil en-dessus duquel le marché est considéré suracheté

//--- Configuration des motifs du signal RSI fermeture
input bool Inp_RSIF_Enabled_Motif_0 = false;   // Activer le motif 0 : L'oscillateur a la direction requise
input int  Inp_RSIF_Poids_Motif_0   = 100;      // Poids motif 0
input bool Inp_RSIF_Enabled_Motif_1 = false;   // Activer le motif 1 : Renversement derrière le niveau de surachat/survente
input int  Inp_RSIF_Poids_Motif_1   = 100;    // Poids motif 1
input bool Inp_RSIF_Enabled_Motif_2 = false;   // Activer le motif 2 : Swing échoué
input int  Inp_RSIF_Poids_Motif_2   = 100;      // Poids motif 2
input bool Inp_RSIF_Enabled_Motif_3 = false;   // Activer le motif 3 : Divergence Prix-RSI
input int  Inp_RSIF_Poids_Motif_3   = 100;    // Poids motif 3
input bool Inp_RSIF_Enabled_Motif_4 = false;   // Activer le motif 4 : Double divergence Prix-RSI
input int  Inp_RSIF_Poids_Motif_4   = 100;      // Poids motif 4
input bool Inp_RSIF_Enabled_Motif_5 = false;   // Activer le motif 5 : Motif Tête/épaules
input int  Inp_RSIF_Poids_Motif_5   = 100;      // Poids motif 5
input bool Inp_RSIF_Enabled_Motif_6 = false;   // Activer le motif 6 : Bande d'évolution du RSI
input int  Inp_RSIF_Poids_Motif_6   = 100;      // Poids motif 6

input double             Inp_MinVar_RSIF = 0.5; // Variation minimale du RSI pour détecter une tendance
input double             Inp_SeuilRSIF_medianmax = 55.0; // Seuil minimum pour tendance RSI Longue (motif 6)
input double             Inp_SeuilRSIF_max = 70.0; // Seuil maximum pour tendance RSI Longue (motif 6)
input double             Inp_SeuilRSIF_medianmin = 45.0; // Seuil maximum pour tendance RSI Courte (motif 6)
input double             Inp_SeuilRSIF_min = 30.0; // Seuil minimum pour tendance RSI Courte (motif 6)
//--- inputs for Signal MA fermeture
input string __SIGNAL_MAF__ = "-------------Signal Moyenne Mobile cloture de positions--------------";
input bool                Inp_MAF_Active = false;              // Ce signal est-il à prendre en compte ?
input ENUM_TIMEFRAMES     Inp_Timeframe_MAF = PERIOD_M5;       // Temporalité du signal Moy. Mobile fermeture

input int                Inp_Signal_MAF_Period   =28; // Nombre de périodes pour calcul de la MM
input int                Inp_Signal_MAF_Shift    =0; // Décalage temporel de la MM
input ENUM_MA_METHOD     Inp_Signal_MAF_Method   =MODE_SMA; // Mode de calcul de la MM
input ENUM_APPLIED_PRICE Inp_Signal_MAF_Applied  =PRICE_CLOSE; // Prix sur lequel la MM est calculé
input double             Inp_MAF_MinChange = 0.5; // Seuil minimum de variation de la MM pour validation de motif

//--- Configuration des motifs du signal MM cloture de position
input bool Inp_MAF_Enabled_Motif_0 = false;   // Activer le motif 0 : Prix du bon côté de l'indicateur
input int  Inp_MAF_Poids_Motif_0   = 100;      // Poids motif 0
input bool Inp_MAF_Enabled_Motif_1 = false;   // Activer le motif 1 : croisement prix-ma en direction opposée
input int  Inp_MAF_Poids_Motif_1   = 100;    // Poids motif 1
input bool Inp_MAF_Enabled_Motif_2 = false;   // Activer le motif 2 : croisement prix-ma en même direction
input int  Inp_MAF_Poids_Motif_2   = 100;      // Poids motif 2
input bool Inp_MAF_Enabled_Motif_3 = false;   // Activer le motif 3 : Percée de la ma par le prix
input int  Inp_MAF_Poids_Motif_3   = 100;    // Poids motif 3

//--- inputs for Trailing
input string __STOP_SUIVEUR__ = "-------------Configuration du stop suiveur--------------";
input int Inp_StopLevel   = 1500;  // Nombre de points entre le SL et le prix marché
input int Inp_ProfilLevel = 5000;  // Nombre de points entre le TP et le prix marché

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
CExpert ExtExpert;
//+------------------------------------------------------------------+
//| Nouvelle version de OnInit utilisant ConfigFactory & Builder     |
//+------------------------------------------------------------------+
int OnInit()
  {
   printf(__FUNCTION__+"Démarrage de l’EA");
   if(!ExtExpert.Init(Symbol(),Period(),Expert_EveryTick,Expert_MagicNumber))
      return INIT_FAILED;

   CSignalITF *signal_open = new CSignalITF;
   CSignalITF *signal_close = new CSignalITF;

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
      Print(__FUNCTION__, ": erreur création filtre RSI O");
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


//--- Filtre MA1 Open
   if(!CSignalBuilder::BuildAndAddFilter(signal_open,
                                         CSignalConfigFactory::CreateMAConfig(Inp_Timeframe_MA1,
                                               Inp_MA1_Poids_Motif_0, Inp_MA1_Poids_Motif_1,
                                               Inp_MA1_Poids_Motif_2, Inp_MA1_Poids_Motif_3,
                                               Inp_MA1_Enabled_Motif_0, Inp_MA1_Enabled_Motif_1,
                                               Inp_MA1_Enabled_Motif_2, Inp_MA1_Enabled_Motif_3,
                                               Inp_Signal_MA1_Period,
                                               Inp_Signal_MA1_Shift,
                                               Inp_Signal_MA1_Method,
                                               Inp_Signal_MA1_Applied,
                                               Inp_MA1_MinChange),
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
                                               Inp_MA2_Enabled_Motif_0, Inp_MA2_Enabled_Motif_1,
                                               Inp_MA2_Enabled_Motif_2, Inp_MA2_Enabled_Motif_3,
                                               Inp_Signal_MA2_Period,
                                               Inp_Signal_MA2_Shift,
                                               Inp_Signal_MA2_Method,
                                               Inp_Signal_MA2_Applied,
                                               Inp_MA2_MinChange),
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
                                               Inp_MA3_Enabled_Motif_0, Inp_MA3_Enabled_Motif_1,
                                               Inp_MA3_Enabled_Motif_2, Inp_MA3_Enabled_Motif_3,
                                               Inp_Signal_MA3_Period,
                                               Inp_Signal_MA3_Shift,
                                               Inp_Signal_MA3_Method,
                                               Inp_Signal_MA3_Applied,
                                               Inp_MA3_MinChange),
                                         Inp_MA3_Active))
     {
      Print(__FUNCTION__, ": erreur création filtre MA 3");
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
                                               Inp_MAF_Enabled_Motif_0, Inp_MAF_Enabled_Motif_1,
                                               Inp_MAF_Enabled_Motif_2, Inp_MAF_Enabled_Motif_3,
                                               Inp_Signal_MAF_Period,
                                               Inp_Signal_MAF_Shift,
                                               Inp_Signal_MAF_Method,
                                               Inp_Signal_MAF_Applied,
                                               Inp_MAF_MinChange),
                                         Inp_MAF_Active))
     {
      Print(__FUNCTION__, ": erreur création filtre MA F");
      ExtExpert.Deinit();
      return INIT_FAILED;
     }

//--- Trailing
   CTrailingFixedPips *trailing = new CTrailingFixedPips;
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

   if(!trailing.ValidationSettings())
     {
      printf(__FUNCTION__+": error trailing parameters");
      ExtExpert.Deinit();
      return(-8);
     }

//--- Money management
   CMoneyFixedLot *money=new CMoneyFixedLot;
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
   money.Lots(nbr_lots);
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
      return(-13);
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
//| Fin du fichier ExpertRSI-HA-FixedPips.mqh                        |
//+------------------------------------------------------------------+
