//+----------------------------------------------------------------------------------------------------+ 
//| Fonction de démarrage du script                                                                    | 
//+----------------------------------------------------------------------------------------------------+ 
void OnStart() 
  { 
//--- Nom de la société 
   string company=AccountInfoString(ACCOUNT_COMPANY); 
//--- Nom du client 
   string name=AccountInfoString(ACCOUNT_NAME); 
//--- Numéro du compte 
   long login=AccountInfoInteger(ACCOUNT_LOGIN); 
//--- Nom du serveur 
   string server=AccountInfoString(ACCOUNT_SERVER); 
//--- Devise du compte 
   string currency=AccountInfoString(ACCOUNT_CURRENCY); 
//--- Règle FIFO   
   bool fifo = AccountInfoInteger(ACCOUNT_FIFO_CLOSE);
   
//--- Compte de démo, de championnat ou réel 
   ENUM_ACCOUNT_TRADE_MODE account_type=(ENUM_ACCOUNT_TRADE_MODE)AccountInfoInteger(ACCOUNT_TRADE_MODE); 
   ENUM_ACCOUNT_MARGIN_MODE m_margin_mode=(ENUM_ACCOUNT_MARGIN_MODE)AccountInfoInteger(ACCOUNT_MARGIN_MODE);
//--- Transforme la valeur de l'énumération sous une forme lisible 
   string trade_mode;
   string margin_mode; 
   switch(account_type) 
     { 
      case  ACCOUNT_TRADE_MODE_DEMO: 
         trade_mode="demo"; 
         break; 
      case  ACCOUNT_TRADE_MODE_CONTEST: 
         trade_mode="championnat"; 
         break; 
      default: 
         trade_mode="réel"; 
         break; 
     } 
     
   switch(m_margin_mode) 
     { 
      case  ACCOUNT_MARGIN_MODE_EXCHANGE: 
         margin_mode="exchange"; 
         break; 
      case  ACCOUNT_MARGIN_MODE_RETAIL_NETTING: 
         margin_mode="netting"; 
         break; 
      case ACCOUNT_MARGIN_MODE_RETAIL_HEDGING:
         margin_mode="hedging"; 
         break; 
     }      
     
//--- Le Stop Out est définit en pourcentage ou en monnaie 
   ENUM_ACCOUNT_STOPOUT_MODE stop_out_mode=(ENUM_ACCOUNT_STOPOUT_MODE)AccountInfoInteger(ACCOUNT_MARGIN_SO_MODE); 
//--- Récupère la valeur des niveaux lorsque le Margin Call et le Stop Out se produisent 
   double margin_call=AccountInfoDouble(ACCOUNT_MARGIN_SO_CALL); 
   double stop_out=AccountInfoDouble(ACCOUNT_MARGIN_SO_SO); 
//--- Affiche des informations sur le compte 
   PrintFormat("Le compte '%s' #%d %s ouvert en '%s' sur le serveur '%s' en mode '%s'", 
               name,login,trade_mode,company,server,margin_mode); 
   PrintFormat("Devise du compte - %s, les niveaux de MarginCall et de StopOut levels sont définis en %s", 
               currency,(stop_out_mode==ACCOUNT_STOPOUT_MODE_PERCENT)?"pourcentage":" monnaie"); 
   PrintFormat("MarginCall=%G, StopOut=%G",margin_call,stop_out); 
   PrintFormat("FIFO: %s",(fifo==0?"false":"true"));
  }