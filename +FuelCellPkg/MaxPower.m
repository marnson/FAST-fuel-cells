function [MaxPow] = MaxPower(Aircraft, h, M, NumFC)

Data = Aircraft.HistData.FC;

h = UnitConversionPkg.ConvLength(h,'m','ft');

h(h > 37499) = 37499;
M(M > 0.8) = 0.8;
M(M < 0.25) = 0.25;

MaxPow = interp2(Data.MP_h_rng,Data.MP_M_rng,Data.MP_Wlb_mat,h,M).*UnitConversionPkg.ConvMass(Aircraft.Specs.Weight.FuelCells/NumFC,'kg','lbm');

MaxPow = repmat(MaxPow,[1 NumFC]);

end

