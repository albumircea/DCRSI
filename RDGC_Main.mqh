//+------------------------------------------------------------------+
//|                                                    RDGC_Main.mqh |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"


#include "RDGC.mqh"


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
LOGGER_DEFINE_FILENAME("RDGC");
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BEGIN_INPUT(CRdgcParams)
INPUT(int, Magic, 1);               //Magic
INPUT(ENUM_RISK_TYPE, RiskType, ENUM_RISK_FIXED_LOTS);         //Risk Type
INPUT(double, Risk, 1);        //Risk
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
INPUT(int, RsiPeriod, 14); //Rsi Period
INPUT(int, RsiOverbought, 70); //Rsi Overbought
INPUT(int, RsiOversold, 30); //Rsi Overbought
INPUT(int, FastMaPeriod, 50); //Fast MA Period
INPUT(int, SlowMaPeriod, 200); //Slow MA Period
INPUT(ENUM_MA_METHOD, Mamethod, MODE_EMA); //Ma Method
END_INPUT
//+------------------------------------------------------------------+
DECLARE_EA(CRdgc, true, "RDGC");
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
