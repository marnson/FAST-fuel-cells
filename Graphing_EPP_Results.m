%% Tunings
clear; clc; close all;


% clear; clc;
% load('EPP_Results/A320_Tuning')
% A320 = ErrorTab

clear;
load('EPP_Results/ATR_Tuning')
ATR = ErrorTab

clear; 
load('EPP_Results\CHEETA_Tuning.mat')
Cheeta = ErrorTab

clear; 
load('EPP_Results\AEA_Tuning.mat')
AEA = ErrorTab




%% Graphing of Fuel Cell A320 Trade Studies

% clear; clc; close all;
% load('EPP_Results/A320_FuelCell_Trade')
% 
% ConvE = 8.4055e+11; % J 
% ConvFuel = 19457;
% 
% FuelCost = 800; % dollars per metric ton
% ConvCost = ConvFuel/1000 * FuelCost;
% 
% ConvEmiss2024 = ConvFuel*3.66; % in kg
% 
% figure(1)
% contourf(PWGrid,EtaGrid,EnergyGrid./ConvE.*100)
% % axis([700 1200 0.65 1.5])
% ylabel('Gravimetric Tank Efficiency')
% xlabel('Weight Parameter [unknown units]')
% colorbar
% title("Energy usage relative to kerosene powered A320 in percentage")



%% Graphing of Fuel Cell ATR Trade Studies

clear; clc; close all
load('EPP_Results/ATR_FuelCell_Trade')
EtaGrid = 1./(1+EtaGrid);

ConvE2024 = 1.1236e+11; % J 
ConvMTOW2024 = 18758; % kg

ConvE2035 = ConvE2024*(1 - 0.146);
ConvMTOW2035 = ConvMTOW2024*(1 - 0.042);


ConvFuel2024 = 2.6009e+03; % kg

FuelCost = 800; % dollars per metric ton
ConvCost2024 = ConvFuel2024/1000 * FuelCost;
ConvCost2035 = ConvCost2024*(1 - 0.146);

Cost2024 = FuelGrid*10;
Cost2035 = FuelGrid*5;
Cost2050 = FuelGrid*3;

ConvEmiss2024 = ConvFuel2024*3.66; % in kg
ConvEmiss2035 = ConvEmiss2024*(1 - 0.146);

EmissionGrid2024 = EnergyGrid./1e6*0.1194;
EmissionGrid2035 = EnergyGrid./1e6*0.03553;





% figure(1)
% contourf(PWGrid,EtaGrid,EnergyGrid./ConvE.*100)
% ylabel('Gravimetric Tank Efficiency')
% xlabel('Weight Parameter [unknown units]')
% colorbar
% title("Energy usage relative to kerosene powered ATR in percentage")

figure(2)
subplot(1,2,1)
contourf(PWGrid,EtaGrid,EmissionGrid2024./ConvEmiss2024.*100,'LineStyle','none')
hold on
[C,h] = contour(PWGrid,EtaGrid,EmissionGrid2024./ConvEmiss2024.*100,[100 100],'w','LineWidth',2,'ShowText','on','LabelFormat',@ (x) repmat("Breakeven",[1,length(x)]));
clabel(C,h,'Color','w','FontName','Times','FontSize',10)
ylabel('Gravimetric Fuel Tank Efficiency','FontName','Times','FontSize',10)
xlabel('weight parameter  XXXXX','FontName','Times','FontSize',10)
colorbar
title({'W2W Carbon Emissions Relative to','Notional Turboprop Aircraft [%]'},'FontName','Times','FontSize',10)
ax = gca; 
ax.FontSize = 10;
ax.FontName = 'Times';
xticks([349.65, 600:200:1600]);
xticklabels({350, 600:200:1600});

