/*********************************************
 * OPL 12.6.0.0 Model
 * Author: julie
 * Creation Date: 2014-11-20 at 2:20:09 PM
 *********************************************/
int benchMax = ...;
int timeMax = ...;
range bench = 1..benchMax;
range digPeriod = 1..timeMax;

float diamondValue = ...;
dvar float inflatedDiamondValue[bench][digPeriod];

float miningCost10 = ...;
float miningCost20 = ...;
float miningCost30 = ...;
float miningCost40 = ...;
float miningCost50 = ...;
float miningCost60 = ...;
dvar float inflatedMiningCost10[bench][digPeriod];
dvar float inflatedMiningCost20[bench][digPeriod];
dvar float inflatedMiningCost30[bench][digPeriod];
dvar float inflatedMiningCost40[bench][digPeriod];
dvar float inflatedMiningCost50[bench][digPeriod];
dvar float inflatedMiningCost60[bench][digPeriod];

float processingCost = ...;
float tnsKimberlite = ...;
float tnsGranite[bench] = ... ;

dvar boolean miningPlan[bench][digPeriod];

float pi = 3.141592654;
dexpr int nbBenches = sum (b in bench, d in digPeriod)(miningPlan[b][d]);
dexpr float dikeRadius = 200+9.33*(nbBenches-1)+50;
dexpr float dikeCircumference = 2*pi*dikeRadius;

dexpr float diamondProfit = sum(b in bench, d in digPeriod)(inflatedDiamondValue[b][d]*miningPlan[b][d]);
dexpr float totalProcessingCost = processingCost*nbBenches;
dexpr float dikeCost = dikeCircumference*100000;
dexpr float miningCost1 = (sum(b in benchMax-9..benchMax, d in digPeriod)(inflatedMiningCost10[b][d]*(tnsGranite[b]+tnsKimberlite)*miningPlan[b][d]));
dexpr float miningCost2 = (sum(b in benchMax-19..benchMax-10, d in digPeriod)(inflatedMiningCost20[b][d]*(tnsGranite[b]+tnsKimberlite)*miningPlan[b][d]));
dexpr float miningCost3 = (sum(b in benchMax-29..benchMax-20, d in digPeriod)(inflatedMiningCost30[b][d]*(tnsGranite[b]+tnsKimberlite)*miningPlan[b][d]));
dexpr float miningCost4 = (sum(b in benchMax-39..benchMax-30, d in digPeriod)(inflatedMiningCost40[b][d]*(tnsGranite[b]+tnsKimberlite)*miningPlan[b][d]));
dexpr float miningCost5 = (sum(b in benchMax-49..benchMax-40, d in digPeriod)(inflatedMiningCost50[b][d]*(tnsGranite[b]+tnsKimberlite)*miningPlan[b][d]));
dexpr float miningCost6 = (sum(b in benchMax-59..benchMax-50, d in digPeriod)(inflatedMiningCost60[b][d]*(tnsGranite[b]+tnsKimberlite)*miningPlan[b][d])); 
dexpr float totalMiningCost = (miningCost1 + miningCost2 + miningCost3 + miningCost4 + miningCost5 + miningCost6); 

maximize
  diamondProfit - totalProcessingCost - dikeCost - totalMiningCost;
 
  subject to {
  	
  	//Define Inflated Diamond Value
  	forall(b in bench, d in 3..timeMax)
  	  inflatedDiamondValue[b][d] == 1.03*inflatedDiamondValue[b][d-2];
  	forall(b in bench){
  	  inflatedDiamondValue[b][1] == diamondValue;
  	  inflatedDiamondValue[b][2] == diamondValue; }
  	
  	//Define inflated mining cost to 100m depth
  	forall(b in bench, d in 3..timeMax)
  	  inflatedMiningCost10[b][d] == 1.03*inflatedMiningCost10[b][d-2];
  	forall(b in bench){
  	  inflatedMiningCost10[b][1] == miningCost10;
  	  inflatedMiningCost10[b][2] == miningCost10; }
  	//Define inflated mining cost to 200m
  	forall(b in bench, d in 3..timeMax)
  	  inflatedMiningCost20[b][d] == 1.03*inflatedMiningCost20[b][d-2];
  	forall(b in bench){
  	  inflatedMiningCost20[b][1] == miningCost20;
  	  inflatedMiningCost20[b][2] == miningCost20; }
  	//Define inflated mining cost to 300m
  	forall(b in bench, d in 3..timeMax)
  	  inflatedMiningCost30[b][d] == 1.03*inflatedMiningCost30[b][d-2];
  	forall(b in bench){
  	  inflatedMiningCost30[b][1] == miningCost30;
  	  inflatedMiningCost30[b][2] == miningCost30; } 
  	//Define inflated mining cost to 400m
  	forall(b in bench, d in 3..timeMax)
  	  inflatedMiningCost40[b][d] == 1.03*inflatedMiningCost40[b][d-2];
  	forall(b in bench){
  	  inflatedMiningCost40[b][1] == miningCost40;
  	  inflatedMiningCost40[b][2] == miningCost40; }
  	//Define inflated mining cost to 500m
  	forall(b in bench, d in 3..timeMax)
  	  inflatedMiningCost50[b][d] == 1.03*inflatedMiningCost50[b][d-2];
  	forall(b in bench){
  	  inflatedMiningCost50[b][1] == miningCost50;
  	  inflatedMiningCost50[b][2] == miningCost50; }
  	//Define inflated mining cost to 600m
  	forall(b in bench, d in 3..timeMax)
  	  inflatedMiningCost60[b][d] == 1.03*inflatedMiningCost60[b][d-2];
  	forall(b in bench){
  	  inflatedMiningCost60[b][1] == miningCost60;
  	  inflatedMiningCost60[b][2] == miningCost60; }
  	
  	
  	//Benches must be dug sequentialy from the top down
  	ctDigOrder:
  	forall(b in 2..benchMax, d in 1..timeMax-1)
  	  miningPlan[b][d]<=miningPlan[b-1][d+1];
  	ctDigOrder2:
  	forall(b in 2..benchMax)
  	  sum(d in digPeriod)miningPlan[b][d]<=sum(d in digPeriod)miningPlan[b-1][d];
 
  	
  	//Each bench may only be dug once
  	ctDigOnce:
  	forall(b in bench)
  	  sum(d in digPeriod) miningPlan[b][d] <= 1;
  	
  	//You should not dig faster than you can process
  	//That is, you can only dig once bench at a time
  	ctOneAtTime:
	forall(d in digPeriod)
  	  sum(b in bench) miningPlan[b][d] <= 1;
    
  	//Dike construction must be completed before you can begin digging
  	ctDikeConstruction:
  	forall(b in bench, d in digPeriod : d <= 6)
  		miningPlan[b][d]==0;
  	
  	//Forcing constraint
  	//For debugging purposes, and to force the mine to be dug
  	ctMustDig:
  	sum(b in bench, d in digPeriod) miningPlan[b][d] >= 1;
  	
  	
  }