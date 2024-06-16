%% 1.A) ATR conventional Tuning
clc; clear; close all;

ATR = Main(AircraftSpecsPkg.ATR42,@MissionProfilesPkg.ATR42_600);

% ATR = Main(AircraftSpecsPkg.ATR42,@MissionProfilesPkg.NotionalMission00);


% Error
actuals = [18600,11750, 577, 786, 1019];
W = ATR.Specs.Weight;
FAST_Model = [W.MTOW, W.OEW];



%t1 = MissionHistTable(ATR);

%writetimetable(t1,fullfile("+AircraftModelingPkg","+ATR42Modeling", "atr42sizingtable.xlsx"),'WriteVariableNames',true)
% 
% 
ATR.Settings.Analysis.Type = -2;
ATR.Specs.Performance.Range = UnitConversionPkg.ConvLength(200,'naut mi','m');
ATR.Specs.Performance.Vels.Crs = 0.5;
tempac = Main(ATR,@MissionProfilesPkg.NotionalMission00);
FAST_Model = [FAST_Model, tempac.Specs.Weight.Fuel];


ATR.Specs.Performance.Range = UnitConversionPkg.ConvLength(300,'naut mi','m');
tempac = Main(ATR,@MissionProfilesPkg.NotionalMission00);
FAST_Model = [FAST_Model, tempac.Specs.Weight.Fuel];


ATR.Specs.Performance.Range = UnitConversionPkg.ConvLength(400,'naut mi','m');
tempac = Main(ATR,@MissionProfilesPkg.NotionalMission00);
FAST_Model = [FAST_Model, tempac.Specs.Weight.Fuel];

err = (FAST_Model - actuals)./actuals.*100;

Weight = ["MTOW","OEW","200 nmi","300 nmi","400 nmi"]';

ErrorTab = table(Weight, actuals', FAST_Model', err');
ErrorTab.Properties.VariableNames(2) = "Literature";
ErrorTab.Properties.VariableNames(3) = "FAST Model";
ErrorTab.Properties.VariableNames(4) = "Error (%)";


save('EPP_Results/ATR_Tuning.mat','ErrorTab')



%% 1.B) A320 Conventional Tuning

clc; clear; close all;

A320 = Main(AircraftSpecsPkg.A320Neo,@MissionProfilesPkg.A320);

% Error
actuals = [79000,19051,42600, 2990*2];
W = A320.Specs.Weight;
FAST_Model = [W.MTOW, W.Fuel, W.OEW, W.Engines];

err = (FAST_Model - actuals)./actuals.*100;


Weight = ["MTOW","Fuel","OEW","Engines"]';

ErrorTab = table(Weight, actuals', FAST_Model', err');
ErrorTab.Properties.VariableNames(2) = "Literature";
ErrorTab.Properties.VariableNames(3) = "FAST Model";
ErrorTab.Properties.VariableNames(4) = "Error (%)";


save('EPP_Results/A320_Tuning.mat','ErrorTab')

%% 1.C) B1900 Conventional Tuning








%% 1.D) CHEETA Fuel Cell Baseline

clear; clc; close all;
CHEETA = UnitConversionPkg.ConvMass([1847.522594,15715.22337,10241.60151,15756.31001,129852.40 ,180608.7079, 129852.40 - 15715.22337],'lbm','kg');


CH = Main(AircraftSpecsPkg.CHEETA,@MissionProfilesPkg.NotionalMission02);
W = CH.Specs.Weight;

FAST_Model = [W.EM, W.FuelCells, W.Tank, W.Fuel, W.MTOW - W.Payload - W.Fuel ,W.MTOW,W.Airframe];

ErrorPercent = (FAST_Model - CHEETA)./CHEETA.*100;

Weight = ["Motors","FC","Tanks","Fuel","OEW","MTOW","Airframe"]';

ErrorTab = table(Weight, CHEETA', FAST_Model', ErrorPercent');
ErrorTab.Properties.VariableNames(2) = "CHEETA";
ErrorTab.Properties.VariableNames(3) = "FAST Model";
ErrorTab.Properties.VariableNames(4) = "Error (%)";


ErrorTab




%% 1.E) AEA Full Electric Baseline
clear; clc; close all;

Specs = AircraftSpecsPkg.AEA;

% AE = Main(Specs,@MissionProfilesPkg.AEAProfile);
AE = Main(Specs,@MissionProfilesPkg.NotionalMission03);

W = AE.Specs.Weight;

En = AE.Mission.History.SI.Energy.E_ES(end);

EP = En/W.Payload/AE.Specs.Performance.Range/9.81;

En = En/3.6e9;

trueparam = [109.5e3,36e3,28.8,0.649];
FAST_Model =[W.MTOW,W.Batt, En,EP];
err = (FAST_Model - trueparam)./trueparam.*100;



Params = ["MTOW","Battery Weight","Total Energy","Normalized Energy"]';

