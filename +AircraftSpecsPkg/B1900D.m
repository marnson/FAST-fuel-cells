function [Aircraft] = B1900D()
%
% [Aircraft] = Example()
% written by Yi-Chih Wang
% last updated: 16 June 2024
%
% Provide an example aircraft definition for the user. Here, the Embraer 
% E190-E2 is defined from "Advanced 2030 Single Aisle Aircraft Modeling for
% the Electrified Powertrain Flight Demonstration Program", and is used for
% aircraft sizing/performance analysis.
%
% Anything with a "** REQUIRED **" is an input that the user must provde.
% All other inputs can remain NaN, and a regression function will fill in
% the missing data. The more data that can be provided in this function
% will yield a more realistically sized design.
%
% See AircraftSpecsPkg.README for a comprehensive review of building
% aircraft specification files
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
%     (1) "Piston"    = piston aircraft (not currently functional)
%     (2) "Turboprop" = turboprop
%     (3) "Turbofan"  = turbojet or turbofan
Aircraft.Specs.TLAR.Class = "Turboprop";  %done
            
% ** REQUIRED ** number of passengers
Aircraft.Specs.TLAR.MaxPax = 19;    % done

% ----------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            %
% performance parameters     %
%                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
% takeoff speed (m/s)
Aircraft.Specs.Performance.Vels.Tko = ???; % to be updated

% cruise  speed (mach)
Aircraft.Specs.Performance.Vels.Crs = ???; % to be updated

% takeoff altitude (m)
Aircraft.Specs.Performance.Alts.Tko = 0; % done

% cruise altitude (m)
Aircraft.Specs.Performance.Alts.Crs = ???; % to be updated

% ** REQUIRED ** design range (m)
Aircraft.Specs.Performance.Range = UnitConversionPkg.ConvLength(382, "naut mi", "m"); %done

% maximum rate-of-climb (m/s)
Aircraft.Specs.Performance.RCMax = ???; % to be updated

% ----------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            %
% aerodynamic parameters     %
%                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% lift-drag ratio at climb
Aircraft.Specs.Aero.L_D.Clb = ???; % to be updated

% lift-drag ratio at cruise
Aircraft.Specs.Aero.L_D.Crs = ???; % to be updated

% lift-drag ratio at descent
Aircraft.Specs.Aero.L_D.Des = ???; % to be updated

% maximum wing loading (kg/m^2)
Aircraft.Specs.Aero.W_S.SLS = 287;  % done

% ----------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            %
% weights                    %
%                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
% maximum takeoff weight (kg)
Aircraft.Specs.Weight.MTOW = 7815; %done 

% block fuel (kg)
Aircraft.Specs.Weight.Fuel = ??? % to be updated

% landing weight (kg)
Aircraft.Specs.Weight.MLW = NaN; % to be updated

% battery weight (kg)
Aircraft.Specs.Weight.Batt = NaN; % to be updated

% electric motor weight (kg)
Aircraft.Specs.Weight.EM = NaN; % to be updated

% electric generator weight (kg)
Aircraft.Specs.Weight.EG = NaN; % to be updated

% ----------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            %
% propulsion specifications  %
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
Aircraft.Specs.Propulsion.Arch.Type = "C"; % done

% aircraft thrust-weight ratio
Aircraft.Specs.Propulsion.T_W.SLS = ???; % to be updated

% total sea level static thrust (N)
Aircraft.Specs.Propulsion.Thrust.SLS = ???; % to be updated

% engine propulSive efficiency
Aircraft.Specs.Propulsion.Eta.Prop = 0.8; % to be updated

% Number of engines
Aircraft.Specs.Propulsion.NumEngines = 2; 

% get the engine
Aircraft.Specs.Propulsion.Engine = EngineModelPkg.EngineSpecsPkg.PT6A_67D;

% ----------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            %
% power specifications       %
%                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% gravimetric specific energy of combustible fuel (kWh/kg)  
Aircraft.Specs.Power.SpecEnergy.Fuel = (43.2e+6) / (3.6e+6);

% gravimetric specific energy of battery (kWh/kg)
Aircraft.Specs.Power.SpecEnergy.Batt = 0.25; % to be updated

% electric motor efficiency
Aircraft.Specs.Power.Eta.EM = 0.96; % to be updated

% electric generator efficiency
Aircraft.Specs.Power.Eta.EG = 0.96; % to be updated

% aircraft power-weight ratio (kW/kg)
Aircraft.Specs.Power.P_W.SLS = 0.239; % done 

% electric motor power-weight ratio (kW/kg)
Aircraft.Specs.Power.P_W.EM = NaN; % to be updated

% electric generator power-weight ratio (kW/kg)
Aircraft.Specs.Power.P_W.EG = NaN; % to be updated

% number of battery cells in series and parallel
Aircraft.Specs.Power.Battery.SerCells = NaN;
Aircraft.Specs.Power.Battery.ParCells = NaN;

% initial battery state-of-charge (SOC)
Aircraft.Specs.Power.Battery.BegSOC   = NaN;

% ----------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            %
% mission analysis settings  %
%                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% points in takeoff segment
Aircraft.Settings.TkoPoints = NaN;

% points in climb   segment
Aircraft.Settings.ClbPoints = NaN;

% points in cruise  segment
Aircraft.Settings.CrsPoints = NaN;

% points in descent  segment
Aircraft.Settings.DesPoints = NaN;

% maximum iterations when sizing OEW
Aircraft.Settings.OEW.MaxIter = NaN;

% convergence tolerance when sizing OEW
Aircraft.Settings.OEW.Tol = NaN;

% maximum iterations when sizing entire aircraft
Aircraft.Settings.Analysis.MaxIter = NaN;

% on design/off design analysis
% 1  = on design
% -2 = off design
Aircraft.Settings.Analysis.Type = 1;

% plot results
% 0 = no plotting
% 1 = plotting
Aircraft.Settings.Plotting = NaN;

% ----------------------------------------------------------

end