subplot(1,2,2)
contourf(PWGrid,EtaGrid,Cost2024./ConvCost2024.*100,'LineStyle','none')
hold on
[C,h] = contour(PWGrid,EtaGrid,Cost2024./ConvCost2024.*100,[100 100],'w','LineWidth',2,'ShowText','on','LabelFormat',@ (x) repmat("Breakeven",[1,length(x)]));
clabel(C,h,'Color','w','FontName','Times','FontSize',10)
ylabel('Gravimetric Fuel Tank Efficiency','FontName','Times','FontSize',10)
xlabel('weight parameter  XXXXX','FontName','Times','FontSize',10)
colorbar
title({'Energy Cost Relative to','Notional Turboprop Aircraft [%]'},'FontName','Times','FontSize',10)
ax = gca; 
ax.FontSize = 10;
ax.FontName = 'Times';
xticks([349.65, 600:200:1600]);
xticklabels({350, 600:200:1600});



set(gcf, 'Position', get(0, 'Screensize'));
print(gcf,'EPP_Results/ATR_FuelCell_2024','-dpdf','-bestfit')

% sgtitle('2024')

% 2035 (blue hydrogen)
figure(3)
subplot(1,2,1)
contourf(PWGrid,EtaGrid,EmissionGrid2035./ConvEmiss2035.*100,'LineStyle','none')
hold on
[C,h] = contour(PWGrid,EtaGrid,EmissionGrid2035./ConvEmiss2035.*100,[100 100],'w','LineWidth',2,'ShowText','on','LabelFormat',@ (x) repmat("Breakeven",[1,length(x)]));
clabel(C,h,'Color','w','FontName','Times','FontSize',10)
ylabel('Gravimetric Fuel Tank Efficiency','FontName','Times','FontSize',10)
xlabel('weight parameter  XXXXX','FontName','Times','FontSize',10)
colorbar
title({'W2W Carbon Emissions Relative to','Advanced Turboprop Aircraft [%]'},'FontName','Times','FontSize',10)

ax = gca; 
ax.FontSize = 10;
ax.FontName = 'Times';
xticks([349.65, 600:200:1600]);
xticklabels({350, 600:200:1600});

subplot(1,2,2)
contourf(PWGrid,EtaGrid,Cost2035./ConvCost2035.*100,'LineStyle','none')
hold on
[C,h] = contour(PWGrid,EtaGrid,Cost2035./ConvCost2035.*100,[100 100],'w','LineWidth',2,'ShowText','on','LabelFormat',@ (x) repmat("Breakeven",[1,length(x)]));
clabel(C,h,'Color','w','FontName','Times','FontSize',10)
ylabel('Gravimetric Fuel Tank Efficiency','FontName','Times','FontSize',10)
xlabel('weight parameter  XXXXX','FontName','Times','FontSize',10)
colorbar
title({'Energy Cost Relative to','Advanced Turboprop Aircraft [%]'},'FontName','Times','FontSize',10)

ax = gca; 
ax.FontSize = 10;
ax.FontName = 'Times';
xticks([349.65, 600:200:1600]);
xticklabels({350, 600:200:1600});

set(gcf, 'Position', get(0, 'Screensize'));
print(gcf,'EPP_Results/ATR_FuelCell_2035','-dpdf','-bestfit')


% sgtitle('2035')


% 2050
figure(4)

contourf(PWGrid,EtaGrid,Cost2050./ConvCost2035.*100,'LineStyle','none')
hold on
[C,h] = contour(PWGrid,EtaGrid,Cost2050./ConvCost2035.*100,[100 100],'w','LineWidth',2,'ShowText','on','LabelFormat',@ (x) repmat("Breakeven",[1,length(x)]));
clabel(C,h,'Color','w','FontName','Times','FontSize',10)
ylabel('Gravimetric Fuel Tank Efficiency','FontName','Times','FontSize',10)
xlabel('weight parameter  XXXXX','FontName','Times','FontSize',10)
colorbar
title({'Energy Cost Relative to','Advanced Turboprop Aircraft [%]'},'FontName','Times','FontSize',10)

ax = gca; 
ax.FontSize = 10;
ax.FontName = 'Times';
xticks([349.65, 600:200:1600]);
xticklabels({350, 600:200:1600});

set(gcf, 'Position', get(0, 'Screensize'));
print(gcf,'EPP_Results/ATR_FuelCell_2050','-dpdf','-bestfit')


