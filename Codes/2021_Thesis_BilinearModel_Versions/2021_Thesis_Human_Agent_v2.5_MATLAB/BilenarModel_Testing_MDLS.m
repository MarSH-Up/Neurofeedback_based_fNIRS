%Script to test the BilinearModel
% Authors: Mario de los Santos, Felipe Orihuela-Espina, Javier Herrara-Vega
%
%% Log:
% August, 2021: MDLS
%   
%%

clear; 
close all;
clc;
A = [-0.16 -0.49; -0.02 -0.33];
B1 = [0 0; 0 0]; %There must be a B per stimulus
B2 = [-0.02 -0.77; 0.33 -1.31];
%B2 = [0 0; 0 0];
B(:,:,1) = B1;
B(:,:,2) = B2;
C = [0.08 0; 0.06 0];

freq = 10.4;

[U_stimulus, timestamps] = BilinearModel_StimulusTrainGenerator(freq, 5, 25, 1); 
%[U_stimulus, timestamps] = BilinearModel_StimulusTrain(freq, 5, 25, 1100);
figure;
subplot(211);
plot(timestamps,U_stimulus(1,:),'LineWidth',2);
xlabel('Time (s)');
ylabel('Task (U_{1})');
hold on;    
subplot(212);
plot(timestamps,U_stimulus(2,:)+2,'LineWidth',2);
xlabel('Time (s)');
ylabel('Task (U_{2})');
title('Stimulus');


[Z] = BilinearModel_Neurodynamics_ODE(A,B,C, U_stimulus, 1/freq);
Zm1  = Z(1,:);
Zsma = Z(2,:);  
figure
ax1 = subplot(2,1,1); % top subplot
plot(ax1,timestamps,Zm1,'LineWidth',2);
title(ax1,'Zm1');
ylabel(ax1,'Time');

ax2 = subplot(2,1,2); % bottom subplot
plot(ax2,timestamps,Zsma,'LineWidth',2);
title(ax2,'Zsma');
ylabel(ax2,'Time');