ErrorTab = table(Params, trueparam', FAST_Model', err');
ErrorTab.Properties.VariableNames(2) = "AEA";
ErrorTab.Properties.VariableNames(3) = "FAST Model";
ErrorTab.Properties.VariableNames(4) = "Error (%)";


ErrorTab




%% 2.A) Running Trade study for the A320 fuel cell
clear; clc; close all;

% load specifications
ACSpecs = AircraftSpecsPkg.A320_FuelCell;
ACSpecs.Settings.Plotting = 0;


% create grids
% FC is power to weight and eta tank
% Electric is propulsive efficiency and ebatt
N = 3;

PW = 363*2.2/1.142.*linspace(0.7,1.5,N);
EtaTank = linspace(0.65,1.5,N);

[PWGrid,EtaGrid] = meshgrid(PW,EtaTank);

% Inside the loop

for ii = 1:N
    for jj = 1:N
        ACSpecs.Specs.Propulsion.FuelCell.weight = PWGrid(ii,jj);
        ACSpecs.Specs.Weight.EtaTank = EtaGrid(ii,jj);
        FuelCellPkg.FC_init(ACSpecs.Specs.Propulsion.FuelCell)
        SizedAC(ii,jj) = Main(ACSpecs,@MissionProfilesPkg.A320);
        EnergyGrid(ii,jj) = SizedAC(ii,jj).Mission.History.SI.Energy.E_ES(end);
    end
end


close all
contourf(PWGrid,EtaGrid,EnergyGrid)

save('EPP_Results/A320_FuelCell_Trade.mat','PWGrid','EtaGrid','EnergyGrid','SizedAC')



%% 2.B) Running Trade study for the A320 battery
clear; clc; close all;


% create grids
% FC is power to weight and eta tank
% Electric is propulsive efficiency and ebatt
N = 3;

ebatt = linspace(2,5,N);
etaprop = linspace(0.5,0.8,N);

[eBattGrid,EtaGrid] = meshgrid(ebatt,etaprop);

% Inside the loop

for ii = 1:N
    for jj = 1:N
        ACSpecs = AircraftSpecsPkg.A320_Elec(EtaGrid(ii,jj));
        ACSpecs.Settings.Plotting = 0;
        ACSpecs.Specs.Power.SpecEnergy.Batt = eBattGrid(ii,jj);
        SizedAC(ii,jj) = Main(ACSpecs,@MissionProfilesPkg.A320);
        EnergyGrid(ii,jj) = SizedAC(ii,jj).Mission.History.SI.Energy.E_ES(end);
    end
end


close all
contourf(eBattGrid,EtaGrid,EnergyGrid)

save('EPP_Results/A320_Elec_Trade.mat','eBattGrid','EtaGrid','EnergyGrid','SizedAC')





%% 2.C) Running Trade study for the ATR fuel cell
clear; clc; close all;

%% 2.D) Running Trady Study for ATR Battery
clear; clc; close all;

%% 2.E) Running Trade study for the B1900 fuel cell
clear; clc; close all;

%% 2.F) Running Trady Study for B1900 Battery
clear; clc; close all;


%% 3.A) BRE Comparison A320 Fuel Cell
clear; clc; close all;

clear; clc; close all;

EtaProp = 0.8;

Specs = AircraftSpecsPkg.CHEETA();
Mission = @ MissionProfilesPkg.NotionalMission02;

N = 15;
R_Nominal = Specs.Specs.Performance.Range;
RangeGrid = linspace(0.3*R_Nominal,R_Nominal*2,N);

LD = Specs.Specs.Aero.L_D.Crs;
eFuel = 33.33*3.6e6;

MBM_FAST = zeros(1,N);
MBM_BRE  = zeros(1,N);
MBM_BRE_Norsv  = zeros(1,N);

for ii = 1:N
    R = RangeGrid(ii);
    Specs.Specs.Performance.Range = R;
    Sized(ii) = Main(Specs,Mission);
    MBM_FAST(ii) = Sized(ii).Specs.Weight.Fuel/Sized(ii).Specs.Weight.MTOW;
    
    MBM_BRE_Norsv(ii) = 1 - exp(-R/eFuel*9.81/EtaProp/LD);
    R = R + UnitConversionPkg.ConvLength(200,'naut mi', 'm') + 30*60*150;
    MBM_BRE(ii) = 1 - exp(-R/eFuel*9.81/EtaProp/LD);
   
end

close all;
figure(1)

subplot(1,2,1)
plot(RangeGrid./1e3,MBM_FAST)
hold on
plot(RangeGrid./1e3,MBM_BRE)
plot(RangeGrid./1e3,MBM_BRE_Norsv)
legend('FAST','BRE','BRE w/o Reserves')
grid on
xlabel('Range [km]')
ylabel('M_{LH_2} / M_{Total}')

subplot(1,2,2)
plot(RangeGrid./1e3,(MBM_BRE - MBM_FAST)./MBM_FAST.*100)
hold on
plot(RangeGrid./1e3,(MBM_BRE_Norsv - MBM_FAST)./MBM_FAST.*100)
legend('With Reserve Mission','Without Reserve Mission')
xlabel('Range [km]')
ylabel('BRE Error [%]')
grid on


