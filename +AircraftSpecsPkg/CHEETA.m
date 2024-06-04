function [Aircraft] = CHEETA()
%
% [Aircraft] = CHEETA()
% written by Max Arnson, marnson@umich.edu
% last updated: 14 may 2024
% 
%
% all required inputs contain "** required **" before the description of
% the parameter to be specified. all other parameters may remain as NaN,
% and they will be filled in by a statistical regression. for improved
% accuracy, it is suggested to provide as many parameters as possible.
%
% inputs : none     
% outputs: Aircraft - aircraft data structure to be used for analysis.
%


%% TOP-LEVEL AIRCRAFT REQUIREMENTS %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% expected entry-into-service year
Aircraft.Specs.TLAR.EIS = 2016;

% ** required **
% aircraft class, can be either:
%     'Piston'    = piston engine
%     'Turboprop' = turboprop engine
%     'Turbofan'  = turbojet or turbofan engine
Aircraft.Specs.TLAR.Class = 'Turbofan';

% ** required **
% approximate number of passengers
Aircraft.Specs.TLAR.MaxPax = UnitConversionPkg.ConvMass(35000,'lbm','kg')/95;
 

%% VEHICLE PERFORMANCE %%
%%%%%%%%%%%%%%%%%%%%%%%%%

% takeoff speed (kts)
Aircraft.Specs.Performance.Vels.Tko = UnitConversionPkg.ConvVel(135,'kts','m/s');

% cruise speed (kts)
Aircraft.Specs.Performance.Vels.Crs = 0.78;

% specified speed type, either:
%     'EAS' = equivalent airspeed
%     'TAS' = true       airspeed
Aircraft.Specs.Performance.Vels.Type = 'TAS'; %ignore this

% takeoff altitude (m)
Aircraft.Specs.Performance.Alts.Tko =     0;

% cruise altitude (m)
Aircraft.Specs.Performance.Alts.Crs = UnitConversionPkg.ConvLength(37000,'ft','m');

% ** required **
% design range (m)
Aircraft.Specs.Performance.Range = UnitConversionPkg.ConvLength(2935,'naut mi','m');

% maximum rate of climb (m/s), assumed 2,250 ft/min
Aircraft.Specs.Performance.RCMax = UnitConversionPkg.ConvLength(500/60,'ft','m');


%% AERODYNAMICS %%
%%%%%%%%%%%%%%%%%%


% lift-drag ratio during climb 
Aircraft.Specs.Aero.L_D.Clb = 16;

% lift-drag ratio during cruise 
% this changes during the flight as the heat exchanger adds additional drag
% according to elias's model
Aircraft.Specs.Aero.L_D.Crs = 18;

% assume same lift-drag ratio during climb and descent
Aircraft.Specs.Aero.L_D.Des = Aircraft.Specs.Aero.L_D.Clb;

% wing loading (kg / m^2)
Aircraft.Specs.Aero.W_S.SLS = UnitConversionPkg.ConvMass(190480,'lbm','kg')/(UnitConversionPkg.ConvLength(1,'ft','m')^2*1840);


%% WEIGHTS %%
%%%%%%%%%%%%%

% maximum takeoff weight (kg)
Aircraft.Specs.Weight.MTOW = 79000;

% electric generator weight (kg)
Aircraft.Specs.Weight.EG = NaN;

% electric motor weight (kg)
Aircraft.Specs.Weight.EM = NaN;

% block fuel weight, initial guess (kg)
Aircraft.Specs.Weight.Fuel = 19000;

% battery weight (kg), leave NaN for propulsion systems without batteries
Aircraft.Specs.Weight.Batt = NaN;

% Airframe weight calibration factor
Aircraft.Specs.Weight.WairfCF = 1.03;

% Gravimetric efficiency of h2 tank
Aircraft.Specs.Weight.EtaTank = 0.65;

%% PROPULSION %%
%%%%%%%%%%%%%%%%

% ----------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            %
% propulsion architecture    %
%                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ** REQUIRED ** propulsion system architecture, either:
%     (1) "C"  = conventional
%     (2) "E"   = fully electric
%     (3) "TE"  = fully turboelectric
%     (4) "PE"  = partially turboelectric
%     (5) "PHE" = parallel hybrid electric
%     (6) "SHE" = series hybrid electric
%     (7) "O"   = other architecture (specified by the user)
Aircraft.Specs.Propulsion.Arch.Type = "O";

% thrust-power source matrix
Aircraft.Specs.Propulsion.PropArch.TSPS = ...
    [1 0 0 0
     0 1 0 0];

% power-power source matrix
Aircraft.Specs.Propulsion.PropArch.PSPS = ...
    [1 0 1 0
     0 1 0 1
     0 0 1 0
     0 0 0 1];

% power-energy source matrix
Aircraft.Specs.Propulsion.PropArch.PSES = ...
    [0; 0; 1; 1];

% thrust      source operation
Aircraft.Specs.Propulsion.Oper.TS   = @() [0.5, 0.5];

% thrust-power source operation
Aircraft.Specs.Propulsion.Oper.TSPS = @() Aircraft.Specs.Propulsion.PropArch.TSPS;

% power-power  source operation
Aircraft.Specs.Propulsion.Oper.PSPS = @() Aircraft.Specs.Propulsion.PropArch.PSPS;

% power-energy source operation
Aircraft.Specs.Propulsion.Oper.PSES = @() Aircraft.Specs.Propulsion.PropArch.PSES;

% thrust-power  source efficiency
% NOTICE that the efficiency between fans and thrust production is 90%
Aircraft.Specs.Propulsion.Eta.TSPS  =  [0.9, 1, 1, 1; 1, 0.9, 1, 1];

