function [D] = BilinearModel_Neurodynamics_Dconstant(A,B,C,Uto,Zto)
%% Version V1
% Authors - Mario De Los Santos, Felipe Orihuela-Espina, Javier Herrara-Vega
% Date - September 5th, 2021
% Email - madlsh3517@gmail.com
%
%% Input Parameters
%
% - A       + Latent connectivity. Square matrix. Sized <nRegions x nRegions>
%             This is the first order connectivity matrix. It represents
%             the intrinsic coupling in the absence of experimental
%             perturbations.
%             It represents the connectivity from region j to region i in the
%             absence of experimental input
% - B       + Induced connectivity. Square matrix. Sized <nRegions x nRegions x nStimulus>
%             Effective change in coupling induced by the j-th input
%             Change in connectivity from region j to region i induced by k-th input;
% - C       + Extrinsic influences of inputs on neuronal activity.
%
% - U       + Stimuli in time 0 
%
% - Z       + Neurodynamics in time 0 (Usually taked as 0)
%
%
%% Output Parameters
% - D       + Arbitraty constant result of the ODE Solution. Please check
%             the Vademécum for the step-by-step solution.
%
%%    
   nRegions  = size(A,1);
       T = zeros(nRegions); %nRegions x nRegions
       for uu = 1:2 % Sum (Uj * Bj)
           tmp = Uto(uu,uu)*B(:,:,uu);
           T = T + tmp;
       end
    Jt = A + T;
    C_U = C*Uto(:,1);

    D = - C_U - Jt + log(Zto(:,1));
    fprintf('D \n');
    disp(size(Uto,1));
end

