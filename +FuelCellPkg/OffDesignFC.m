function [LH2_Consumption] = OffDesignFC(Aircraft,CurrentPower,h,M)

% changes in efficiency based on off design performance
% delta_eta = function_of(MaxPower,CurrentPower,etc); % Hope this isn't
% needed for you

% load FC data
%load('FC_data.mat')
FCmap_eff = Aircraft.HistData.FC.FCmap_eff;

h = UnitConversionPkg.ConvLength(h,'m','ft');

h(h > 37499) = 37499;
M(M > 0.8) = 0.8;


% Fuel Consumption
% OffDesignFC.Performance = LH2_Consumption(SizedFuelCellSystem, CurrentPower, delta_eta);
FuelCell_Weight = UnitConversionPkg.ConvMass(Aircraft.Specs.Weight.FuelCells,'kg','lbm'); % weight from KG to LB

FCeff = FuelCellPkg.interp3D_V003(FCmap_eff,1,CurrentPower/FuelCell_Weight,M,h,'n');

FCeff(FCeff > 37500) = 37500;

% Drag caused by HEX, not currently used
% drag = interp3D_V003(FCmap_drag,1,CurrentPower/FuelCell_Weight,M,h,'n')*FuelCell_Weight;

% Magnitude of heat rejection, Watts.
%heat = interp3D_V003(FCmap_heat,1,CurrentPower/FuelCell_Weight,M,h,'n')*FuelCell_Weight; % heat, watts

LH2_Consumption = CurrentPower/FCeff/119930040; % consumption in KG/SEC



end