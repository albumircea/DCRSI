//+------------------------------------------------------------------+
//|                                                         RDGC.mqh |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"



#include "RDGCParams.mqh"
#include <Indicators/Oscilators.mqh>
#include <Indicators/Trend.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CRdgc : public CExpertAdvisor
{
protected:
   CiRSI                _iRSI;
   CiMA                 _iMaFast;
   CiMA                 _iMaSlow;
   CRdgcParams*         _params;
   CTradeManager        _tradeManager;

   const double      _rsiOverbought;
   int               _totalPositions;
   datetime          _candleTime;
   ENUM_DIRECTION    _currentDirection;


public:
   CRdgc(CRdgcParams *params): _rsiOverbought(70)
   {
      if(!_iRSI.Create(params.GetSymbol(), PERIOD_CURRENT, params.GetRsiPeriod(), PRICE_CLOSE))
         ExpertRemove();

      if(!_iMaFast.Create(params.GetSymbol(), PERIOD_CURRENT, params.GetFastMaPeriod(), 0, params.GetMamethod(), PRICE_CLOSE))
         ExpertRemove();

      if(!_iMaSlow.Create(params.GetSymbol(), PERIOD_CURRENT, params.GetSlowMaPeriod(), 0, params.GetMamethod(), PRICE_CLOSE))
         ExpertRemove();

      _params = params;
      _currentDirection = ENUM_DIRECTION_NEUTRAL;
   }
   ~CRdgc() {}


protected:

   bool               CheckForOpen();
   bool                         CheckForClose();

   bool              OpenTrade();
   bool              CloseTrades();

   void              RefreshValues()
   {
      _iRSI.Refresh();
      _iMaFast.Refresh();
      _iMaSlow.Refresh();
      _totalPositions = CTradeUtils::CountPositions(_params.GetMagic(), _params.GetSymbol());
   }

public:
   virtual void       Main();
   virtual void       OnTrade_() {}
protected:
   virtual void       OnReInit() {}
};


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CRdgc::Main()
{
   RefreshValues();


   if(!CSymbolInfo::IsSessionTrade(_params.GetSymbol()))
      return;

   if(!CCandleInfo::IsNewCandle(_candleTime,  PERIOD_CURRENT, _params.GetSymbol()))
      return;

   if(CheckForOpen())
   {
      OpenTrade();
      return;
   }
   else if(CheckForClose())
   {
      CloseTrades();
      return;
   }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CRdgc::OpenTrade()
{
   return (_tradeManager.Buy(_params.GetRisk(), 0, 0, NULL, _params.GetSymbol(), _params.GetMagic()) > 0);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CRdgc::CloseTrades()
{
   return _tradeManager.CloseBatch(_params.GetMagic(), _params.GetSymbol(), (int)POSITION_TYPE_BUY, LOGGER_PREFIX_ERROR);
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CRdgc::CheckForOpen()
{
   ENUM_DIRECTION signal = ENUM_DIRECTION_NEUTRAL;
   
   if(_totalPositions == 0 && _iMaFast.Main(1) > _iMaSlow.Main(1) && _iMaFast.Main(2) <= _iMaSlow.Main(2))// && CSymbolInfo::IsSessionTrade(_params.GetSymbol()))
      return true;

   if(_totalPositions > 0 && false && CSymbolInfo::IsSessionTrade(_params.GetSymbol())) // conditions for subsequent
      return true;

   return false;
}
//+------------------------------------------------------------------+
bool CRdgc::CheckForClose()
{
   static datetime candleTime = 0;
   return (
             _totalPositions > 0 && _iRSI.Main(1) > _rsiOverbought // aici sa pun rsi(1) sau rsi(0)
          );
}


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