% MTOW and energy against modern baseline
figure(5)
subplot(1,2,1)
contourf(PWGrid,EtaGrid,MTOWGrid./ConvMTOW2024.*100,'LineStyle','none')
hold on
[C,h] = contour(PWGrid,EtaGrid,MTOWGrid./ConvMTOW2024.*100,[100 100],'w','LineWidth',2,'ShowText','on','LabelFormat',@ (x) repmat("Breakeven",[1,length(x)]));
clabel(C,h,'Color','w','FontName','Times','FontSize',10)
ylabel('Gravimetric Fuel Tank Efficiency','FontName','Times','FontSize',10)
xlabel('weight parameter  XXXXX','FontName','Times','FontSize',10)
colorbar
title({'MTOW Relative to','Notional Turboprop Aircraft [%]'},'FontName','Times','FontSize',10)
ax = gca; 
ax.FontSize = 10;
ax.FontName = 'Times';
xticks([349.65, 600:200:1600]);
xticklabels({350, 600:200:1600});

subplot(1,2,2)
contourf(PWGrid,EtaGrid,EnergyGrid./ConvE2024.*100,'LineStyle','none')
hold on
[C,h] = contour(PWGrid,EtaGrid,EnergyGrid./ConvE2024.*100,[100 100],'w','LineWidth',2,'ShowText','on','LabelFormat',@ (x) repmat("Breakeven",[1,length(x)]));
clabel(C,h,'Color','w','FontName','Times','FontSize',10)
ylabel('Gravimetric Fuel Tank Efficiency','FontName','Times','FontSize',10)
xlabel('weight parameter  XXXXX','FontName','Times','FontSize',10)
colorbar
title({'Total Energy Usage Relative to',' Notional Turboprop Aircraft [%]'},'FontName','Times','FontSize',10)
ax = gca; 
ax.FontSize = 10;
ax.FontName = 'Times';
xticks([349.65, 600:200:1600]);
xticklabels({350, 600:200:1600});

set(gcf, 'Position', get(0, 'Screensize'));
print(gcf,'EPP_Results/ATR_FuelCell_weights_modern','-dpdf','-bestfit')


% MTOW and energy against future baseline
figure(6)
subplot(1,2,1)
contourf(PWGrid,EtaGrid,MTOWGrid./ConvMTOW2035.*100,'LineStyle','none')
hold on
[C,h] = contour(PWGrid,EtaGrid,MTOWGrid./ConvMTOW2035.*100,[100 100],'w','LineWidth',2,'ShowText','on','LabelFormat',@ (x) repmat("Breakeven",[1,length(x)]));
clabel(C,h,'Color','w','FontName','Times','FontSize',10)
ylabel('Gravimetric Fuel Tank Efficiency','FontName','Times','FontSize',10)
xlabel('weight parameter  XXXXX','FontName','Times','FontSize',10)
colorbar
title({'MTOW Relative to','Advanced Turboprop Aircraft [%]'},'FontName','Times','FontSize',10)
ax = gca; 
ax.FontSize = 10;
ax.FontName = 'Times';
xticks([349.65, 600:200:1600]);
xticklabels({350, 600:200:1600});

subplot(1,2,2)
contourf(PWGrid,EtaGrid,EnergyGrid./ConvE2035.*100,'LineStyle','none')
hold on
[C,h] = contour(PWGrid,EtaGrid,EnergyGrid./ConvE2035.*100,[100 100],'w','LineWidth',2,'ShowText','on','LabelFormat',@ (x) repmat("Breakeven",[1,length(x)]));
clabel(C,h,'Color','w','FontName','Times','FontSize',10)
ylabel('Gravimetric Fuel Tank Efficiency','FontName','Times','FontSize',10)
xlabel('weight parameter  XXXXX','FontName','Times','FontSize',10)
colorbar
title({'Total Energy Usage Relative to','Advanced Turboprop Aircraft [%]'},'FontName','Times','FontSize',10)
ax = gca; 
ax.FontSize = 10;
ax.FontName = 'Times';
xticks([349.65, 600:200:1600]);
xticklabels({350, 600:200:1600});

set(gcf, 'Position', get(0, 'Screensize'));
print(gcf,'EPP_Results/ATR_FuelCell_weights_future','-dpdf','-bestfit')





%% Graphing of ATR Battery Trade Studies


