//+------------------------------------------------------------------+
//| MoneyFTMOChallenge.mqh                                           |
//+------------------------------------------------------------------+
/// @file MoneyFTMOChallenge.mqh
/// @brief Classe de gestion du risque FTMO avec limitation des pertes journalières.
/// @details Cette classe dérive de CExpertMoney et applique les règles du challenge FTMO :
///          - Calcul d'un plafond de perte quotidienne (réalisée + latente)
///          - Blocage des ouvertures lorsqu'on dépasse un seuil "buffer" défini en % du max de perte FTMO
///          - Pare‑feu qui ferme toutes les positions au‑delà de ce seuil
///          - Possibilité d'utiliser un money‑manager interne pour gérer la taille de lots (FixedLot, FixedRisk... du framework MQL5 de base)

#ifndef  MONEY_FTMO_CHALLENGE_MQH
#define  MONEY_FTMO_CHALLENGE_MQH

#include <Expert\ExpertMoney.mqh>
#include <Trade\Trade.mqh>

//+------------------------------------------------------------------+
//| Classe CMoneyFTMOChallenge                                       |
//+------------------------------------------------------------------+
/// @class CMoneyFTMOChallenge
/// @brief Implémente une stratégie de money management conforme aux règles FTMO.
class CMoneyFTMOChallenge : public CExpertMoney
  {
protected:
   double            m_initial_balance;     ///< Solde initial FTMO
   double            m_max_daily_loss;      ///< Plafond de perte journalière 
   double            m_closed_pnl_today;    ///< Pertes et Profits réalisés depuis minuit CE(S)T
   datetime          m_last_reset_day;      ///< Date du dernier reset (CET/CEST)
   CExpertMoney      *m_inner_money;        ///< Money manager interne
   datetime          m_last_bar_time;       ///< Dernière bougie traitée
   double            m_buffer_ratio;        ///< Ratio de déclenchement du pare‑feu (ex: 0.90 = 90 % du plafond)
   datetime          m_last_calc_time;      ///< Timestamp du dernier recalcul FTMO

public:
                     /// @brief Constructeur principal
                     /// @param percent  Pourcentage maximal de perte journalière (ex: 5.0)
                     /// @param initial_balance Solde de départ pour le calcul du plafond
                     /// @param buffer_percent  Marge de sécurité avant clôture (0‑100)
                     /// @param inner   Pointeur vers un money‑manager secondaire (optionnel)
                     CMoneyFTMOChallenge(double percent,
                       double initial_balance,
                       double buffer_percent = 90.0,
                       CExpertMoney *inner = NULL);

                     /// @brief Destructeur par défaut
                    ~CMoneyFTMOChallenge(void);

   // Framework
   /// @brief Valide les paramètres du money manager FTMO
   /// @return true si les paramètres sont cohérents
   virtual bool      ValidationSettings(void);

   /// @brief Vérifie l'autorisation d'ouverture d'une position Long
   /// @param price Prix d'entrée proposé
   /// @param sl    Valeur de stop loss proposée
   /// @return Taille de lot à ouvrir, ou 0 si refusé
   virtual double    CheckOpenLong(double price,double sl);

   /// @brief Vérifie l'autorisation d'ouverture d'une position Short
   /// @param price Prix d'entrée proposé
   /// @param sl    Valeur de stop loss proposée
   /// @return Taille de lot à ouvrir, ou 0 si refusé
   virtual double    CheckOpenShort(double price,double sl);

   /// @brief Méthode non utilisée ici (surcharge obligatoire)
   virtual double    CheckClose(CPositionInfo *position) { return 0.0; }

   // FTMO
   /// @brief Vérifie si le seuil de perte journalière a été dépassé
   /// @return true si la perte cumulée dépasse la limite FTMO
   bool              IsDailyLossLimitExceeded();

   /// @brief Force la clôture de toutes les positions ouvertes si seuil critique atteint
   /// @return true si toutes les positions ont bien été fermées
   bool              ForceClosePositionsIfNeeded();   // <-- nouvelle

protected:
   // Outils internes
   /// @brief Met à jour le PnL réalisé depuis minuit (base CE(S)T)
   void              UpdateDailyClosedPnl();

   /// @brief Calcule le PnL latent du compte (profit + swap + commissions)
   /// @return Somme des profits/pertes non réalisés
   double            AccountFloatingPnl();

   /// @brief Retourne l’instant de minuit CE(S)T du jour en cours
   /// @return Timestamp UTC équivalent à 00:00 CE(S)T
   datetime          CETTodayMidnight();

   /// @brief Détecte si une date UTC est en heure d’été (CEST)
   /// @param utc_time Timestamp UTC à analyser
   /// @return true si en CEST, false si en CET
   bool              IsPragueInSummerTime(datetime utc_time);

   /// @brief Calcule la commission cumulée pour une position
   /// @param ticket Identifiant de position
   /// @return Commission totale (négative)
   double            PositionCommission(ulong ticket);
  };
