function [Aircraft] = ATR42_FuelCell()
%
% [Aircraft] = ATR42()
% originally written by ???
% modified by Paul Mokotoff, prmoko@umich.edu
% last updated: 28 mar 2024
%
% Define the ATR42 from "System Analysis and Design Space Exploration of
% Regional Aircraft with Electrified Powertrains" for sizing/performance
% analysis.
%
% INPUTS:
%     none
%
% OUTPUTS:
%     Aircraft - an aircraft structure to be used for analysis.
%                size/type/units: 1-by-1 / struct / []
%


%% INPUT VALUES %%
%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            %
% top-level aircraft         %
% requirements               %
%                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% expected entry-into-service year
Aircraft.Specs.TLAR.EIS = NaN;

% ** REQUIRED ** aircraft class, either:
%     (1) "Piston"    = piston aircraft
%     (2) "Turboprop" = turboprop
%     (3) "Turbofan"  = turbojet or turbofan
Aircraft.Specs.TLAR.Class = "Turboprop";
            
% ** REQUIRED **: number of passengers
Aircraft.Specs.TLAR.MaxPax = 48;

% ----------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            %
% performance parameters     %
%                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% takeoff speed (m/s)
Aircraft.Specs.Performance.Vels.Tko = NaN;

% cruise  speed (mach)
Aircraft.Specs.Performance.Vels.Crs = 0.4;

% takeoff altitude (m)
Aircraft.Specs.Performance.Alts.Tko = NaN;

% cruise altitude (m)
Aircraft.Specs.Performance.Alts.Crs = UnitConversionPkg.ConvLength(25000, "ft", "m");

% ** REQUIRED **: design range (m)
Aircraft.Specs.Performance.Range = 1326e3;

% maximum rate-of-climb (m/s)
Aircraft.Specs.Performance.RCMax = UnitConversionPkg.ConvVel(500/60, "ft/s", "m/s");

% ----------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            %
% aerodynamic parameters     %
%                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% lift-drag ratio at climb
Aircraft.Specs.Aero.L_D.Clb = 10;

% lift-drag ratio at cruise
Aircraft.Specs.Aero.L_D.Crs = 12;

% lift-drag ratio at descent
Aircraft.Specs.Aero.L_D.Des = NaN;

% maximum wing loading (kg/m^2)
Aircraft.Specs.Aero.W_S.SLS = 342;

% ----------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            %
% weights                    %
%                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
% maximum takeoff weight (kg)
Aircraft.Specs.Weight.MTOW = 18600;

% block fuel (kg)
Aircraft.Specs.Weight.Fuel = 4500;

% landing weight (kg)
Aircraft.Specs.Weight.MLW = NaN;

% battery weight (kg)
Aircraft.Specs.Weight.Batt = NaN;

% electric motor weight (kg)
Aircraft.Specs.Weight.EM = NaN;

% electric generator weight (kg)
Aircraft.Specs.Weight.EG = NaN;

% ----------------------------------------------------------

% ** REQUIRED ** propulsion system architecture, either:
%     (1) "C"   = conventional
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
Aircraft.Specs.Propulsion.Eta.TSPS  = [0.77, 1, 1, 1; 1, 0.77, 1, 1];

% power -power  source efficiency
Aircraft.Specs.Propulsion.Eta.PSPS  = ones(4);

% power -energy source efficiency
Aircraft.Specs.Propulsion.Eta.PSES  = ones(4,1);

% energy source type (1 = fuel, 0 = battery)
Aircraft.Specs.Propulsion.PropArch.ESType = [1];

% power source type (1 = engine, 0 = electric motor)
Aircraft.Specs.Propulsion.PropArch.PSType = [0, 0, 2, 2];

Aircraft.Specs.Propulsion.FuelCell = FuelCellPkg.FuelCellSpecsPkg.Example2050;


Aircraft.Specs.Weight.WairfCF = 1.05;

Aircraft.Specs.Propulsion.FC_Oversize = 0.88;

Aircraft.Specs.Propulsion.MDotCF = 1.36;

Aircraft.Settings.Offtake = 2;

Aircraft.Specs.Weight.EtaTank = 0.65;
% ----------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            %
% power specifications       %
%                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% gravimetric specific energy of combustible fuel (kWh/kg)  
Aircraft.Specs.Power.SpecEnergy.Fuel = 33.333;

% gravimetric specific energy of battery (kWh/kg)
Aircraft.Specs.Power.SpecEnergy.Batt = 0.35;

% electric motor efficiency
Aircraft.Specs.Power.Eta.EM = 0.96;

% electric generator efficiency
Aircraft.Specs.Power.Eta.EG = 0.96;

% aircraft power-weight ratio (kW/kg)
Aircraft.Specs.Power.P_W.SLS = 0.1731;

% electric motor power-weight ratio (kW/kg)
Aircraft.Specs.Power.P_W.EM = NaN;

% electric generator power-weight ratio (kW/kg)
Aircraft.Specs.Power.P_W.EG = NaN;

% battery cell configuration and initial SOC
Aircraft.Specs.Power.Battery.SerCells = NaN;
Aircraft.Specs.Power.Battery.ParCells = NaN;
Aircraft.Specs.Power.Battery.BegSOC   = NaN;

% ----------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            %
% mission analysis           %
% properties                 %
%                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% on design/off design analysis
% +1 = on design
% -1 = off design
Aircraft.Settings.Analysis.Type = +1;

% plot results or not
% 0 = no plotting
% 1 =    plotting
Aircraft.Settings.Plotting = 1;

% ----------------------------------------------------------

end