//+------------------------------------------------------------------+
//|                                          SignalConfigFactory.mqh |
//|                                     Copyright 2025, Lucas Troncy |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Lucas Troncy"
//+------------------------------------------------------------------+
//|                                        CSignalConfigFactory.mqh  |
//|  Fabrique de structures de configuration de signaux             |


#ifndef __SIGNAL_CONFIG_FACTORY_MQH__
#define __SIGNAL_CONFIG_FACTORY_MQH__

#include <Expert\Expert_eLib\Config\SignalsConfig.mqh>

//+------------------------------------------------------------------+
//| Classe CSignalConfigFactory                                      |
//+------------------------------------------------------------------+
class CSignalConfigFactory
  {
public:
   static HAConfig     CreateHAConfig(ENUM_TIMEFRAMES tf,
                                      int p0, int p1, int p2, int p3, int p4, int p5,
                                      bool e0, bool e1, bool e2, bool e3, bool e4, bool e5,
                                      double pct_big_body,
                                      double pct_medium_body,
                                      double pct_doji_body,
                                      double pct_tiny_wick,
                                      double pct_small_wick,
                                      double pct_long_wick,
                                      int dojibefore,
                                      bool auto_fullsize,
                                      double fullsize_pts
                                     );
                                     
   static RSIConfig  CreateRSIConfig(ENUM_TIMEFRAMES tf,
                                     int p0, int p1, int p2, int p3, int p4, int p5, int p6,
                                     bool e0, bool e1, bool e2, bool e3, bool e4, bool e5, bool e6,
                                     int period,
                                     ENUM_APPLIED_PRICE price,
                                     double seuil_achete,
                                     double seuil_vendu,
                                     double min_rsi_change,
                                     double seuil_medianmax,
                                     double seuil_maximum,
                                     double seuil_medianmin,
                                     double seuil_minimum);    // Création d'une config RSI
                                     
   static MAConfig   CreateMAConfig(ENUM_TIMEFRAMES tf,
                                    int p0, int p1, int p2, int p3, int p4,
                                    bool e0, bool e1, bool e2, bool e3, bool e4,
                                    int period,
                                    int shift,
                                    ENUM_MA_METHOD method,
                                    ENUM_APPLIED_PRICE price,
                                    double min_ma_change,
                                    double diff_price_ma
                                   ); // Création d'une config MA
                                   
   static StochConfig CreateStochConfig(ENUM_TIMEFRAMES tf,
                                        int p0, int p1, int p2, int p3, int p4,
                                        bool e0, bool e1, bool e2, bool e3, bool e4,
                                        int periodK,
                                        int periodD,
                                        int period_slow,
                                        ENUM_STO_PRICE applied_price); // Création d'une config de Stochastique
                                                                                                                      
  static CrossMAConfig CreateCrossMAConfig(ENUM_TIMEFRAMES tf,
                                         int p0,
                                         bool e0,
                                         int period_fast,
                                         int shift_fast,
                                         ENUM_MA_METHOD method_fast,
                                         ENUM_APPLIED_PRICE price_fast,
                                         int period_slow,
                                         int shift_slow,
                                         ENUM_MA_METHOD method_slow,
                                         ENUM_APPLIED_PRICE price_slow,
                                         double percent_change_maslow);                                      
  
  
   static RSI_ESConfig  CreateRSI_ESConfig(ENUM_TIMEFRAMES tf,
                                     int period,
                                     ENUM_APPLIED_PRICE price,
                                     double seuil_maxES,
                                     double seuil_minES,
                                     bool   emergency_stop);    // Création d'une config RSI
 
  };
//+------------------------------------------------------------------+
//| Création d'une configuration Heiken Ashi                         |
//+------------------------------------------------------------------+
HAConfig CSignalConfigFactory::CreateHAConfig(ENUM_TIMEFRAMES tf,
      int p0, int p1, int p2, int p3, int p4, int p5,
      bool e0, bool e1, bool e2, bool e3, bool e4, bool e5,
      double pct_big_body,
      double pct_medium_body,
      double pct_doji_body,
      double pct_tiny_wick,
      double pct_small_wick,
      double pct_long_wick,
      int dojibefore,
      bool auto_fullsize,
      double fullsize_pts)
  {
   HAConfig cfg;
   cfg.tf              = tf;
   cfg.poids[0]        = p0;
   cfg.poids[1]        = p1;
   cfg.poids[2]        = p2;
   cfg.poids[3]        = p3;
   cfg.poids[4]        = p4;
   cfg.poids[5]        = p5;

   cfg.enabled[0] = e0;
   cfg.enabled[1] = e1;
   cfg.enabled[2] = e2;
   cfg.enabled[3] = e3;
   cfg.enabled[4] = e4;
   cfg.enabled[5] = e5;

   cfg.pct_big_body    = pct_big_body;
   cfg.pct_medium_body = pct_medium_body;
   cfg.pct_doji_body   = pct_doji_body;

   cfg.pct_tiny_wick   = pct_tiny_wick;
   cfg.pct_small_wick  = pct_small_wick;
   cfg.pct_long_wick   = pct_long_wick;

   cfg.dojibefore      = dojibefore;
   cfg.auto_fullsize   = auto_fullsize;
   cfg.fullsize_pts    = fullsize_pts;

   return cfg;
  }
