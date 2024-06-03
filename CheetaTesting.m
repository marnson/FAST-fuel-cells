%% Validating cheeta

clear; clc; close all;
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

[
"Motors"
"FC"
"Tanks"
"Fuel"
"OEW"
"MTOW"
]'

% Motors		
% FuelCells	
% FuelTanks	
% FuelWeight	
% OEW
% MTOW		



%% Validating AEA
clear; clc; close all;

Specs = AircraftSpecsPkg.AEA;

%AE = Main(Specs,@MissionProfilesPkg.AEAProfile);
AE = Main(Specs,@MissionProfilesPkg.NotionalMission03);

W = AE.Specs.Weight;

En = AE.Mission.History.SI.Energy.E_ES(end);

EP = En/W.Payload/AE.Specs.Performance.Range/9.81;

En = En/3.6e9;

trueparam = [109.5e3,36e3,28.8,0.649];
exper =[W.MTOW,W.Batt, En,EP]
err = (exper - trueparam)./trueparam.*100

%% Running Trade study for the a320 fuel cell

%% Running Trade study for the a320 battery

%% Running Trade study for the atr fuel cell

UnitConversionPkg.ConvLength(800*3600 * 0.493 /9.81 * 18.6 * 0.35,'m','naut mi')


