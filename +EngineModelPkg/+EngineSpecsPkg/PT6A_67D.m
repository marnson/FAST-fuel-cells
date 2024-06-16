function [Engine] = PT6A_67D()
%
% [Engine] = PT6A_67D()
% Written By Maxfield Arnson, Yi-Chih Wang
% Last Updated: 06/16/2024
%
% Engine specification function for use with the EngineModelPkg
%
% INPUTS:
%
% [None]
%
%
% OUTPUTS:
%
% Engine = struct storing the information specified by the user for this
%           specific engine
%       size: 1x1 struct
%
%
% Information
% -----------
%
% Type = Turboprop
% Applicable Aircraft = Beechcraft 1900D

%% Design Point Values

% Flight Conditions
Engine.Mach = 0.05;
Engine.Alt = 0;
Engine.OPR = 10.8;  % done

% Architecture

% Burner total temp (Kelvin)
Engine.Tt4Max = 1110;   % kelvin % to be updated

% Required Power Output (Watts)
Engine.ReqPower = 954e3; % kW to W % done

% Initial Guess for Nozzle Pressure Ratio: Pt7/Ps9
Engine.NPR = 1.3;

% Number of Spools
Engine.NoSpools = 2; %done

% Spool RPMs, highest pressure to lowest
Engine.RPMs = [39000,1700];  % done

% Efficiencies
Engine.EtaPoly.Inlet = 0.99; % to be updated
Engine.EtaPoly.Diffusers = 0.99; % to be updated
Engine.EtaPoly.Compressors = 0.88; % to be updated
Engine.EtaPoly.Combustor = 0.995; % to be updated
Engine.EtaPoly.Turbines = 0.88; % to be updated
Engine.EtaPoly.Nozzles = 0.985; % to be updated

end
