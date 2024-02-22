//+------------------------------------------------------------------+
//|                                                   RDGCParams.mqh |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"

#include <Mircea/_profitpoint/Base/ExpertBase.mqh>
#include <Mircea/_profitpoint/Trade/TradeManager.mqh>
#include <Mircea/RiskManagement/RiskService.mqh>
#include <Mircea/_profitpoint/Mql/CandleInfo.mqh>
#include <Mircea/RiskManagement/RiskService.mqh>
#include <Mircea/ExpertAdvisors/Hedge/HedgeCandles.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CRdgcParams: CAppParams
{
   ObjectAttrProtected(int, Magic);
   ObjectAttrProtected(ENUM_RISK_TYPE, RiskType);
   ObjectAttrProtected(double, Risk);
   ObjectAttrProtected(string, Symbol);

   ObjectAttrProtected(int, RsiPeriod);
   ObjectAttrProtected(int, RsiOverbought);
   ObjectAttrProtected(int, RsiOversold);
   ObjectAttrProtected(int, SlowMaPeriod);
   ObjectAttrProtected(int, FastMaPeriod);
   ObjectAttrProtected(ENUM_MA_METHOD, Mamethod);

public:

   virtual bool      Check() override
   {
      if(!CMQLInfo::IsTesting_() && !CAccount::IsDemo_())
      {
         Alert("This Expert Advisor is only available on demo accounts or strategy tester");
         return false;
      }

      if(mMagic <= 0)
      {
         Alert("Magic Number cannot be negative");
         return false;
      }
      if(mRisk <= 0)
      {
         Alert("Risk cannot be negative");
         return false;
      }
      mSymbol = Symbol();
      return true;
   }
};
//+------------------------------------------------------------------+
