function [FuelCell] = Example2050()
    % Wanted_Value = 2.7 kw/kg
    % % FC Inputs
    FuelCell.OpT = 180; %C, dependent on FC type %Decreasing T increases power?!
    FuelCell.Ncells = 1080; % FC input
    FuelCell.A = 0.0446; %m^2, FC input
    FuelCell.r = 6.2e-6; % ohm/m^2, FC input % main tuning parameter
    FuelCell.alpha = 0.5; % FC input, constant?
    % fc.Ido = 8e-4; % amp-m^2, range from 1e-3 to 1e-4
    FuelCell.xpara = 0.05; % parasitic loss factor, FC input
    FuelCell.Comp_eff = 0.9 ; %compressor efficiency
    FuelCell.Pfuel = 5; %bar, input
    FuelCell.mu =  .96;
    FuelCell.c0 = 1.125;
    FuelCell.c1 = 0.175;
    % fc.k = .20e-7;
    FuelCell.k = 60e-7;
    FuelCell.m = 8e-5;
    FuelCell.n = 2e-4;
    FuelCell.deg = 0.00; % degredation
    FuelCell.weight = 363*2.2/1.142; % Multiply this to change weight estimation
end

