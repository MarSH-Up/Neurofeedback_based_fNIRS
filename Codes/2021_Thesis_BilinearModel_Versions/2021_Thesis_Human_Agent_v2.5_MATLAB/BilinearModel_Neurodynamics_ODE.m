function [Z] = BilinearModel_Neurodynamics_ODE(A, B, C, U, step)

%% Version V1
% Authors - Mario De Los Santos, Felipe Orihuela-Espina, Javier Herrara-Vega
% Date - September 5th, 2021
% Email - madlsh3517@gmail.com
%
% Note: This version have been done solving the ODE system to confirm the
% correct solution of the system, this will help us to solve the next
% stages of the bilinear model.

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
% - U       + Stimuli. Sized <nStimuli x nTimeSamples>
%
% - step    + Integration step.
%
%% Output Parameters
%
% - Z       + Neurodynamics. Sized <nRegions x simulationLength>
%%
   nRegions  = size(A,1);
   M = size(U,1); %nStimuli
   simulationLength = size(U,2);
   
   Z0 = [0.1:0.1];
   Z = nan(nRegions,simulationLength);
   Z(:,1) = Z0;
   D = BilinearModel_Neurodynamics_Dconstant(A,B,C,U,Z); %Arbitrary constant 
  for t = 2:simulationLength
          T = zeros(nRegions); %nRegions x nRegions
          for uu = 1:M % Sum (Uj * Bj)
              tmp = U(uu,t)*B(:,:,uu);
           %Please notice that S.Tak mentioned that the the use of the latent
           %variabls  A and B ensures that self connections J are negative
           %(typically with a value of 0.5)
              T = (T + tmp);
          end
          J = -0.5*exp(A + T);
          Z(:,t) = exp(J+D)*exp(C*U(:,t));       
  end
  fprintf('T \n');
  disp(J+D);

  
end