//+------------------------------------------------------------------+
//| Constructeur                                                     |
//+------------------------------------------------------------------+
CMoneyFTMOChallenge::CMoneyFTMOChallenge(double percent,
      double initial_balance,
      double buffer_percent,
      CExpertMoney *inner)
  {
   m_last_calc_time = 0;
   m_last_bar_time      = 0;
   m_has_tf_significance= false;
   m_inner_money        = inner;
   m_closed_pnl_today   = 0.0;
   m_last_reset_day     = 0;

   m_percent            = percent;                
   m_initial_balance    = initial_balance;
   m_max_daily_loss     = m_initial_balance * m_percent / 100.0;
   m_buffer_ratio       = MathMin(MathMax(buffer_percent/100.0,0.0),1.0);

   PrintFormat("FTMO mode : balance %.2f | max loss %.2f (%.2f %%) | buffer %.1f %%",
               m_initial_balance, m_max_daily_loss, m_percent, m_buffer_ratio*100.0);
  }
//+------------------------------------------------------------------+
//| Destructeur                                                      |
//+------------------------------------------------------------------+
CMoneyFTMOChallenge::~CMoneyFTMOChallenge(void) {}
//+------------------------------------------------------------------+
//| Validation des paramètres                                        |
//+------------------------------------------------------------------+
bool CMoneyFTMOChallenge::ValidationSettings(void)
  {
   if(!CExpertMoney::ValidationSettings())
      return false;
   if(m_initial_balance<=0.0)
     {
      printf(__FUNCTION__+": solde initial invalide");
      return false;
     }
   if(m_percent<=0.0 || m_percent>5.0)
     {
      printf(__FUNCTION__+": percent hors plage");
      return false;
     }
   if(m_buffer_ratio<=0.0 || m_buffer_ratio>1.0)
     {
      printf(__FUNCTION__+": buffer%% invalide");
      return false;
     }
   if(m_inner_money && !m_inner_money.ValidationSettings())
     {
      printf(__FUNCTION__+": inner money invalide");
      return false;
     }
   return true;
  }
//+------------------------------------------------------------------+
//| Détection heure d'été Prague                                     |
//+------------------------------------------------------------------+
bool CMoneyFTMOChallenge::IsPragueInSummerTime(datetime utc_time)
  {
   MqlDateTime dt;
   TimeToStruct(utc_time,dt);
   int y=dt.year;
// Dernier dimanche mars 00:00 UTC
   MqlDateTime s= {0};
   s.year=y;
   s.mon=3;
   s.day=31;
   datetime start=StructToTime(s);
   MqlDateTime tmp;
   while(true)
     {
      TimeToStruct(start,tmp);
      if(tmp.day_of_week==0)
         break;
      start-=86400;
     }
// Dernier dimanche oct 00:00 UTC
   MqlDateTime w= {0};
   w.year=y;
   w.mon=10;
   w.day=31;
   datetime stop=StructToTime(w);
   while(true)
     {
      TimeToStruct(stop,tmp);
      if(tmp.day_of_week==0)
         break;
      stop-=86400;
     }
   return (utc_time>=start && utc_time<stop);
  }

//+------------------------------------------------------------------+
//| Calcul CET Today Midnight                                        |
//+------------------------------------------------------------------+
datetime CMoneyFTMOChallenge::CETTodayMidnight()
  {
   datetime now_utc=TimeGMT();
   int offset=IsPragueInSummerTime(now_utc)?2:1;
   MqlDateTime t;
   TimeToStruct(now_utc+offset*3600,t);
   t.hour=0;
   t.min=0;
   t.sec=0;
   return StructToTime(t)-offset*3600;
  }

//+------------------------------------------------------------------+
//| Vérification des positions ouvertes                              |
//+------------------------------------------------------------------+
void CMoneyFTMOChallenge::UpdateDailyClosedPnl()
  {
   datetime today=CETTodayMidnight();
   if(m_last_reset_day!=today)
     {
      m_closed_pnl_today=0.0;
      m_last_reset_day=today;
     }
   if(!HistorySelect(today,TimeGMT()))
     {
      m_closed_pnl_today=0.0;
      return;
     }

   double sum=0.0;
   int total=HistoryDealsTotal();
   for(int i=total-1;i>=0;--i)
     {
      ulong ticket=HistoryDealGetTicket(i);
      if(HistoryDealGetInteger(ticket,DEAL_ENTRY)!=DEAL_ENTRY_OUT)
         continue;
      sum+=HistoryDealGetDouble(ticket,DEAL_PROFIT)
           +HistoryDealGetDouble(ticket,DEAL_SWAP)
           +HistoryDealGetDouble(ticket,DEAL_COMMISSION);
     }
   m_closed_pnl_today=sum;
  }
