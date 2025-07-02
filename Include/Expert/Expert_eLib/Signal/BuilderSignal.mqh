﻿//+------------------------------------------------------------------+
//|                                       SignalBuilder.mqh          |
//|  Classe utilitaire pour construire des signaux composés          |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Lucas Troncy"
//+-------------------------------------------------------------------+
//| Notes de version                                                  |
//|28/03/2025 - Création                                              |
//|30/03/2025 - Modification avec ajout de template                   |
//|22/04/2025 - Un signal inactivé n'est plus ajouté au signal de base|
//+-------------------------------------------------------------------+
#ifndef __SIGNAL_BUILDER_MQH__
#define __SIGNAL_BUILDER_MQH__

#include <Expert\Expert_eLib\Signal\SignalITF_eLib.mqh>
#include <Expert\Expert_eLib\Signal\SignalHA_Am.mqh>
#include <Expert\Expert_eLib\Signal\SignalRSI_eLib.mqh>
#include <Expert\Expert_eLib\Signal\SignalMA_eLib.mqh>
#include <Expert\Expert_eLib\Signal\SignalStoch.mqh>
#include <Expert\Expert_eLib\Signal\SignalCrossMA.mqh>
#include <Expert\Utils\UtilsLTR.mqh>
#include <Expert\Expert_eLib\Config\SignalsConfig.mqh>

//+------------------------------------------------------------------+
//| Classe CSignalBuilder                                            |
//+------------------------------------------------------------------+
class CSignalBuilder
  {
public:
   // Interface unifiée
   static bool       BuildAndAddFilter(CSignalITF_eLib *signal, const HAConfig &cfg, bool isactive=true);
   static bool       BuildAndAddFilter(CSignalITF_eLib *signal, const RSIConfig &cfg, bool isactive=true);
   static bool       BuildAndAddFilter(CSignalITF_eLib *signal, const MAConfig &cfg, bool isactive=true);
   static bool       BuildAndAddFilter(CSignalITF_eLib *signal, const StochConfig &cfg, bool isactive=true);
   static bool       BuildAndAddFilter(CSignalITF_eLib *signal, const CrossMAConfig &cfg, bool isactive=true);
   // Tu ajouteras ici ADXConfig, etc.

private:
   // Fonction utilitaire pour factoriser l'ajout d'un filtre uniquement si isactive == true
   template<typename T>
   static T*         AddAndConfigureFilter(CSignalITF_eLib *signal, bool isactive)
     {
      if(signal == NULL)
         return NULL; // Signal principal NULL = vraie erreur

      T *filter = new T;
      if(filter == NULL)
         return NULL;

      if(!signal.AddFilter(filter))
         return NULL;

      // On ajoute ici : gestion du m_ignore
      if(!isactive)
         signal.IgnoreLastFilter();

      return filter;
     }
  };

//+------------------------------------------------------------------+
//| Implémentation : filtre Heikin Ashi                              |
//+------------------------------------------------------------------+
bool CSignalBuilder::BuildAndAddFilter(CSignalITF_eLib *signal, const HAConfig &cfg, bool isactive)
  {

   if(!isactive)
      return true; // **signal non actif : c'est un succès, pas une erreur**

   CSignalHAm *filter = AddAndConfigureFilter<CSignalHAm>(signal, isactive);
   if(filter == NULL)
      return false;

   filter.Period(cfg.tf);
   filter.PatternsUsage(CUtilsLTR::EncodeBitmask(cfg.enabled));

   filter.Pattern_0(cfg.poids[0]);
   filter.Pattern_1(cfg.poids[1]);
   filter.Pattern_2(cfg.poids[2]);
   filter.Pattern_3(cfg.poids[3]);
   filter.Pattern_4(cfg.poids[4]);
   filter.Pattern_5(cfg.poids[5]);

   filter.PctBigBody(cfg.pct_big_body);
   filter.PctMediumBody(cfg.pct_medium_body);
   filter.PctDojiBody(cfg.pct_doji_body);

   filter.PctTinyWick(cfg.pct_tiny_wick);
   filter.PctSmallWick(cfg.pct_small_wick);
   filter.PctLongWick(cfg.pct_long_wick);

   filter.DojiBefore(cfg.dojibefore);
   filter.AutoFullsize(cfg.auto_fullsize);
   filter.FullsizePts(cfg.fullsize_pts);

   return filter.ValidationSettings();
  }