% power -power  source efficiency
Aircraft.Specs.Propulsion.Eta.PSPS  = ones(4);

% power -energy source efficiency
Aircraft.Specs.Propulsion.Eta.PSES  = ones(4,1);

% energy source type (1 = fuel, 0 = battery)
Aircraft.Specs.Propulsion.PropArch.ESType = [1];

% power source type (1 = engine, 0 = electric motor)
Aircraft.Specs.Propulsion.PropArch.PSType = [0, 0, 2, 2];

% ----------------------------------------------------------

% get the engine
Aircraft.Specs.Propulsion.Engine = NaN;

% number of engines
Aircraft.Specs.Propulsion.NumEngines = 0;

% thrust-weight ratio (if a turbojet/turbofan)
Aircraft.Specs.Propulsion.T_W.SLS = 2.37e5/(73500*9.81)*1.09;

% total sea-level static thrust available (N)
Aircraft.Specs.Propulsion.Thrust.SLS = NaN;

% engine propulsive efficiency
Aircraft.Specs.Propulsion.Eta.Prop = NaN;

% Fuel cell specification file
Aircraft.Specs.Propulsion.FuelCell = FuelCellPkg.FuelCellSpecsPkg.Example2050;

% Calibration factor on fuel cell hydrogen consumption
Aircraft.Specs.Propulsion.MDotCF = 1.58;

% oversize factor on power at the design point for the fuel cell system
Aircraft.Specs.Propulsion.FC_Oversize = 1.1;


%% POWER %%
%%%%%%%%%%%

% gravimetric specific energy of combustible fuel (kWh/kg)
Aircraft.Specs.Power.SpecEnergy.Fuel = 33.3333; % LH2

% gravimetric specific energy of battery (kWh/kg), not used here
Aircraft.Specs.Power.SpecEnergy.Batt = NaN;

% electric motor and generator efficiencies, not used here just in HEA one
Aircraft.Specs.Power.Eta.EM = NaN;
Aircraft.Specs.Power.Eta.EG = NaN;

% power-weight ratio for the aircraft (kW/kg, if a turboprop)
Aircraft.Specs.Power.P_W.SLS = NaN;

% power-weight ratio for the electric motor and generator (kW/kg)
% leave as NaN if an electric motor or generator isn't in the powertrain
Aircraft.Specs.Power.P_W.EM = 26;
Aircraft.Specs.Power.P_W.EG = NaN;

% thrust splits (thrust / total thrust)
Aircraft.Specs.Power.LamTS.Tko = 0;
Aircraft.Specs.Power.LamTS.Clb = 0;
Aircraft.Specs.Power.LamTS.Crs = 0;
Aircraft.Specs.Power.LamTS.Des = 0;
Aircraft.Specs.Power.LamTS.Lnd = 0;
Aircraft.Specs.Power.LamTS.SLS = 0;

% power splits between power/thrust sources (electric power / total power)
Aircraft.Specs.Power.LamTSPS.Tko = 0;
Aircraft.Specs.Power.LamTSPS.Clb = 0;
Aircraft.Specs.Power.LamTSPS.Crs = 0;
Aircraft.Specs.Power.LamTSPS.Des = 0;
Aircraft.Specs.Power.LamTSPS.Lnd = 0;
Aircraft.Specs.Power.LamTSPS.SLS = 0;

% power splits between power/power sources (electric power / total power)
Aircraft.Specs.Power.LamPSPS.Tko = 0;
Aircraft.Specs.Power.LamPSPS.Clb = 0;
Aircraft.Specs.Power.LamPSPS.Crs = 0;
Aircraft.Specs.Power.LamPSPS.Des = 0;
Aircraft.Specs.Power.LamPSPS.Lnd = 0;
Aircraft.Specs.Power.LamPSPS.SLS = 0;

% power splits between energy/power sources (electric power / total power)
Aircraft.Specs.Power.LamPSES.Tko = 0;
Aircraft.Specs.Power.LamPSES.Clb = 0;
Aircraft.Specs.Power.LamPSES.Crs = 0;
Aircraft.Specs.Power.LamPSES.Des = 0;
Aircraft.Specs.Power.LamPSES.Lnd = 0;
Aircraft.Specs.Power.LamPSES.SLS = 0;

% battery cells in series and parallel 
Aircraft.Specs.Power.Battery.ParCells = NaN;
Aircraft.Specs.Power.Battery.SerCells = NaN;

% initial battery SOC
Aircraft.Specs.Power.Battery.BegSOC = NaN;


%% SETTINGS (LEAVE AS NaN FOR DEFAULTS) %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% number of control points in each segment
Aircraft.Settings.TkoPoints = NaN;
Aircraft.Settings.ClbPoints = NaN;
Aircraft.Settings.CrsPoints = NaN;
Aircraft.Settings.DesPoints = NaN;

% maximum number of iterations during oew estimation
Aircraft.Settings.OEW.MaxIter = 50;

% oew relative tolerance for convergence
Aircraft.Settings.OEW.Tol = 0.001;

% maximum number of iterations during aircraft sizing
Aircraft.Settings.Analysis.MaxIter = 50;

% analysis type, either:
%     +1 for on -design mode (aircraft performance and sizing)
%     -1 for off-design mode (aircraft performance           )
Aircraft.Settings.Analysis.Type = +1;

% plotting, either:
%     1 for plotting on
%     0 for plotting off
Aircraft.Settings.Plotting = 1;

% ignore this
Aircraft.Settings.Table = 0;

% ignore this
Aircraft.Settings.VisualizeAircraft = 0;

% this tells the code to add additional power for the ECS etc. it uses the
% models in the draft of the paper in the electrified subsystems section
Aircraft.Settings.Offtake = 2;
% ----------------------------------------------------------
end

