//+------------------------------------------------------------------+
//|                                                SignalsConfig.mqh |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Lucas Troncy"
//+------------------------------------------------------------------+
// Fichier contenant les structures de configuration des signaux     |
//+------------------------------------------------------------------+
#ifndef __SIGNAL_CONFIGS_MQH__
#define __SIGNAL_CONFIGS_MQH__

//+------------------------------------------------------------------+
//| Structure pour configurer un filtre Heiken Ashi Amélioré         |
//+------------------------------------------------------------------+
struct HAConfig
  {
   ENUM_TIMEFRAMES   tf;            // Temporalité
   int               poids[6];      // Poids des motifs 0 à 5
   bool              enabled[6];    // Activation motifs 0 à 5

   double            pct_big_body;
   double            pct_medium_body;
   double            pct_doji_body;

   double            pct_tiny_wick;
   double            pct_small_wick;
   double            pct_long_wick;

   int               dojibefore;        // Nombre de bougies avant le doji
   bool              auto_fullsize;     // true = mode relatif, false = absolu
   double            fullsize_pts;      // Valeur absolue en points (si > 0)
  };

//+------------------------------------------------------------------+
//| Structure pour configurer un filtre RSI                         |
//+------------------------------------------------------------------+
struct RSIConfig
  {
   ENUM_TIMEFRAMES    tf;
   int                poids[7];       // Poids des motifs 0 à 6
   bool               enabled[7];     // Activation motifs 0 à 6

   int                period;
   ENUM_APPLIED_PRICE price;
   double             seuil_surachete;
   double             seuil_survendu;
   double             min_rsi_change;
   double             seuil_medianmax; // ➔ pour motif 6 (long)
   double             seuil_maximum;   // ➔ pour motif 6 (haut)
   double             seuil_medianmin; // ➔ pour motif 6 (short)
   double             seuil_minimum;   // ➔ pour motif 6 (bas)
   bool               emergency_stop;
  };

//+------------------------------------------------------------------+
//| Structure pour configurer un filtre MA                          |
//+------------------------------------------------------------------+
struct MAConfig
  {
   ENUM_TIMEFRAMES     tf;
   int                 poids[5];       // Poids des motifs 0 à 3
   bool                enabled[5];     // Activation motifs 0 à 3

   int                 period;
   int                 shift;
   ENUM_MA_METHOD      method;
   ENUM_APPLIED_PRICE  price;
   double              min_ma_change;
   double              diff_price_ma;
  };

//+------------------------------------------------------------------+
//| Structure pour configurer un filtre Stochastique                |
//+------------------------------------------------------------------+
struct StochConfig
  {
   ENUM_TIMEFRAMES    tf;
   int                poids[5];         // Poids des motifs 0 à 4
   bool               enabled[5];       // Activation motifs 0 à 4

   int                periodK;          // %K period
   int                periodD;          // %D period
   int                period_slow;      // Smoothing
   ENUM_STO_PRICE     applied_price;    // Source de prix
  };

//+------------------------------------------------------------------+
//| Structure pour configurer un filtre CrossMA                      |
//+------------------------------------------------------------------+
struct CrossMAConfig
  {
   ENUM_TIMEFRAMES     tf;               // Temporalité
   int                 poids[1];         // Poids des motifs 0
   bool                enabled[1];       // Activation motifs 0

   // Paramètres MA rapide
   int                 period_fast;
   int                 shift_fast;
   ENUM_MA_METHOD      method_fast;
   ENUM_APPLIED_PRICE  price_fast;

   // Paramètres MA lente
   int                 period_slow;
   int                 shift_slow;
   ENUM_MA_METHOD      method_slow;
   ENUM_APPLIED_PRICE  price_slow;
   double              percent_change_maslow;
  };

//+------------------------------------------------------------------+
//| Structure pour configurer un filtre RSI AU                       |
//+------------------------------------------------------------------+
struct RSI_ESConfig
  {
   ENUM_TIMEFRAMES    tf;

   int                period;
   ENUM_APPLIED_PRICE price;
   double             seuil_maxES;
   double             seuil_minES;
   bool               emergency_stop;
  };

//+------------------------------------------------------------------+
//| Structure pour configurer un filtre 3MA                          |
//+------------------------------------------------------------------+
struct MA3Config
  {
   ENUM_TIMEFRAMES     tf;               // Temporalité
   int                 poids[2];         // Poids des motifs 0 et 1
   bool                enabled[2];       // Activation motifs 0 et 1

   // Paramètres MA rapide
   int                 period_fast;
   int                 shift_fast;
   ENUM_MA_METHOD      method_fast;
   ENUM_APPLIED_PRICE  price_fast;

   // Paramètres MA moyenne
   int                 period_medium;
   int                 shift_medium;
   ENUM_MA_METHOD      method_medium;
   ENUM_APPLIED_PRICE  price_medium;

   // Paramètres MA lente
   int                 period_slow;
   int                 shift_slow;
   ENUM_MA_METHOD      method_slow;
   ENUM_APPLIED_PRICE  price_slow;

   // Contraintes sur la pente (exprimées en pips / candle)
   double              min_slope_fast;
   double              min_slope_medium;
   double              min_slope_slow;

   // Contraintes sur les distances entre MA (exprimées en pips)
   double              min_distance_fast_medium;
   double              min_distance_medium_slow;

   // Contraintes sur les ratios de pente (adimensionnés)
   double              min_ratio_fast_medium;
   double              max_ratio_fast_medium;

   // Qualité minimale R²
   double              min_regression_quality;

   // Nombre de bougies pour la régression
   int                 candle_nbr;
  };

#endif // __SIGNAL_CONFIGS_MQH__