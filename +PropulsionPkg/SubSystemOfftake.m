function [EP] = SubSystemOfftake(PowerTO,SizingFlag)


% Read in total takeoff power output at the thrust source
%PowerTO = sum(Aircraft.Mission.History.SI.Power.Pout_TS(1,:));

switch SizingFlag
    case "Sizing"
        EP_Fxn = @(P) 0.4148*P^0.6598;
    case "OffDesign"
        EP_Fxn = @(P) 0.2668*P^0.7008;
end

% Convert to Kilowatts
PowerTO = PowerTO/1e3;

% Run Regression
EP = EP_Fxn(PowerTO);

% Convert Back to Watts
EP = EP*1e3;


end

