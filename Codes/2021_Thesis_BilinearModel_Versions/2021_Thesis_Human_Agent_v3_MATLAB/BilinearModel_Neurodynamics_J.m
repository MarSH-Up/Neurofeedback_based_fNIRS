function [J, CU] = BilinearModel_Neurodynamics_J(A, B, C, U)
%% Version V1
% Authors - Mario De Los Santos, Felipe Orihuela-Espina, Javier Herrara-Vega
% Date - September 8th, 2021
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
%             Change in connectivity from region j to region i induced by k-th input
% - U       + Stimuli. Sized <nStimuli x nTimeSamples>
%
%% Output Parameters
%
% - J       + Effective connectivity between and within regions. Sized <nRegions x nRegions>
% - CU      + 
%%
   %Parameters used to determinate the iteractions of J for each U
   nRegions = size(A, 1);
   M = size(U,1); %nStimuli
   simulationLength = size(U,2);
   
   J = nan(nRegions,nRegions,simulationLength);
   CU = nan(nRegions, simulationLength);
   assert(M == size(B,3),...
            'Unexpected number of induced connectivity parameters B.');
        
    for t = 1:simulationLength
       T = zeros(nRegions); %nRegions x nRegions
       for uu = 1:M % Sum (Uj * Bj)
           tmp = U(uu,t)*B(:,:,uu);
           %Please notice that S.Tak mentioned that the the use of the latent
           %variabls  A and B ensures that self connections J are negative
           %(typically with a value of 0.5). 
           T = -0.5*exp(T + tmp);
           
           J(:,:,t) = A + T; %Complete J consider the addition of A matrix. 
       end
       CU(:,t) =  C * U(:,t);
    end
    
end