//+------------------------------------------------------------------+
//| Création d'une configuration RSI                                 |
//+------------------------------------------------------------------+
RSIConfig CSignalConfigFactory::CreateRSIConfig(ENUM_TIMEFRAMES tf,
      int p0, int p1, int p2, int p3, int p4, int p5, int p6,
      bool e0, bool e1, bool e2, bool e3, bool e4, bool e5, bool e6,
      int period,
      ENUM_APPLIED_PRICE price,
      double seuil_achete,
      double seuil_vendu,
      double min_rsi_change,
      double seuil_medianmax,
      double seuil_maximum,
      double seuil_medianmin,
      double seuil_minimum)
  {
   RSIConfig cfg;
   cfg.tf                = tf;
   cfg.period            = period;
   cfg.price             = price;

   cfg.poids[0]          = p0;
   cfg.poids[1]          = p1;
   cfg.poids[2]          = p2;
   cfg.poids[3]          = p3;
   cfg.poids[4]          = p4;
   cfg.poids[5]          = p5;
   cfg.poids[6]          = p6;

   cfg.enabled[0]        = e0;
   cfg.enabled[1]        = e1;
   cfg.enabled[2]        = e2;
   cfg.enabled[3]        = e3;
   cfg.enabled[4]        = e4;
   cfg.enabled[5]        = e5;
   cfg.enabled[6]        = e6;

   cfg.seuil_surachete   = seuil_achete;
   cfg.seuil_survendu    = seuil_vendu;
   cfg.min_rsi_change    = min_rsi_change;

   cfg.seuil_medianmax   = seuil_medianmax;
   cfg.seuil_maximum     = seuil_maximum;
   cfg.seuil_medianmin   = seuil_medianmin;
   cfg.seuil_minimum     = seuil_minimum;
   return cfg;
  }
//+------------------------------------------------------------------+
//| Création d'une configuration Moyenne Mobile                      |
//+------------------------------------------------------------------+
MAConfig CSignalConfigFactory::CreateMAConfig(ENUM_TIMEFRAMES tf,
      int p0, int p1, int p2, int p3, int p4,
      bool e0, bool e1, bool e2, bool e3, bool e4,
      int period,
      int shift,
      ENUM_MA_METHOD method,
      ENUM_APPLIED_PRICE price,
      double min_ma_change,
      double diff_price_ma)

  {
   MAConfig cfg;
   cfg.tf      = tf;
   cfg.period = period;
   cfg.shift  = shift;
   cfg.method = method;
   cfg.price  = price;

   cfg.poids[0] = p0;
   cfg.poids[1] = p1;
   cfg.poids[2] = p2;
   cfg.poids[3] = p3;
   cfg.poids[4] = p4;
   cfg.enabled[0] = e0;
   cfg.enabled[1] = e1;
   cfg.enabled[2] = e2;
   cfg.enabled[3] = e3;
   cfg.enabled[4] = e4;
   cfg.min_ma_change = min_ma_change;
   cfg.diff_price_ma = diff_price_ma;

   return cfg;
  }
//+------------------------------------------------------------------+
//| Création d'une configuration Stochastique                        |
//+------------------------------------------------------------------+
StochConfig CSignalConfigFactory::CreateStochConfig(ENUM_TIMEFRAMES tf,
      int p0, int p1, int p2, int p3, int p4,
      bool e0, bool e1, bool e2, bool e3, bool e4,
      int periodK,
      int periodD,
      int period_slow,
      ENUM_STO_PRICE applied_price)
  {
   StochConfig cfg;
   cfg.tf             = tf;

   cfg.poids[0]       = p0;
   cfg.poids[1]       = p1;
   cfg.poids[2]       = p2;
   cfg.poids[3]       = p3;
   cfg.poids[4]       = p4;

   cfg.enabled[0]     = e0;
   cfg.enabled[1]     = e1;
   cfg.enabled[2]     = e2;
   cfg.enabled[3]     = e3;
   cfg.enabled[4]     = e4;

   cfg.periodK        = periodK;
   cfg.periodD        = periodD;
   cfg.period_slow    = period_slow;
   cfg.applied_price  = applied_price;

   return cfg;
  }
//+------------------------------------------------------------------+
//| Création d'une configuration Crossing MA                         |
//+------------------------------------------------------------------+
CrossMAConfig CSignalConfigFactory::CreateCrossMAConfig(ENUM_TIMEFRAMES tf,
      int p0,
      bool e0,
      int period_fast,
      int shift_fast,
      ENUM_MA_METHOD method_fast,
      ENUM_APPLIED_PRICE price_fast,
      int period_slow,
      int shift_slow,
      ENUM_MA_METHOD method_slow,
      ENUM_APPLIED_PRICE price_slow,
      double percent_change_maslow)
  {
   CrossMAConfig cfg;
   cfg.tf = tf;

   cfg.poids[0] = p0;
   cfg.enabled[0] = e0;

   cfg.period_fast  = period_fast;
   cfg.shift_fast   = shift_fast;
   cfg.method_fast  = method_fast;
   cfg.price_fast   = price_fast;

   cfg.period_slow  = period_slow;
   cfg.shift_slow   = shift_slow;
   cfg.method_slow  = method_slow;
   cfg.price_slow   = price_slow;
   cfg.percent_change_maslow = percent_change_maslow;

   return cfg;
  }
//+------------------------------------------------------------------+
//| Création d'une configuration RSI AU                              |
//+------------------------------------------------------------------+
RSI_ESConfig CSignalConfigFactory::CreateRSI_ESConfig(ENUM_TIMEFRAMES tf,
      int period,
      ENUM_APPLIED_PRICE price,
      double seuil_maxES,
      double seuil_minES,
      bool   emergency_stop)
  {
   RSI_ESConfig cfg;
   cfg.tf                = tf;
   cfg.period            = period;
   cfg.price             = price;

   cfg.seuil_maxES   = seuil_maxES;
   cfg.seuil_minES   = seuil_minES;
   cfg.emergency_stop    = emergency_stop;

   return cfg;
  }
#endif // __SIGNAL_CONFIG_FACTORY_MQH__
//+------------------------------------------------------------------+
// Fin de la classe CSignalConfigFactory                             |
