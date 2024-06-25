%% Tunings



clear; clc;
load('EPP_Results/A320_Tuning')
A320 = ErrorTab

clear;
load('EPP_Results/ATR_Tuning')
ATR = ErrorTab

%% Graphing of Fuel Cell Trade Studies

clear; clc; close all;
load('EPP_Results/A320_FuelCell_Trade')

contourf(PWGrid,EtaGrid,EnergyGrid./8.4055e+11.*100)
ylabel('Gravimetric Tank Efficiency')
xlabel('Weight Parameter [unknown units]')
colorbar
title("Energy usage relative to kerosene powered A320 in percentage")

% load('EPP_Results/')

%% Graphing of Battery Trade Studies

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
