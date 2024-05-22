function [Aircraft] = PropulsionSizing(Aircraft)
%
% [Aircraft] = PropulsionSizing(Aircraft)
% written by Paul Mokotoff, prmoko@umich.edu
% last updated: 24 apr 2024
%
% Split the total thrust/power throughout the powertrain and determine the
% total power needed to size each component.
%
% INPUTS:
%     Aircraft - aircraft structure to get information about the aircraft
%                type and the propulsion system.
%                size/type/units: 1-by-1 / struct / []
%
% OUTPUTS:
%     Aircraft - aircraft structure updated with the weights of the power
%                sources.
%                size/type/units: 1-by-1 / struct / []
%


%% PRE-PROCESSING %%
%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            %
% obtain quantities from the %
% aircraft structure         %
%                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% aircraft class
aclass = Aircraft.Specs.TLAR.Class;

% analysis type
atype = Aircraft.Settings.Analysis.Type;

% get the takeoff speed
TkoVel = Aircraft.Specs.Performance.Vels.Tko;

% find the engines and electric motors
Eng = Aircraft.Specs.Propulsion.PropArch.PSType == 1;
EM  = Aircraft.Specs.Propulsion.PropArch.PSType == 0;
FC  = Aircraft.Specs.Propulsion.PropArch.PSType == 2;

% get the electric motor power-weight ratio
P_Wem = Aircraft.Specs.Power.P_W.EM;

% get the design splits
LamTS   = Aircraft.Specs.Power.LamTS.SLS  ;
LamTSPS = Aircraft.Specs.Power.LamTSPS.SLS;
LamPSPS = Aircraft.Specs.Power.LamPSPS.SLS;

% get the power source type
PSType = Aircraft.Specs.Propulsion.PropArch.PSType;

% check if the power optimization structure is available
if (isfield(Aircraft, "PowerOpt"))
    
    % check if the splits are available
    if (isfield(Aircraft.PowerOpt, "Splits"))
        
        % get the number of operational splits
        nopers = Aircraft.PowerOpt.nopers;
        
        % count the number of design splits
        tsplit = 1;
        
        % check for design thrust splits
        if (Aircraft.PowerOpt.Settings.DesnTS   == 1)
            
            % get the number of thrust splits
            nsplit = Aircraft.Settings.nargTS  ;
            
            % get the splits
            for isplit = 1:nsplit
                
                % get the current split
                LamTS(  isplit) = Aircraft.PowerOpt.Splits(nopers + tsplit);
                
                % account for the split
                tsplit = tsplit + 1;
                
            end
        end
        
        % check for design thrust-power splits
        if (Aircraft.PowerOpt.Settings.DesnTSPS == 1)
            
            % get the number of thrust-power splits
            nsplit = Aircraft.Settings.nargTSPS;
            
            % get the splits
            for isplit = 1:nsplit
                
                % get the current split
                LamTSPS(isplit) = Aircraft.PowerOpt.Splits(nopers + tsplit);
                
                % account for the split
                tsplit = tsplit + 1;
                
            end
        end
        
        % check for design power-power splits
        if (Aircraft.PowerOpt.Settings.DesnPSPS == 1)
            
            % get the number of power-power splits
            nsplit = Aircraft.Settings.nargPSPS;
            
            % get the splits
            for isplit = 1:nsplit
                
                % get the current split
                LamPSPS(isplit) = Aircraft.PowerOpt.Splits(nopers + tsplit);
                
                % account for the split
                tsplit = tsplit + 1;
                
            end
        end
    end
end


%% SIZE THE PROPULSION SYSTEM %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% get the SLS power depending on the aircraft class
if      (strcmpi(aclass, "Turbofan" ) == 1)
    
    % get the total thrust (t/w * mtow)
    T0 = Aircraft.Specs.Propulsion.Thrust.SLS;
    
    % get the total power (de-rate to account for not being static)
    P0 = 0.95 * T0 * TkoVel;
    
elseif ((strcmpi(aclass, "Turboprop") == 1) || ...
        (strcmpi(aclass, "Piston"   ) == 1)  )
    
    % get the total power  (p/w * mtow)
    P0 = Aircraft.Specs.Power.SLS;
    
else
    
    % throw error
    error("ERROR - SplitPower: invalid aircraft class provided.");
    
