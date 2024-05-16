function [LH2_Consumption,heat] = OffDesignFC(Aircraft,CurrentPower,h,M)

% changes in efficiency based on off design performance
% delta_eta = function_of(MaxPower,CurrentPower,etc); % Hope this isn't
% needed for you

% load FC data
%load('FC_data.mat')

Data = Aircraft.HistData.FC;

h = UnitConversionPkg.ConvLength(h,'m','ft');

h(h > 37499) = 37499;
M(M > 0.8) = 0.8;


% Fuel Consumption
% OffDesignFC.Performance = LH2_Consumption(SizedFuelCellSystem, CurrentPower, delta_eta);
FuelCell_Weight = UnitConversionPkg.ConvMass(Aircraft.Specs.Weight.FuelCells,'kg','lbm'); % weight from KG to LB

FCeff = FuelCellPkg.interp3D_V003(Data.FCmap_eff,1,CurrentPower/FuelCell_Weight,M,h,'n');
if FCeff > 1
    FCeff = interp2(Data.MP_h_rng,Data.MP_M_rng,Data.MP_Eff_mat,h,M);
end


% Drag caused by HEX, not currently used
% drag = interp3D_V003(FCmap_drag,1,CurrentPower/FuelCell_Weight,M,h,'n')*FuelCell_Weight;

% Magnitude of heat rejection, Watts.

% Add line hear that uses an interp2 for M and h to get max heat

heat = FuelCellPkg.interp3D_V003(Data.FCmap_heat,1,CurrentPower/FuelCell_Weight,M,h,'n')*FuelCell_Weight; % heat, watts

if heat >  999999*FuelCell_Weight
    heat = interp2(Data.MP_h_rng,Data.MP_M_rng,Data.MP_Heat_mat,h,M)*FuelCell_Weight;
end

LH2_Consumption = CurrentPower/FCeff/119930040; % consumption in KG/SEC



end