clear; clc; close all;
load('EPP_Results/ATR_Elec_Trade')

ConvE2024 = 1.1236e+11; % J 
ConvMTOW2024 = 18758; % kg

ConvE2035 = ConvE2024*(1 - 0.146);
ConvMTOW2035 = ConvMTOW2024*(1 - 0.042);

ConvFuel2024 = 2.6009e+03; % kg

FuelCost = 800; % dollars per metric ton
ConvCost2024 = ConvFuel2024/1000 * FuelCost;



ConvEmiss2024 = ConvFuel2024*3.66; % in kg
ConvEmiss2035 = ConvEmiss2024*(1 - 0.146);

EmissionGrid2024 = EnergyGrid.*2.77778e-7    *0.460;
EmissionGrid2035 = EnergyGrid.*2.77778e-7    *0.048;

CostGrid2024 = EnergyGrid.*2.77778e-7 * 0.122;
CostGrid2035 = EnergyGrid.*2.77778e-7 * 0.107;
CostGrid2050 = EnergyGrid.*2.77778e-7 * 0.11;

% figure(1)
% contourf(eBattGrid(3:end,3:end),EtaGrid(3:end,3:end),EnergyGrid(3:end,3:end)./1.1236e+11.*100)
% ylabel('Propulsive Efficiency','FontName','Times','FontSize',10)
% xlabel('Battery Specific Energy','FontName','Times','FontSize',10)
% colorbar
% title("Energy usage relative to kerosene powered ATR in percentage")


figure(2)
subplot(1,2,1)
contourf(eBattGrid(3:end,3:end),EtaGrid(3:end,3:end),EmissionGrid2024(3:end,3:end)./ConvEmiss2024.*100,'LineStyle','none')
hold on
[C,h] = contour(eBattGrid(3:end,3:end),EtaGrid(3:end,3:end),EmissionGrid2024(3:end,3:end)./ConvEmiss2024.*100,[100 100],'w','LineWidth',2,'ShowText','on','LabelFormat',@ (x) repmat("Breakeven",[1,length(x)]));
clabel(C,h,'Color','w','FontName','Times','FontSize',10)
ylabel('Powertrain Efficiency','FontName','Times','FontSize',10)
xlabel('Battery Specific Energy [kWh/kg]','FontName','Times','FontSize',10)
colorbar
title({'W2W Carbon Emissions Relative to','Notional Turboprop Aircraft [%]'},'FontName','Times','FontSize',10)

ax = gca; 
ax.FontSize = 10;
ax.FontName = 'Times';
xticks([2.221, 2.4:0.2:4]);
xticklabels({2.21, 2.4:0.2:4});
yticks([0.533, 0.55:0.05:0.8]);
yticklabels({0.53, 0.55:0.05:0.8});

subplot(1,2,2)
contourf(eBattGrid(3:end,3:end),EtaGrid(3:end,3:end),CostGrid2024(3:end,3:end)./ConvCost2024.*100,'LineStyle','none')
hold on
[C,h] = contour(eBattGrid(3:end,3:end),EtaGrid(3:end,3:end),CostGrid2024(3:end,3:end)./ConvCost2024.*100,[100 100],'w','LineWidth',2,'ShowText','on','LabelFormat',@ (x) repmat("Breakeven",[1,length(x)]));
clabel(C,h,'Color','w','FontName','Times','FontSize',10)
ylabel('Powertrain Efficiency','FontName','Times','FontSize',10)
xlabel('Battery Specific Energy [kWh/kg]','FontName','Times','FontSize',10)
colorbar
title({'Energy Cost Relative to',' Notional Turboprop Aircraft [%]'},'FontName','Times','FontSize',10)

ax = gca; 
ax.FontSize = 10;
ax.FontName = 'Times';
xticks([2.221, 2.4:0.2:4]);
xticklabels({2.21, 2.4:0.2:4});
yticks([0.533, 0.55:0.05:0.8]);
yticklabels({0.53, 0.55:0.05:0.8});

set(gcf, 'Position', get(0, 'Screensize'));
print(gcf,'EPP_Results/ATR_Elec_2024','-dpdf','-bestfit')

% sgtitle('2024','FontName','Times','FontSize',10)