save('EPP_Results/BRE_A320_FuelCell.mat','Sized','RangeGrid','MBM_BRE','MBM_BRE_Norsv','MBM_FAST')


%% 3.B) BRE Comparison A320 Battery
clear; clc; close all;

EtaProp = 0.8;

Specs = AircraftSpecsPkg.A320_Elec(EtaProp);
Specs.Specs.Power.SpecEnergy.Batt = 3;
Mission = @ MissionProfilesPkg.A320;

N = 15;
R_Nominal = Specs.Specs.Performance.Range;
RangeGrid = linspace(0.3*R_Nominal,R_Nominal*2,N);

LD = Specs.Specs.Aero.L_D.Crs;
eBatt = Specs.Specs.Power.SpecEnergy.Batt*3.6e6;


MBM_FAST = zeros(1,N);
MBM_BRE  = zeros(1,N);
MBM_BRE_Norsv  = zeros(1,N);

for ii = 1:N
    R = RangeGrid(ii);
    Specs.Specs.Performance.Range = R;
    Sized(ii) = Main(Specs,Mission);
    MBM_FAST(ii) = Sized(ii).Specs.Weight.Batt/Sized(ii).Specs.Weight.MTOW;
    
    MBM_BRE_Norsv(ii) = R/eBatt*9.81/EtaProp/LD;
    R = R + UnitConversionPkg.ConvLength(200,'naut mi', 'm') + 30*60*150;
    MBM_BRE(ii) = R/eBatt*9.81/EtaProp/LD;
   
end

close all;
figure(1)

subplot(1,2,1)
plot(RangeGrid./1e3,MBM_FAST)
hold on
plot(RangeGrid./1e3,MBM_BRE)
plot(RangeGrid./1e3,MBM_BRE_Norsv)
legend('FAST','BRE','BRE w/o Reserves')
grid on
xlabel('Range [km]')
ylabel('M_{Batt} / M_{Total}')

subplot(1,2,2)
plot(RangeGrid./1e3,(MBM_BRE - MBM_FAST)./MBM_FAST.*100)
hold on
plot(RangeGrid./1e3,(MBM_BRE_Norsv - MBM_FAST)./MBM_FAST.*100)
legend('With Reserve Mission','Without Reserve Mission')
xlabel('Range [km]')
ylabel('BRE Error [%]')
grid on

save('EPP_Results/BRE_A320_Elec.mat','Sized','RangeGrid','MBM_BRE','MBM_BRE_Norsv','MBM_FAST')

%Main(Specs,Mission)

%% 3.C) BRE Comparison ATR Fuel Cell
clear; clc; close all;

%% 3.D) BRE Comparison ATR Battery
clear; clc; close all;



%% 4.A) Error Testing using fake AEA trade study

clc; clear; close all;

% N should be like 20 or 30 in a real case
N = 4;

% set 1d grids
etas = linspace(0.5,0.8,N);
ebatts = linspace(0.5,2,N);

% meshgrid them
[EtaGrid2,eBattGrid2] = meshgrid(etas,ebatts);

% reshape input grids
EtaGrid1 = reshape(EtaGrid2,[N^2 1]);
eBattGrid1 = reshape(eBattGrid2,[N^2 1]);

% initialize output grids
FuelGrid1   = zeros(N^2,1);
EnergyGrid1 = zeros(N^2,1);


SpecFile = @ (x) AircraftSpecsPkg.AEA(x);
MissionFile = @ MissionProfilesPkg.AEAProfile;


% make sure this loop runs in parallel in a real case
for ii = 1:N^2
    [FuelGrid1(ii), EnergyGrid1(ii)] = RunElecAircraft(SpecFile,MissionFile,EtaGrid1(ii),eBattGrid1(ii));
end

% Reshape output grids
FuelGrid2 = reshape(FuelGrid1,[N N]);
EnergyGrid2 = reshape(EnergyGrid1,[N N]);

% Save Results
save('EPP_Results/AEATests.mat','EtaGrid2','eBattGrid2','FuelGrid2','EnergyGrid2')

% example plots
contourf(EtaGrid2,eBattGrid2,EnergyGrid2)




%% Parallel functions

% Electric Aircraft
function [fuelburn, energy] = RunElecAircraft(ACSpecs,Mission,EtaPropulsive,eBatt)

Aircraft = ACSpecs(EtaPropulsive);
Aircraft.Specs.Power.SpecEnergy.Batt = eBatt;

Sized = Main(Aircraft,Mission);

fuelburn = Sized.Specs.Weight.Fuel;

energy = Sized.Mission.History.SI.Energy.E_ES(end);

end

% Fuel Cell Powered Aircraft
function [fuelburn, energy] = RunFCAircraft(ACSpecs,Mission,EtaTank,SpecP)

Aircraft = ACSpecs;
Aircraft.Specs.Weight.EtaTank = EtaTank;
Aircraft.Specs.ADD = SpecP;

Sized = Main(Aircraft,Mission);

fuelburn = Sized.Specs.Weight.Fuel;

energy = Sized.Mission.History.SI.Energy.E_ES(end);

end