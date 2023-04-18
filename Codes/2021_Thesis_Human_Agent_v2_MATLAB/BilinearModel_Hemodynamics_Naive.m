function [Sj, Vj,Q, P, HD] = BilinearModel_Hemodynamics_Naive(Z, U, P_SD, A, Step)
%% Version V3
% Authors - Mario De Los Santos, Felipe Orihuela-Espina, Javier Herrara-Vega
% Date - August 28th, 2021
% Email - madlsh3517@gmail.com
% Based on: 2015 Stak DCM for fNIRS.
%
%% Input Parameters
% Z - Neurodynamics. Sized <nRegions x simulationLength>
% U_Timestamps - Time sequence for the stimulus train.
% P_SD - Prior Parameters (Using now the estimated by STak,2015)
%
%% Output Parameters
% 
% Q - HbR - Normalized Deoxy-hemoglobin
% P - HbT - Normalized Total Hemoglobin
% H - 
%
%% 

    %Simulation size definition
    nRegions  = size(A,1);
    simulationLength = size(U,2);
    
    %Vasodilatory Signal variable
    Sj_t0 = [0;0]; %We decided not to set it as zero to try
    Sj = nan(nRegions,simulationLength);
    Sj(:,1) = Sj_t0;
    
    %Inflow
    fjin_t0 = [0.00001;0.00001];
    fjin = nan(nRegions,simulationLength);
    fjin(:,1) = fjin_t0;
    
    %Rate of blood volume
    Vj_t0 = [0.00001;0.00001];
    Vj =  random('norm',0,0.000001,nRegions,simulationLength);
    Vj(:,1) = Vj_t0;
    
    %Total hemoglobin concentration
    Pj_t0 = [0.00001;0.00001];
    Pj = nan(nRegions,simulationLength);
    Pj(:,1) = Pj_t0;
    
    %Deoxy-Hemoglobin concentration
    qj_t0 = [0.00001;0.00001];
    qj = nan(nRegions,simulationLength);
    qj(:,1) = qj_t0;  
    
    E_t0 = [0.00001;0.00001];
    E = nan(nRegions,simulationLength);
    E(:,1) = E_t0;    

    %Actual HbT and HbR
    Q_t0 = [0;0];
    Q = nan(nRegions,simulationLength);
    Q(:,1) = Q_t0;    
    
    P_t0 = [0;0];
    P = nan(nRegions,simulationLength);
    P(:,1) = P_t0; 
    
    HD_t0 = [0.00001;0.00001];
    HD = nan(nRegions,simulationLength);
    HD(:,1) = HD_t0;   
    
    % Hemodynamc parameters
    %     Kj   Yj   Tj alpha rho  Tjv
%--------------------------------------------------------------------------
%   H(1) - signal decay                 - Kj                           
%   H(2) - autoregulation               - Yj
%   H(3) - transit time                 - Tj                     
%   H(4) - exponent for Fout(v)         - phi                  
%   H(5) - resting oxygen extraction    - alpha                   
%   H(6) - viscoelastic time constant   - Tjv           
%--------------------------------------------------------------------------
    H = [0.64 0.32 2.00 0.32 0.32 2.00];
    
    Kj = H(1)*exp(P_SD(1)); 
    Yj = H(2)*exp(P_SD(2)); 
    Tj = H(3)*exp(P_SD(3));
    Tjv = H(6)*exp(P_SD(4));
    phi = H(4);
    
    %Optics parameters for HbR and HbT concentrations
    P0 = 0.000071; %Consider that the paper indicates that should be uM
    S02 =0.65;
    Q0 = P0 * (1 - S02);
    
    for t = 2:simulationLength
        
        
        %Vasodilory signal actual T. Equation 2.1
        Sj_dot =  Z(:,t)  - Kj .* Sj(:,t-1)  - Yj .* (fjin(:,t-1)-1);
        fjin_dot = Sj(:,t-1); %Inflow actual T. Equation 2.2

        %Outflow. Equation 5.1
        fjout =  Vj(:,t-1).^ (1/H(4));
        
        Vj_dot = (fjin(:,t-1) - fjout)./Tj;% Rate of blood volume. Equation 3.1
        
        %Total Hemoglobin concentration. Equation 3.2
        fjout =  Vj(:,t-1).^ (1/H(4))+ Tjv.*Vj(:,t).*Vj_dot;
        Pj_dot = (((fjin(:,t-1) - fjout)) .* (Pj(:,t-1)./(Vj(:,t-1))))./(Tj.*Pj(:,t-1));
  
        %Proportion of oxygen .Equation 4.2
        Efp = (1 - (1 - phi).^(1./fjin(:,t-1)))/H(5);
        
        %Deoxy-hemoglobin .Equation 4.1
        qj_dot = ((fjin(:,t-1) .* E(:,t-1)) - fjout.*qj(:,t-1)./Vj(:,t-1))./(Tj.*qj(:,t-1));
        %disp(Qj_dot); 
       
       %Euler method
       %ref: Zn+1 = Zn + h * f(Xn, Zn)
        Sj(:,t) = Sj(:,t-1) + Step * Sj_dot;
        fjin(:,t) = fjin(:,t-1) + Step * fjin_dot;
        Vj(:,t) = Vj(:,t-1) + Step * Vj_dot;
        Pj(:,t) = Pj(:,t-1) + Step * Pj_dot;
        E(:,t) =  Efp;
        qj(:,t) = qj(:,t-1) + Step * qj_dot;
        
        Q(:,t) = qj(:,t);
        P(:,t) = Pj(:,t);
        HD(:,t) = P(:,t) - Q(:,t);
    end

end