figure(3)
subplot(1,2,1)
contourf(eBattGrid(3:end,3:end),EtaGrid(3:end,3:end),EmissionGrid2035(3:end,3:end)./ConvEmiss2035.*100,'LineStyle','none')
hold on
[C,h] = contour(eBattGrid(3:end,3:end),EtaGrid(3:end,3:end),EmissionGrid2035(3:end,3:end)./ConvEmiss2035.*100,[100 100],'w','LineWidth',2,'ShowText','on','LabelFormat',@ (x) repmat("Breakeven",[1,length(x)]));
clabel(C,h,'Color','w','FontName','Times','FontSize',10)
ylabel('Powertrain Efficiency','FontName','Times','FontSize',10)
xlabel('Battery Specific Energy [kWh/kg]','FontName','Times','FontSize',10)
colorbar
title({'W2W Carbon Emissions Relative to','Advanced Turboprop Aircraft [%]'},'FontName','Times','FontSize',10)


ax = gca; 
ax.FontSize = 10;
ax.FontName = 'Times';
xticks([2.221, 2.4:0.2:4]);
xticklabels({2.21, 2.4:0.2:4});
yticks([0.533, 0.55:0.05:0.8]);
yticklabels({0.53, 0.55:0.05:0.8});

subplot(1,2,2)
contourf(eBattGrid(3:end,3:end),EtaGrid(3:end,3:end),CostGrid2035(3:end,3:end)./ConvCost2024.*100,'LineStyle','none')
hold on
[C,h] = contour(eBattGrid(3:end,3:end),EtaGrid(3:end,3:end),CostGrid2035(3:end,3:end)./ConvCost2024.*100,[100 100],'w','LineWidth',2,'ShowText','on','LabelFormat',@ (x) repmat("Breakeven",[1,length(x)]));
clabel(C,h,'Color','w','FontName','Times','FontSize',10)
ylabel('Powertrain Efficiency','FontName','Times','FontSize',10)
xlabel('Battery Specific Energy [kWh/kg]','FontName','Times','FontSize',10)
colorbar
title({'Energy Cost Relative to','Advanced Turboprop Aircraft [%]'},'FontName','Times','FontSize',10)

ax = gca; 
ax.FontSize = 10;
ax.FontName = 'Times';
xticks([2.221, 2.4:0.2:4]);
xticklabels({2.21, 2.4:0.2:4});
yticks([0.533, 0.55:0.05:0.8]);
yticklabels({0.53, 0.55:0.05:0.8});

set(gcf, 'Position', get(0, 'Screensize'));
print(gcf,'EPP_Results/ATR_Elec_2035','-dpdf','-bestfit')



% MTOW and energy against modern baseline
figure(4)
subplot(1,2,1)
contourf(eBattGrid(3:end,3:end),EtaGrid(3:end,3:end),MTOWGrid(3:end,3:end)./ConvMTOW2024.*100,'LineStyle','none')
hold on
[C,h] = contour(eBattGrid(3:end,3:end),EtaGrid(3:end,3:end),MTOWGrid(3:end,3:end)./ConvMTOW2024.*100,[100 100],'w','LineWidth',2,'ShowText','on','LabelFormat',@ (x) repmat("Breakeven",[1,length(x)]));
clabel(C,h,'Color','w','FontName','Times','FontSize',10)
ylabel('Powertrain Efficiency','FontName','Times','FontSize',10)
xlabel('Battery Specific Energy [kWh/kg]','FontName','Times','FontSize',10)
colorbar
title({'MTOW Relative to',' Notional Turboprop Aircraft [%]'},'FontName','Times','FontSize',10)
ax = gca; 
ax.FontSize = 10;
ax.FontName = 'Times';
xticks([2.221, 2.4:0.2:4]);
xticklabels({2.21, 2.4:0.2:4});
yticks([0.533, 0.55:0.05:0.8]);
yticklabels({0.53, 0.55:0.05:0.8});

