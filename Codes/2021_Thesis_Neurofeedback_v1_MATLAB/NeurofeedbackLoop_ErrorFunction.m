function [E]=NeurofeedbackLoop_ErrorFunction(Aref, Aobs, Pref, Pobs)
%% Version V1
% Authors - Mario De Los Santos, Felipe Orihuela-Espina, Javier Herrera-Vega
% Date - July 17th, 2021
% Email - madlsh3517@gmail.com
%
%   Calculate the error in the controller
%
%% Input Parameters
%
% - Aref, Aobs + Connectivity matrices (reference and observed)
%
% - Pref, Pobs + Connectivity matrices (reference and observed)
%
%% Output Parameters
%
% - E          + Error diference between Aref/Aobs and Pref/Pobs
%
%%


    w1=0.6; %Use whatever values you like most. Threshold 
    w2=1-w1;
    
    disp('W1');
    disp(w1);
    disp('W2');
    disp(w2);
    
    assert(all(size(Aref)==size(Aobs)));
    assert(size(Aref,1)==size(Aref,2));

    nChannels = size(Aref,1);

    AfullyConnected = ones(nChannels);
    AfullyDisconnected = zeros(nChannels);

    [maxDiffSHD, matrix] = NeurofeedbackLoop_proxySHD(AfullyConnected,AfullyDisconnected);
    disp('maxDiffSHD');
    disp(maxDiffSHD);
    
    [errA, matrix_errA] = NeurofeedbackLoop_proxySHD(Aobs,Aref); %Normalize error in the connectivity
    errA = errA/maxDiffSHD;
    disp('errA');
    disp(errA);
    
    errP = abs(Pobs-Pref)/abs(Pref);
    disp('errP');
    disp(errP);
    
    E = w1*errA + w2*errP;

end

