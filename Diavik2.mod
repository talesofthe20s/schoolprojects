/*********************************************
 * OPL 12.6.0.0 Model
 * Author: julie
 * Creation Date: 2014-11-19 at 9:18:43 PM
 *********************************************/

int benchMax = ...;
int timeMax = ...;
range bench = 1..benchMax;
range digPeriod = 1..timeMax;

float diamondValue = ...;
float processingCost = ...;
float dikeConstructionCost = ...;
float graniteDensity = ...;

float benchHeight = ...;
float minRadius = ...;
float minRadiusStepSize = ...;
float dikeGapRadius = ...;
float radiusSquared[b in bench] = pow(minRadius + minRadiusStepSize*(b-1),2);

float tnsKimberlite1 = ...;
float tnsKimberlite2 = ...;
float tnsKimberlite3 = ...;
float tnsKimberlite4 = ...;
float tnsKimberlite5 = ...;
float tnsKimberlite6 = ...;
float volKimberlite1 = ...;
float volKimberlite2 = ...;
float volKimberlite3 = ...;
float volKimberlite4 = ...;
float volKimberlite5 = ...;
float volKimberlite6 = ...;

float miningCost1 = ...;
float miningCost2 = ...;
float miningCost3 = ...;
float miningCost4 = ...;
float miningCost5 = ...;
float miningCost6 = ...;

dvar boolean miningPlan[bench][digPeriod];

//Diamond Revenue
dexpr float diamondProfit1 = sum(b in 1..10 : b <= benchMax, d in digPeriod)(diamondValue*tnsKimberlite1*miningPlan[b][d]);
dexpr float diamondProfit2 = sum(b in 11..20 : b <= benchMax, d in digPeriod)(diamondValue*tnsKimberlite2*miningPlan[b][d]);
dexpr float diamondProfit3 = sum(b in 21..30 : b <= benchMax, d in digPeriod)(diamondValue*tnsKimberlite3*miningPlan[b][d]);
dexpr float diamondProfit4 = sum(b in 31..40 : b <= benchMax, d in digPeriod)(diamondValue*tnsKimberlite4*miningPlan[b][d]);
dexpr float diamondProfit5 = sum(b in 41..50 : b <= benchMax, d in digPeriod)(diamondValue*tnsKimberlite5*miningPlan[b][d]);
dexpr float diamondProfit6 = sum(b in 51..60 : b <= benchMax, d in digPeriod)(diamondValue*tnsKimberlite6*miningPlan[b][d]);
dexpr float totalDiamondProfit = diamondProfit1+diamondProfit2+diamondProfit3+diamondProfit4+diamondProfit5+diamondProfit6;

//Kimberlite processing cost
dexpr float processingCost1 = sum(b in 1..10 : b <= benchMax, d in digPeriod)(processingCost*tnsKimberlite1*miningPlan[b][d]);
dexpr float processingCost2 = sum(b in 11..20 : b <= benchMax, d in digPeriod)(processingCost*tnsKimberlite2*miningPlan[b][d]);
dexpr float processingCost3 = sum(b in 21..30 : b <= benchMax, d in digPeriod)(processingCost*tnsKimberlite3*miningPlan[b][d]);
dexpr float processingCost4 = sum(b in 31..40 : b <= benchMax, d in digPeriod)(processingCost*tnsKimberlite4*miningPlan[b][d]);
dexpr float processingCost5 = sum(b in 41..50 : b <= benchMax, d in digPeriod)(processingCost*tnsKimberlite5*miningPlan[b][d]);
dexpr float processingCost6 = sum(b in 51..60 : b <= benchMax, d in digPeriod)(processingCost*tnsKimberlite6*miningPlan[b][d]);
dexpr float totalProcessingCost = processingCost1+processingCost2+processingCost3+processingCost4+processingCost5+processingCost6;

//Dike construction and cost
float pi = 3.141592654;
dexpr int nbBenches = sum (b in bench, d in digPeriod)(miningPlan[b][d]);
dexpr float dikeRadius = minRadius+minRadiusStepSize*(nbBenches-1)+dikeGapRadius;
dexpr float dikeCircumference = 2*pi*dikeRadius;
dexpr float totalDikeConstructionCost = dikeCircumference*dikeConstructionCost;