subplot(1,2,2)
contourf(eBattGrid(3:end,3:end),EtaGrid(3:end,3:end),EnergyGrid(3:end,3:end)./ConvE2024.*100,'LineStyle','none')
hold on
[C,h] = contour(eBattGrid(3:end,3:end),EtaGrid(3:end,3:end),EnergyGrid(3:end,3:end)./ConvE2024.*100,[100 100],'w','LineWidth',2,'ShowText','on','LabelFormat',@ (x) repmat("Breakeven",[1,length(x)]));
clabel(C,h,'Color','w','FontName','Times','FontSize',10)
ylabel('Powertrain Efficiency','FontName','Times','FontSize',10)
xlabel('Battery Specific Energy [kWh/kg]','FontName','Times','FontSize',10)
colorbar
title({'Total Energy Usage Relative to',' Notional Turboprop Aircraft [%]'},'FontName','Times','FontSize',10)
ax = gca; 
ax.FontSize = 10;
ax.FontName = 'Times';
xticks([2.221, 2.4:0.2:4]);
xticklabels({2.21, 2.4:0.2:4});
yticks([0.533, 0.55:0.05:0.8]);
yticklabels({0.53, 0.55:0.05:0.8});

set(gcf, 'Position', get(0, 'Screensize'));
print(gcf,'EPP_Results/ATR_Elec_weights_modern','-dpdf','-bestfit')


% MTOW and energy against future baseline
figure(5)
subplot(1,2,1)
contourf(eBattGrid(3:end,3:end),EtaGrid(3:end,3:end),MTOWGrid(3:end,3:end)./ConvMTOW2035.*100,'LineStyle','none')
hold on
[C,h] = contour(eBattGrid(3:end,3:end),EtaGrid(3:end,3:end),MTOWGrid(3:end,3:end)./ConvMTOW2035.*100,[100 100],'w','LineWidth',2,'ShowText','on','LabelFormat',@ (x) repmat("Breakeven",[1,length(x)]));
clabel(C,h,'Color','w','FontName','Times','FontSize',10)
ylabel('Powertrain Efficiency','FontName','Times','FontSize',10)
xlabel('Battery Specific Energy [kWh/kg]','FontName','Times','FontSize',10)
colorbar
title({'MTOW Relative to','Advanced Turboprop Aircraft [%]'},'FontName','Times','FontSize',10)
ax = gca; 
ax.FontSize = 10;
ax.FontName = 'Times';
xticks([2.221, 2.4:0.2:4]);
xticklabels({2.21, 2.4:0.2:4});
yticks([0.533, 0.55:0.05:0.8]);
yticklabels({0.53, 0.55:0.05:0.8});

subplot(1,2,2)
contourf(eBattGrid(3:end,3:end),EtaGrid(3:end,3:end),EnergyGrid(3:end,3:end)./ConvE2035.*100,'LineStyle','none')
hold on
[C,h] = contour(eBattGrid(3:end,3:end),EtaGrid(3:end,3:end),EnergyGrid(3:end,3:end)./ConvE2035.*100,[100 100],'w','LineWidth',2,'ShowText','on','LabelFormat',@ (x) repmat("Breakeven",[1,length(x)]));
clabel(C,h,'Color','w','FontName','Times','FontSize',10)
ylabel('Powertrain Efficiency','FontName','Times','FontSize',10)
xlabel('Battery Specific Energy [kWh/kg]','FontName','Times','FontSize',10)
colorbar
title({'Total Energy Usage Relative to','Advanced Turboprop Aircraft [%]'},'FontName','Times','FontSize',10)
ax = gca; 
ax.FontSize = 10;
ax.FontName = 'Times';
xticks([2.221, 2.4:0.2:4]);
xticklabels({2.21, 2.4:0.2:4});
yticks([0.533, 0.55:0.05:0.8]);
yticklabels({0.53, 0.55:0.05:0.8});

set(gcf, 'Position', get(0, 'Screensize'));
print(gcf,'EPP_Results/ATR_Elec_weights_future','-dpdf','-bestfit')


