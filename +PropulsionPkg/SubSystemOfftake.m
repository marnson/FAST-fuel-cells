function [EP] = SubSystemOfftake(PowerTO,SizingFlag)


% Read in total takeoff power output at the thrust source
%PowerTO = sum(Aircraft.Mission.History.SI.Power.Pout_TS(1,:));

switch SizingFlag
    case "Sizing"
        EP_Fxn = @(P) 1.5817*P^0.53734;
    case "OffDesign"
        EP_Fxn = @(P) 1.1863*P^0.53734;
end

% Convert to Kilowatts
PowerTO = PowerTO/1e3;

% Run Regression
EP = EP_Fxn(PowerTO);

% Convert Back to Watts
EP = EP*1e3;


end