//Tones of material mined
float tnsMaterialValues[bench];
execute
{
	for(var b in bench)
	{
		tnsMaterialValues[b] = 0;	
	}
	for(b in bench)
	{
		tnsMaterialValues[b] += graniteDensity*((pi*benchHeight*radiusSquared[b])-volKimberlite6)+tnsKimberlite6;
		if (b + 10 <= benchMax)
		{
			tnsMaterialValues[b+10] += (graniteDensity*((pi*benchHeight*radiusSquared[b])-volKimberlite5)+tnsKimberlite5) 
										- (graniteDensity*((pi*benchHeight*radiusSquared[b])-volKimberlite6)+tnsKimberlite6);
			if (b + 20 <= benchMax)
			{
				tnsMaterialValues[b+20] += (graniteDensity*((pi*benchHeight*radiusSquared[b])-volKimberlite4)+tnsKimberlite4) 
											- (graniteDensity*((pi*benchHeight*radiusSquared[b])-volKimberlite5)+tnsKimberlite5);
         		if (b + 30 <= benchMax)
         		{											
					tnsMaterialValues[b+30] += (graniteDensity*((pi*benchHeight*radiusSquared[b])-volKimberlite3)+tnsKimberlite3)
											- (graniteDensity*((pi*benchHeight*radiusSquared[b])-volKimberlite4)+tnsKimberlite4);
					if (b + 40 <= benchMax)
					{											
						tnsMaterialValues[b+40] += (graniteDensity*((pi*benchHeight*radiusSquared[b])-volKimberlite2)+tnsKimberlite2)
													- (graniteDensity*((pi*benchHeight*radiusSquared[b])-volKimberlite3)+tnsKimberlite3);
						if (b + 50 <= benchMax)
						{
							tnsMaterialValues[b+50] += (graniteDensity*((pi*benchHeight*radiusSquared[b])-volKimberlite1)+tnsKimberlite1)
														- (graniteDensity*((pi*benchHeight*radiusSquared[b])-volKimberlite2)+tnsKimberlite2);
            			}
             		}
             	}
            }
         }
     }                                  	             			            																	
}

dexpr float tnsMaterial1 = sum(b in 1..10 : b <= benchMax, d in digPeriod)(miningPlan[b][d]*tnsMaterialValues[b]);
dexpr float tnsMaterial2 = sum(b in 11..20 : b <= benchMax, d in digPeriod)(miningPlan[b][d]*tnsMaterialValues[b]);
dexpr float tnsMaterial3 = sum(b in 21..30 : b <= benchMax, d in digPeriod)(miningPlan[b][d]*tnsMaterialValues[b]);
dexpr float tnsMaterial4 = sum(b in 31..40 : b <= benchMax, d in digPeriod)(miningPlan[b][d]*tnsMaterialValues[b]);
dexpr float tnsMaterial5 = sum(b in 41..50 : b <= benchMax, d in digPeriod)(miningPlan[b][d]*tnsMaterialValues[b]);
dexpr float tnsMaterial6 = sum(b in 51..60 : b <= benchMax, d in digPeriod)(miningPlan[b][d]*tnsMaterialValues[b]);

//Mining costs
dexpr float tMiningCost1 = (miningCost1*tnsMaterial1);
dexpr float tMiningCost2 = (miningCost2*tnsMaterial2);
dexpr float tMiningCost3 = (miningCost3*tnsMaterial3);
dexpr float tMiningCost4 = (miningCost4*tnsMaterial4);
dexpr float tMiningCost5 = (miningCost5*tnsMaterial5);
dexpr float tMiningCost6 = (miningCost6*tnsMaterial6);

dexpr float totalMiningCost = tMiningCost1+tMiningCost2+tMiningCost3+tMiningCost4+tMiningCost5+tMiningCost6;

int constructionTime = ...;
int firstBench = ...;

maximize
  totalDiamondProfit - totalProcessingCost - totalDikeConstructionCost - totalMiningCost;
 
subject to {
  	
  	//Benches must be dug sequentialy from the top down
  	ctDigOrder1:
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
  	forall(b in bench, d in digPeriod : d <= constructionTime)
  		miningPlan[b][d]==0;
  	
  	//Forcing constraint
  	//For debugging purposes, and to force the mine to be dug
  	ctMustDig:
  	sum(b in bench, d in digPeriod) miningPlan[b][d] >= 1;
  	
  	//You must begin digging at the earliest possible time
  	ctForcedTime:
  	miningPlan[firstBench][constructionTime+1] == 1;
  	
  	
  	
  }