figure(7)
contourf(eBattGrid(3:end,3:end),EtaGrid(3:end,3:end),CostGrid2050(3:end,3:end)./ConvCost2024.*100,'LineStyle','none')
hold on
[C,h] = contour(eBattGrid(3:end,3:end),EtaGrid(3:end,3:end),CostGrid2050(3:end,3:end)./ConvCost2024.*100,[100 100],'w','LineWidth',2,'ShowText','on','LabelFormat',@ (x) repmat("Breakeven",[1,length(x)]));
clabel(C,h,'Color','w','FontName','Times','FontSize',10)
ylabel('Powertrain Efficiency','FontName','Times','FontSize',10)
xlabel('Battery Specific Energy [kWh/kg]','FontName','Times','FontSize',10)
colorbar
title({'Energy Cost Relative to','Notional Turboprop Aircraft [%]'},'FontName','Times','FontSize',10)

ax = gca; 
ax.FontSize = 10;
ax.FontName = 'Times';
xticks([2.221, 2.4:0.2:4]);
xticklabels({2.21, 2.4:0.2:4});
yticks([0.533, 0.55:0.05:0.8]);
yticklabels({0.53, 0.55:0.05:0.8});

set(gcf, 'Position', get(0, 'Screensize'));
print(gcf,'EPP_Results/ATR_Elec_2050','-dpdf','-bestfit')





%% Graphing of Fuel Cell BRE Comparisons
clear; clc; close all;
load('EPP_Results/BRE_ATR_FuelCell.mat')

% 'Sized','RangeGrid','MBM_BRE','MBM_BRE_Norsv','MBM_FAST'

close all
figure(1)

subplot(1,2,1)
plot(RangeGrid./1e3,MBM_FAST)
hold on
plot(RangeGrid./1e3,MBM_BRE)
% plot(RangeGrid./1e3,MBM_BRE_Norsv)
legend('FAST','BRE','location','southeast') %,'BRE w/o Reserves')
grid on
xlabel('Range [km]')
ylabel('M_{LH_2} / M_{Total}')

ax = gca; 
ax.FontSize = 10;
ax.FontName = 'Times';

subplot(1,2,2)
plot(RangeGrid./1e3,(MBM_BRE - MBM_FAST)./MBM_FAST.*100)
hold on
% plot(RangeGrid./1e3,(MBM_BRE_Norsv - MBM_FAST)./MBM_FAST.*100)
% legend('With Reserve Mission') %,'Without Reserve Mission')
xlabel('Range [km]')
ylabel('BRE Error [%]')
grid on

ax = gca; 
ax.FontSize = 10;
ax.FontName = 'Times';

set(gcf, 'Position', get(0, 'Screensize'));
print(gcf,'EPP_Results/ATR_FuelCell_BRE','-dpdf','-bestfit')

%% Graphing of Battery BRE Comparisons
clear; clc; close all;
load('EPP_Results/BRE_ATR_Elec.mat')

% 'Sized','RangeGrid','MBM_BRE','MBM_BRE_Norsv','MBM_FAST'

close all
figure(1)

subplot(1,2,1)
plot(RangeGrid./1e3,MBM_FAST)
hold on
plot(RangeGrid./1e3,MBM_BRE)
% plot(RangeGrid./1e3,MBM_BRE_Norsv)
legend('FAST','BRE','location','southeast') %,'BRE w/o Reserves')
grid on
xlabel('Range [km]')
ylabel('M_{Batt} / M_{Total}')

ax = gca; 
ax.FontSize = 10;
ax.FontName = 'Times';

subplot(1,2,2)
plot(RangeGrid./1e3,(MBM_BRE - MBM_FAST)./MBM_FAST.*100)
hold on
% plot(RangeGrid./1e3,(MBM_BRE_Norsv - MBM_FAST)./MBM_FAST.*100)
% legend('With Reserve Mission') %,'Without Reserve Mission')
xlabel('Range [km]')
ylabel('BRE Error [%]')
grid on

ax = gca; 
ax.FontSize = 10;
ax.FontName = 'Times';

set(gcf, 'Position', get(0, 'Screensize'));
print(gcf,'EPP_Results/ATR_Elec_BRE','-dpdf','-bestfit')




%% Graphing of Battery BRE Comparisons

% load('EPP_Results/')
% load('EPP_Results/')
% load('EPP_Results/')
% load('EPP_Results/')
% load('EPP_Results/')
% load('EPP_Results/')
% load('EPP_Results/')
% load('EPP_Results/')
