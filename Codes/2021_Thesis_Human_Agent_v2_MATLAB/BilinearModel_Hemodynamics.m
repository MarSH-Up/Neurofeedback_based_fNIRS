function [Pj, Qj] = BilinearModel_Hemodynamics(Z, U, P_SD, A)
%% Version V1
% Authors - Mario De Los Santos, Felipe Orihuela-Espina, Javier Herrara-Vega
% Date - August 28th, 2021
% Email - madlsh3517@gmail.com
%
%% Input Parameters
% Z - Neurodynamics. Sized <nRegions x simulationLength>
% U_Timestamps - Time sequence for the stimulus train.
% P_SD - Prior Parameters (Using now the estimated by STak,2015)
%
%% Output Parameters
% 
% q - HbR - Rate of deoxy-hemoglobin
% p - HbT - Total Hemoglobin
%
%% 
    nRegions  = size(A,1);
    simulationLength = size(U, 2);

    % Hemodynamc parameters
    %     Kj   Yj   Tj alpha rho  Tjv
    H = [0.64 0.32 2.00 0.32 0.32 2.00]; 
    
    Kj = H(1)*exp(P_SD(1));
    Yj = H(2)*exp(P_SD(2));
    Tj = H(3)*exp(P_SD(3));
    Tjv = H(6)*exp(P_SD(4));
    
    %Sj definition
    Sj = nan(nRegions,simulationLength);
    Sj(:,1) = 0;
    Sj(:,2) = 0;
    
    %Rate of blood volume Vj
    Vj = nan(nRegions,simulationLength);
    Vj(:, 1) = 0;
    
    %Outflow
    Fjout = Vj(:,1).^(1/H(4));
    
    %Total hemoflobin concentration
    Pj = nan(nRegions,simulationLength);
    Pj(:,1) = 0;
    
    %Deoxy
    Qj = nan(nRegions,simulationLength);
    Qj(:,1) = 0;
    

    %Implementation of equations
    for t = 3:simulationLength
        %We need to review how to implement fjin;
        Fjin = Sj(:,t-2);
        
        %Vasodilatory Signal
        Sj_dot = Z(:,t) - Kj * Sj(:,t-1) - Yj * (Fjin - 1); 
        
        %Rate of blood volume
        Vj_dot = Fjin - Fjout;
        
        %Outflow
        Fjout = Fjout + Tjv * Vj_dot;
        
        % Total Hemoglobin concentration
        Pj_dot = Vj_dot .* (Pj(:,t-1) / Vj(:,t-1));
        
        
        %Deoxy-Hemoglobin
        E = 1 - (1 - H(5)) .^ (1 / (Fjin/H(5)));
        Qj_dot = Fjin .* ((E) / H(5)) - Fjout .* (Qj(:,t-1) / Vj(:,t-1));
        
        Sj(:,t) = Sj(:,t) + Sj_dot;
        Vj(:,t) = Vj(:,t) + Vj_dot;
        Pj(:,t) = Pj_dot;
        Qj(:,t) = Qj_dot;

        
    end
    
  
end