//+------------------------------------------------------------------+
//| Commission déjà payée sur une position ouverte                   |
//+------------------------------------------------------------------+
double CMoneyFTMOChallenge::PositionCommission(ulong ticket)
  {
   double commission = 0.0;
   // On parcourt tous les deals du compte jusqu'à maintenant
   if(HistorySelect(0, TimeCurrent()))
     {
      const int total = HistoryDealsTotal();
      for(int i = total-1; i >= 0; --i)
        {
         ulong  deal = HistoryDealGetTicket(i);
         if(HistoryDealGetInteger(deal, DEAL_POSITION_ID) != ticket)
            continue;                       // deal d'une autre position
         commission += HistoryDealGetDouble(deal, DEAL_COMMISSION); // valeur négative
        }
     }
   return commission;
  }
//+------------------------------------------------------------------+
//| Account Floating PnL                                             |
//+------------------------------------------------------------------+
double CMoneyFTMOChallenge::AccountFloatingPnl()
  {
   double pnl = 0.0;

   for(int i = PositionsTotal()-1; i >= 0; --i)
     {
      ulong ticket = PositionGetTicket(i);
      if(!PositionSelectByTicket(ticket))
         continue;

      // Profit latent et swap (inchangés)
      double pos_pnl = PositionGetDouble(POSITION_PROFIT)
                     + PositionGetDouble(POSITION_SWAP);

      // Commission déjà prélevée sur cette position
      double comm   = PositionCommission(ticket);

      pnl += pos_pnl + comm;  // comm est négatif – on garde le signe
     }
   return pnl;
  }

//+-------------------------------------------------------------------+
//| Pare-feu : clôture forcée si on dépasse buffer% du plafond        |
//+-------------------------------------------------------------------+
bool CMoneyFTMOChallenge::ForceClosePositionsIfNeeded()
  {
   double floating=AccountFloatingPnl();
   double total_loss=-m_closed_pnl_today - floating;
   if(total_loss < m_max_daily_loss*m_buffer_ratio)
      return false;   // encore de la marge

   CTrade trade;
   bool ok=true;
   for(int i=PositionsTotal()-1;i>=0;--i)
     {
      ulong ticket=PositionGetTicket(i);
      if(!PositionSelectByTicket(ticket))
         continue;

      ok &= trade.PositionClose(ticket, 5);
     }

   if(ok)
      PrintFormat("FTMO pare-feu : toutes positions fermées (%.2f / %.2f USD)",
                  total_loss,m_max_daily_loss);
   return ok;
  }
//+-------------------------------------------------------------------+
//| Vérification du seuil maxi de perte journalier                    |
//+-------------------------------------------------------------------+
bool CMoneyFTMOChallenge::IsDailyLossLimitExceeded()
  {
   datetime now  = TimeCurrent();
   datetime bar_time = iTime(_Symbol, PERIOD_CURRENT, 0);
   if(bar_time == 0)            // historique pas prêt
      return false;

//--- Condition de recalcul :
// 1) nouvelle bougie
// 2) ou 120 s écoulées depuis le dernier calcul
   static bool cached = false;
   if(bar_time == m_last_bar_time && now - m_last_calc_time < 120)
      return cached;            // encore frais, on renvoie le cache

//--- On recalcule
   m_last_bar_time  = bar_time;
   m_last_calc_time = now;

   UpdateDailyClosedPnl();
   double floating   = AccountFloatingPnl();
   double total_loss = -m_closed_pnl_today - floating;
   double threshold  = m_max_daily_loss * m_buffer_ratio;
   cached            = (total_loss >= threshold);

// log unique
   static bool warnedOpen = false;
   if(cached && !warnedOpen)
     {
      PrintFormat("FTMO blocage : perte %.2f USD ≥ seuil %.2f USD (%.1f %%)",
                  total_loss, threshold, m_buffer_ratio*100.0);
      warnedOpen = true;
     }
   if(!cached)
      warnedOpen = false;

// pare-feu
   ForceClosePositionsIfNeeded();
   return cached;
  }
  
//+-------------------------------------------------------------------+
//| Check Open Long                                                   |
//+-------------------------------------------------------------------+
double CMoneyFTMOChallenge::CheckOpenLong(double price,double sl)
  {
   if(IsDailyLossLimitExceeded())
      return 0.0;
   if(m_inner_money)
      return m_inner_money.CheckOpenLong(price,sl);
   return (m_symbol ? m_symbol.LotsMin() : 0.0);
  }
//+-------------------------------------------------------------------+
//| Check Open Short                                                  |
//+-------------------------------------------------------------------+
double CMoneyFTMOChallenge::CheckOpenShort(double price,double sl)
  {
   if(IsDailyLossLimitExceeded())
      return 0.0;
   if(m_inner_money)
      return m_inner_money.CheckOpenShort(price,sl);
   return (m_symbol ? m_symbol.LotsMin() : 0.0);
  }

#endif // MONEY_FTMO_CHALLENGE_MQH
