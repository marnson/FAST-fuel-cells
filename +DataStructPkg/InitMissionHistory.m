function [Aircraft] = InitMissionHistory(Aircraft)
%
% [Aircraft] = InitMissionHistory(Aircraft)
% written by Paul Mokotoff, prmoko@umich.edu
% last updated: 29 mar 2024
%
% Initialize all arrays to zeros in the mission history for both SI and
% English units (although only SI units are currently used).
%
% INPUTS:
%     Aircraft - aircraft structure with non-existant mission history.
%                size/type/units: 1-by-1 / struct / []
%
% OUTPUTS:
%     Aircraft - aircraft structure with initialized  mission history.
%                size/type/units: 1-by-1 / struct / []
%


%% INITIALIZE VARIABLES FOR MISSION HISTORY %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% get the number of points in the mission profile
npnt = Aircraft.Mission.Profile.SegEnd(end);

% get the number of thrust, power, and energy sources
[nts, nps] = size(Aircraft.Specs.Propulsion.PropArch.TSPS);
[~  , nes] = size(Aircraft.Specs.Propulsion.PropArch.PSES);

% create array of zeros to initialize the history
ZeroScalar = zeros(     npnt, 1);
ZeroChars  = repmat("", npnt, 1);

% array of zeros for the thrust, power, and energy sources
ZeroES = zeros(npnt, nes);
ZeroPS = zeros(npnt, nps);
ZeroTS = zeros(npnt, nts);

% array of zeros for energy/power/thrust splits
ZeroTS__ = zeros(npnt, max(1, Aircraft.Settings.nargTS  ));
ZeroTSPS = zeros(npnt, max(1, Aircraft.Settings.nargTSPS));
ZeroPSPS = zeros(npnt, max(1, Aircraft.Settings.nargPSPS));
ZeroPSES = zeros(npnt, max(1, Aircraft.Settings.nargPSES));

% performance sub-structure
Performance = struct("Time", ZeroScalar, ...
                     "Dist", ZeroScalar, ...
                     "TAS" , ZeroScalar, ...
                     "EAS" , ZeroScalar, ...
                     "RC"  , ZeroScalar, ...
                     "Alt" , ZeroScalar, ...
                     "Acc" , ZeroScalar, ...
                     "FPA" , ZeroScalar, ...
                     "Mach", ZeroScalar, ...
                     "Rho" , ZeroScalar, ...
                     "Ps"  , ZeroScalar) ;
                 
% propulsion sub-structure
Propulsion = struct("TSFC"    , ZeroPS, ...
                    "ExitMach", ZeroPS, ...
                    "FanDiam" , ZeroPS, ...
                    "MDotAir" , ZeroPS, ...
                    "MDotFuel", ZeroPS) ;
                
% weights sub-structure
Weight = struct("CurWeight", ZeroScalar, ...
                "Fburn"    , ZeroScalar) ;
            
% power sub-structure
Power = struct("TV"     , ZeroScalar, ...
               "Req"    , ZeroScalar, ...
               "LamTS"  , ZeroTS__  , ...
               "LamTSPS", ZeroTSPS  , ...
               "LamPSPS", ZeroPSPS  , ...
               "LamPSES", ZeroPSES  , ...
               "SOC"    , ZeroES    , ...
               "Pav_TS" , ZeroTS    , ...
               "Pav_PS" , ZeroPS    , ...
               "Preq_TS", ZeroTS    , ...
               "Preq_PS", ZeroPS    , ...
               "Tav_TS" , ZeroTS    , ...
               "Tav_PS" , ZeroPS    , ...
               "Treq_TS", ZeroTS    , ...
               "Treq_PS", ZeroPS    , ...
               "Pout_TS", ZeroTS    , ...
               "Tout_TS", ZeroTS    , ...
               "Pout_PS", ZeroPS    , ...
               "Tout_PS", ZeroPS    , ...
               "P_ES"   , ZeroES    ) ;
    
% energy sub-structure
Energy = struct("KE"      , ZeroScalar, ...
                "PE"      , ZeroScalar, ...
                "E_ES"    , ZeroES    , ...
                "Eleft_ES", ZeroES    ) ;

% assemble structures into cohesive structure
MissionVars = struct("Performance", Performance, ...
                     "Propulsion" , Propulsion , ...
                     "Weight"     , Weight     , ...
                     "Power"      , Power      , ...
                     "Energy"     , Energy     ) ;
                 

%% INITIALIZE MISSION HISTORY %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialize the mission history and segments flown
Aircraft.Mission.History = struct("SI"     , MissionVars, ...
                                  "EE"     , MissionVars, ...
                                  "Segment", ZeroChars  ) ;
                              
% ----------------------------------------------------------

end
