function [FC_Weight] = OnDesignFC(Aircraft,MaxPower, h, M)

%initialize fuel cell
Oversizing_Factor = 1.3;

Data = Aircraft.HistData.FC;

maxpower_per_lb = interp2(Data.MP_h_rng,Data.MP_M_rng,Data.MP_Wlb_mat,h,M); % max power @ sizing criteria

FuelCell_Weight = MaxPower*Oversizing_Factor/maxpower_per_lb; % FC weight in lbs 
FC_Weight = FuelCell_Weight/2.2; %weight in KG

% HEX Credit

% HEXdrag = interp2(MP_h_rng,MP_M_rng,MP_Drag_mat,h,M)*FuelCell_Weight;
% v = speedofsound(h)*M;
% HEXPower = 1.3558179 * v * HEXdrag; %power in Watts

% On Design Performance
% SizedFuelCellSystem.Performance = interp2(MP_h_rng,MP_M_rng,MP_Eff_mat,h,M)*FuelCell_Weight;


% Alternative on-design perfomance with HEX credit
% FCeff = interp3D_V003(FCmap_eff,1,(MaxPower + HEXPower)/FuelCell_Weight,M,h,'n');

% LH2_Consumption = (MaxPower + HEXPower)/FCeff/119930040; % consumption in KG/SEC

end