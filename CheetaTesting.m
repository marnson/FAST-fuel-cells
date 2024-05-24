

truew = UnitConversionPkg.ConvMass([
1847.522594
	15715.22337
	10241.60151
	15756.31001
		  129852.40 
180608.7079]','lbm','kg');



CH = Main(AircraftSpecsPkg.CHEETA,@MissionProfilesPkg.NotionalMission02);
W = CH.Specs.Weight;

exper = [W.EM, W.FuelCells, W.Tank, W.Fuel, W.OEW + W.FuelCells ,W.MTOW];

err = (exper - truew)./truew.*100

% Motors		
% FuelCells	
% FuelTanks	
% FuelWeight	
% OEW
% MTOW		

