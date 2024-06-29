%% Tunings



clear; clc;
load('EPP_Results/A320_Tuning')
A320 = ErrorTab

clear;
load('EPP_Results/ATR_Tuning')
ATR = ErrorTab




%% Graphing of Fuel Cell A320 Trade Studies

clear; clc; close all;
load('EPP_Results/A320_FuelCell_Trade')

ConvE = 8.4055e+11; % J 
ConvFuel = 19457;

FuelCost = 800; % dollars per metric ton
ConvCost = ConvFuel/1000 * FuelCost;

ConvEmiss2024 = ConvFuel*3.66; % in kg

figure(1)
contourf(PWGrid,EtaGrid,EnergyGrid./ConvE.*100)
% axis([700 1200 0.65 1.5])
ylabel('Gravimetric Tank Efficiency')
xlabel('Weight Parameter [unknown units]')
colorbar
title("Energy usage relative to kerosene powered A320 in percentage")

%% Graphing of Fuel Cell ATR Trade Studies
clear; clc; close all
load('EPP_Results/ATR_FuelCell_Trade')

ConvE = 1.1236e+11; % J 
ConvFuel = 2.6009e+03; % kg

FuelCost = 800; % dollars per metric ton
ConvCost = ConvFuel/1000 * FuelCost;

CostGrid2024 = 0;

ConvEmiss2024 = ConvFuel*3.66; % in kg

ConvEmiss2035 = ConvEmiss2024*(1 - 0.351);

EmissionGrid2024 = EnergyGrid./1e6*0.1194;

EmissionGrid2035 = EnergyGrid./1e6*0.03553;



figure(1)
contourf(PWGrid,EtaGrid,EnergyGrid./ConvE.*100)
ylabel('Gravimetric Tank Efficiency')
xlabel('Weight Parameter [unknown units]')
colorbar
title("Energy usage relative to kerosene powered ATR in percentage")


figure(2)
subplot(1,2,1)
contourf(PWGrid,EtaGrid,EmissionGrid2024./ConvEmiss2024.*100)
ylabel('Gravimetric Tank Efficiency')
xlabel('Weight Parameter [unknown units]')
colorbar


subplot(1,2,2)
% contourf(PWGrid,EtaGrid,CostGrid2024./ConvCost.*100)
ylabel('Gravimetric Tank Efficiency')
xlabel('Weight Parameter [unknown units]')
colorbar

sgtitle("2024")

figure(3)
contourf(PWGrid,EtaGrid,EmissionGrid2035./ConvEmiss2035.*100)
ylabel('Gravimetric Tank Efficiency')
xlabel('Weight Parameter [unknown units]')
colorbar
title("Energy usage relative to kerosene powered ATR in percentage")




%% Graphing of Battery Trade Studies


clear; clc; close all;
load('EPP_Results/A320_Elec_Trade')

contourf(eBattGrid,EtaGrid,EnergyGrid./8.4055e+11.*100)
ylabel('Gravimetric Tank Efficiency')
xlabel('Weight Parameter [unknown units]')
colorbar
title("Energy usage relative to kerosene powered A320 in percentage")


%% Graphing of Fuel Cell BRE Comparisons

%% Graphing of Battery BRE Comparisons
load('EPP_Results/')
load('EPP_Results/')
load('EPP_Results/')
load('EPP_Results/')
load('EPP_Results/')
load('EPP_Results/')
load('EPP_Results/')
load('EPP_Results/')
load('EPP_Results/')
