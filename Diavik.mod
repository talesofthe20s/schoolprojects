/*********************************************
 * OPL 12.6.0.0 Model
 * Author: julie
 * Creation Date: 2014-10-03 at 11:55:13 AM
 *********************************************/
int nbCylindars = 60;
range Cylindar = 1..nbCylindars;
//I have changed to dig period (23weeks), max is 20 year
int nbYears = 50;
range Year = 1..nbYears;
range Depth10m = 1..10;
range Depth20m = 11..20;
range Depth30m = 21..30;
range Depth40m = 31..40;
range Depth50m = 41..50;
range Depth60m = 51..60;

float diamondValue = 278973427.64;
float processingCost = 33929200.66;
float tnsKimberlite = 1884955.59215;

float radius[Cylindar];
float volGranite[Cylindar];
float miningCost[Cylindar];
float dikeCost;
int dikeBuilt;

dvar boolean miningPlan[Cylindar][Year];

maximize sum (c in Cylindar, y in Year)
  miningPlan[c][y]*(diamondValue-processingCost) - sum(c in Cylindar) miningCost[c] - dikeCost;
  

subject to {
  	//Define radius of Cylindar n
	CT1:forall(c in Cylindar, y in Year)
	  radius[c] >= miningPlan[c][y]*(200.0 + 9.33*(sum (c in Cylindar, y in Year)(miningPlan[c][y])-c));  
  	
  	//Define granite volume
	CT2:forall(c in Cylindar)
	  volGranite[c] == 3.141592654*10.0*(radius[c]*radius[c]-40000.0);  	
  	
  	//Define minimum mining cost
  	CT3:forall(c in Depth10m)
  	  miningCost[c] >= 4.5*(2.0*volGranite[c]+tnsKimberlite);
  	CT4:forall(c in Depth20m)
  	  miningCost[c] >= 5.5*(2.0*volGranite[c]+tnsKimberlite);
  	CT5:forall(c in Depth30m)
  	  miningCost[c] >= 6.5*(2.0*volGranite[c]+tnsKimberlite);
  	CT6:forall(c in Depth40m)
  	  miningCost[c] >= 8.0*(2.0*volGranite[c]+tnsKimberlite);
  	CT7:forall(c in Depth50m)
  	  miningCost[c] >= 12.0*(2.0*volGranite[c]+tnsKimberlite);
  	CT8:forall(c in Depth60m)
  	  miningCost[c] >= 18.0*(2.0*volGranite[c]+tnsKimberlite);
  	
  	//Define the dike cost
  	CT9:dikeCost >= 100000.0 * 2.0 * 3.141592654*(50.0+radius[1]);
  	
  	//In a fixed year
  	//If Cn not dug, cannot dig any further
  	CT10:forall(c in 1..nbCylindars-1, y in Year)
  	  miningPlan[c][y] >= miningPlan[c+1][y];
  	
  	//Cn must be finished before digging next level
  	//dealt with by setting dig time periods   	
  	//Once Cn is dug, cannot be dug again
  	CT11:forall(c in Cylindar, y in 1..nbYears-1)
  	  miningPlan[c][y]+miningPlan[c][y+1] <= 1;
  	
  	//cannot dig faster than you can process
  	//cannot dig 2 at once
  	CT12:forall(y in Year)
  	  sum(c in Cylindar) miningPlan[c][y] <= 1;
    
  	//cannot dig until the dike is built
  	CT13:forall(y in 1..dikeBuilt)
  	  miningPlan[1][y] == 0; 
  	
  	//how long does it take to build the dike
  	//given in digging(processing) periods 884.6m/dig period
  	//hoping this minimizes dikeBuilt, cannot set == since must be integer
  	CT14:dikeBuilt>=(2.0 * 3.141592654*(50.0+radius[1])) / 884.6;
  	
  	
  
};
  
