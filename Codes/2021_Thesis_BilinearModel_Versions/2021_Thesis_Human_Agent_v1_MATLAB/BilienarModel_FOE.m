%Script to test the BilinearModel
%
% Authors: Mario de los Santos, Felipe Orihuela-Espina, Javier Herrara-Vega
%
%% Log:
%
% 11-Jun-2021: FOE
%   - Sent function Stimulus to a separate file BilinearModel_StimulusTrainGenerator
%   - Sent function Neurodynamics_Z to a separate file BilinearModel_Neurodynamics_Z
%   - Added some comments
%   - Added plot for the stimulus trains
%
% 13-Jun-2021: MDLS
%   - Stimulus fuctions modifed to allow multiple cycles.
%   - Neurodynamics_Z Funtion modifed adding Self-inhibition affection Latent Connectivity Matrix A.
%   - 

A = [-0.16 -0.49; -0.02 -0.33];
B1 = [0 0; 0 0]; %There must be a B per stimulus
B2 = [-0.02 -0.77; 0.33 -1.31];
%B2 = [0 0; 0 0];
B(:,:,1) = B1;
B(:,:,2) = B2;
C = [0.08 0; 0.06 0];

freq = 10.4;

[U_stimulus, timestamps] = BilinearModel_StimulusTrainGenerator(freq, 5, 25, 3); 
%[U_stimulus, timestamps, size] = BilinearModel_StimulusTrain(10.4, 5, 25, 1100); 
%figure, hold on
%plot(timestamps,U_stimulus(1,:),'r-','LineWidth',1.5);
%plot(timestamps,U_stimulus(2,:)+2,'b-','LineWidth',1.5);
%xlabel('Time [secs]');
%ylabel('U')

[Z] = BilinearModel_Neurodynamics_Z(A,B,C, U_stimulus, 1/freq);
Zm1  = Z(1,:);
Zsma = Z(2,:);  


figure
ax1 = subplot(2,1,1); % top subplot
plot(ax1,timestamps,Zm1)
title(ax1,'Zm1')
ylabel(ax1,'Time')

ax2 = subplot(2,1,2); % bottom subplot
plot(ax2,timestamps,Zsma)
title(ax2,'Zsma')
ylabel(ax2,'Time')

figure;
subplot(211);
plot(timestamps,U_stimulus(1,:));
xlabel('Time (s)');
ylabel('Task (U_{1})');
hold on;
    
subplot(212);
plot(timestamps,U_stimulus(2,:)+2);
xlabel('Time (s)');
ylabel('Task (U_{2})');
    
    
    