//+------------------------------------------------------------------+
//| Implémentation : filtre RSI                                      |
//+------------------------------------------------------------------+
bool CSignalBuilder::BuildAndAddFilter(CSignalITF_eLib *signal, const RSIConfig &cfg, bool isactive)
  {
   if(!isactive)
      return true; // **signal non actif : c'est un succès, pas une erreur**

   CSignalRSI_eLib *filter = AddAndConfigureFilter<CSignalRSI_eLib>(signal, isactive);
   if(filter == NULL)
      return false;

   filter.Period(cfg.tf);
   filter.PeriodRSI(cfg.period);
   filter.Applied(cfg.price);
   filter.PatternsUsage(CUtilsLTR::EncodeBitmask(cfg.enabled));

   filter.Pattern_0(cfg.poids[0]);
   filter.Pattern_1(cfg.poids[1]);
   filter.Pattern_2(cfg.poids[2]);
   filter.Pattern_3(cfg.poids[3]);
   filter.Pattern_4(cfg.poids[4]);
   filter.Pattern_5(cfg.poids[5]);
   filter.Pattern_6(cfg.poids[6]); // ➔ Ajout pour le motif 6

   filter.SeuilSurAchete(cfg.seuil_surachete);
   filter.SeuilSurVendu(cfg.seuil_survendu);
   filter.MinRSIChange(cfg.min_rsi_change);

// ➔ Ajout des seuils pour le motif 6
   filter.SeuilMedianMax(cfg.seuil_medianmax);
   filter.SeuilMaximum(cfg.seuil_maximum);
   filter.SeuilMedianMin(cfg.seuil_medianmin);
   filter.SeuilMinimum(cfg.seuil_minimum);
   filter.TrendStrategy(cfg.trend_strategy);

   return filter.ValidationSettings();
  }
//+------------------------------------------------------------------+
//| Implémentation : filtre Moyenne Mobile                           |
//+------------------------------------------------------------------+
bool CSignalBuilder::BuildAndAddFilter(CSignalITF_eLib *signal, const MAConfig &cfg, bool isactive)
  {

   if(!isactive)
      return true; // **signal non actif : c'est un succès, pas une erreur**

   CSignalMA_eLib *filter = AddAndConfigureFilter<CSignalMA_eLib>(signal, isactive);
   if(filter == NULL)
      return false;

   filter.PeriodMA(cfg.period);
   filter.Shift(cfg.shift);
   filter.Method(cfg.method);
   filter.Applied(cfg.price);
   filter.Period(cfg.tf);

   filter.Pattern_0(cfg.poids[0]);
   filter.Pattern_1(cfg.poids[1]);
   filter.Pattern_2(cfg.poids[2]);
   filter.Pattern_3(cfg.poids[3]);
   filter.Pattern_4(cfg.poids[4]);
   filter.PatternsUsage(CUtilsLTR::EncodeBitmask(cfg.enabled));
   filter.MinMAChange(cfg.min_ma_change);
   filter.PriceDiffCloseMA(cfg.diff_price_ma);
   return filter.ValidationSettings();
  }
//+------------------------------------------------------------------+
//| Implémentation : filtre Stochastique                             |
//+------------------------------------------------------------------+
bool CSignalBuilder::BuildAndAddFilter(CSignalITF_eLib *signal, const StochConfig &cfg, bool isactive)
  {
   if(!isactive)
      return true; // **signal non actif : succès sans ajout**

   CSignalStoch *filter = AddAndConfigureFilter<CSignalStoch>(signal, isactive);
   if(filter == NULL)
      return false;

   filter.Period(cfg.tf);
   filter.PatternsUsage(CUtilsLTR::EncodeBitmask(cfg.enabled));

   filter.Pattern_0(cfg.poids[0]);
   filter.Pattern_1(cfg.poids[1]);
   filter.Pattern_2(cfg.poids[2]);
   filter.Pattern_3(cfg.poids[3]);
   filter.Pattern_4(cfg.poids[4]);

   filter.PeriodK(cfg.periodK);
   filter.PeriodD(cfg.periodD);
   filter.PeriodSlow(cfg.period_slow);
   filter.Applied(cfg.applied_price);

   return filter.ValidationSettings();
  }
//+------------------------------------------------------------------+
//| Implémentation : filtre CrossMA                                  |
//+------------------------------------------------------------------+  
bool CSignalBuilder::BuildAndAddFilter(CSignalITF_eLib *signal, const CrossMAConfig &cfg, bool isactive)
  {
   if(!isactive)
      return true; // signal non actif = succès sans ajout

   CSignalCrossMA *filter = AddAndConfigureFilter<CSignalCrossMA>(signal, isactive);
   if(filter == NULL)
      return false;

   filter.Period(cfg.tf);
   filter.PatternsUsage(CUtilsLTR::EncodeBitmask(cfg.enabled));

   filter.Pattern_0(cfg.poids[0]);
   filter.Pattern_1(cfg.poids[1]);
   filter.Pattern_2(cfg.poids[2]);
   filter.Pattern_3(cfg.poids[3]);
   filter.Pattern_4(cfg.poids[4]);

   // Paramètres MA rapide
   filter.PeriodFast(cfg.period_fast);
   filter.ShiftFast(cfg.shift_fast);
   filter.MethodFast(cfg.method_fast);
   filter.PriceFast(cfg.price_fast);

   // Paramètres MA lente
   filter.PeriodSlow(cfg.period_slow);
   filter.ShiftSlow(cfg.shift_slow);
   filter.MethodSlow(cfg.method_slow);
   filter.PriceSlow(cfg.price_slow);

   return filter.ValidationSettings();
  }

#endif // __SIGNAL_BUILDER_MQH__
//+------------------------------------------------------------------+
//|   Fin de la classe statique CSignalBuilder                       |
//+------------------------------------------------------------------+