end

P0 = P0 + PropulsionPkg.SubSystemOfftake(P0,"Sizing");

% get the power/thrust split function handles
FunSplitTS   = Aircraft.Specs.Propulsion.Oper.TS  ;
FunSplitTSPS = Aircraft.Specs.Propulsion.Oper.TSPS;
FunSplitPSPS = Aircraft.Specs.Propulsion.Oper.PSPS;

% get the splits
LamTS   = Aircraft.Specs.Power.LamTS.SLS;
LamTSPS = Aircraft.Specs.Power.LamTSPS.SLS;
LamPSPS = Aircraft.Specs.Power.LamPSPS.SLS;

% get function to compute the thrust/power splits
SplitTS   = PropulsionPkg.EvalSplit(FunSplitTS  , LamTS  );
SplitTSPS = PropulsionPkg.EvalSplit(FunSplitTSPS, LamTSPS);
SplitPSPS = PropulsionPkg.EvalSplit(FunSplitPSPS, LamPSPS);

% split the power amongst the power sources
Power = PropulsionPkg.SplitPower(Aircraft, P0, SplitTS, SplitTSPS, SplitPSPS);

% convert power to thrust
Thrust = Power ./ TkoVel;

% remember the power  available for each power source
Aircraft.Specs.Propulsion.SLSPower = Power;

% remember the thrust available for each power source
Aircraft.Specs.Propulsion.SLSThrust = Thrust;

% check for a fully-electric architecture (so engines don't get sized)
if (any(PSType == 1))

    % lapse thrust/power for turbofan/turboprops, respectively
    if      (strcmpi(aclass, "Turbofan" ) == 1)

        % predict engine weight using the design thrust
        TurbofanEngines = Aircraft.HistData.Eng;
        IO = {["Thrust_Max"],["DryWeight"]};

        % row vector can have multiple targets for a single input
        target = Thrust(Eng)';

        % run the regression
        Weng = RegressionPkg.NLGPR(TurbofanEngines,IO,target);

    elseif ((strcmpi(aclass, "Turboprop") == 1) || ...
            (strcmpi(aclass, "Piston"   ) == 1) )

        % Predict Engine Weight using SLS power
        TurbopropEngines = Aircraft.HistData.Eng;
        [~,WengReg] = RegressionPkg.SearchDB(TurbopropEngines,["DryWeight"]);
        WengReg = cell2mat(WengReg(:,2));
        [~,PowReg] = RegressionPkg.SearchDB(TurbopropEngines,["Power_SLS"]);
        PowReg = cell2mat(PowReg(:,2));
        cind = [];
        for ii = 1:length(PowReg)
            if isnan(PowReg(ii)) || isnan(WengReg(ii))
                cind = [cind,ii];
            end
        end
        WengReg(cind) = [];
        PowReg(cind) = [];
        W_f_of_pow = polyfit(PowReg,WengReg,1);

        % estimate the engine weights
        Weng = polyval(W_f_of_pow, Power(Eng) / 1000);

    else

        % throw error
        error("ERROR - PropulsionSizing: invalid aircraft class.");

    end

else

    % no engines need to be sized
    Weng = 0;

end

if (any(PSType == 2))
    
    % where FC = PSType == 2
    HasFC = find(FC);
    Wfc = zeros(1,length(HasFC));
    
    % loop through the engines
    for ifc = 1:length(HasFC)
        % size fuel cell (on design) with design point and max power
%         Wfc(ifc) = FuelCellPkg.OnDesignFC(Aircraft,Power(HasFC(ifc)),1e4,0.78);
Wfc(ifc) = FuelCellPkg.OnDesignFC(Aircraft,15806525.62/2,1e4,0.78);
          
    end
    
else

    % no fuel cells get sized
    Wfc = 0;

end

% remember the weight of the engines
Aircraft.Specs.Weight.Engines = sum(Weng);
Aircraft.Specs.Weight.FuelCells = sum(Wfc);

% check if the electric motor weight can be changed and remember it
if (atype > 0)
    Aircraft.Specs.Weight.EM = sum(Power(EM)) / P_Wem;
% Aircraft.Specs.Weight.EM = 15806525.62 / P_Wem;
    
end

% ----------------------------------------------------------

end