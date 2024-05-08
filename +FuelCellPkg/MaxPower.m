function [MaxPow] = MaxPower(Aircraft, h, M, NumFC)

Data = Aircraft.HistData.FC;

M(M < 0.25) = 0.25;

MaxPow = interp2(Data.MP_h_rng,Data.MP_M_rng,Data.MP_Wlb_mat,h,M).*(Aircraft.Specs.Weight.FuelCells);

MaxPow = repmat(MaxPow,[1 NumFC]);

end

