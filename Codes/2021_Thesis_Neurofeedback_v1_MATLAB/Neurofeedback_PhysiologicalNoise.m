function [HemoNoises] = Neurofeedback_PhysiologicalNoise(FreqSD, FreqMean, ResolutionStep, timestamps, NRegions)
%% Version V1
% Authors - Mario De Los Santos, Felipe Orihuela-Espina, Javier
% Herrera-Vega, Javier Andreu-Pérez
% Date - July 18th, 2022
% Email - madlsh3517@gmail.com
% Based on: Elwell et. al., 1999. Oscillations in cerebal haemodynamics.
%
%% Input Parameters
% FreqSD - Frequency standard deviation of the physiological noise. Scalar
% FreqMean - Frequency Mean of the physiological noise. Scalar
% Resolution Step - Sampling rate. Scalar
% Timestamps - Time sequence for the stimulus train. <1 x simulationLength>
% NRegions - Number of regions activated. Scalar.
%% Output Parameters
% 
% HemoNoises -  Noise generation for the hemodynamics signals.
%               <NRegions x simulationLength>
%
%% 

%Variables to ADD the noises to the models. 
% These variables divide the hemodynamics 
% inputs depending on the number of regions.
HemoNoises = zeros(1, size(timestamps));
%Calculation of the operative ranges to use
Initial =  FreqMean - 2 * FreqSD;
Ending = FreqMean + 2 * FreqSD;
Calsize =  ((Ending - Initial - ResolutionStep)/ResolutionStep);
FrequencySet = linspace(Initial, Ending, Calsize);

amplitudeScaling = 1;
for i = 1:Calsize
    s = rng; %Rebot random seeed 

    %Random Amplitude
    %Centralized gaussian in the dispersion mean 
    A = 0;
    A = amplitudeScaling * normrnd(FreqMean,FreqSD);
   
    %Random phase
    theta = 0;
    theta = 2 * pi * normrnd(FreqMean,FreqSD) - pi;
    
    %Fundamental signal
    tmpSin = A * sin(pi * FrequencySet(1,i) * timestamps + theta);
    HemoNoises(1, :) = HemoNoises(:,:)+ tmpSin;

end
%This section should be generalized but do the work for now. 
