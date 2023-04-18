%Script to test the Bilinear Model using the concept of ODE studied in the
%last meeting
%% Log: Mario De Los Santos
% September, 2021: MDLS
%   The version consider the order of the operations to meet the
%   requeriment of verification. The operational order is the next.
%       1. Declaration of A, B, and C. 
%       2. Stimulus generation. (U and Timestamps)
%       3. Calculation of J (algebraic operation)
%       4. ODE Z_dot
%% Space cleaning:
 clear;
 close all;
 clc;
%
%% Initial Parameters (This could be in a structure): 
A = [-0.16 -0.49; -0.02 -0.33];
B1 = [0 0; 0 0]; %There must be a B per stimulus
B2 = [-0.02 -0.77; 0.33 -1.31];
B(:,:,1) = B1;
B(:,:,2) = B2;
C = [0.08 0; 0.06 0];
freq = 10.4;

%% Stimulus generation U :
%This funtion will create the stimulus train needed for the model.
[U, timestamps] = BilinearModel_StimulusTrainGenerator(freq, 5, 25, 1); 

%Ploting the stimulus train
figure;
subplot(211);
plot(timestamps,U(1,:),'LineWidth',2);
xlabel('Time (s)');
ylabel('Task (U_{1})');
hold on;    
subplot(212);
plot(timestamps,U(2,:)+2,'LineWidth',2);
xlabel('Time (s)');
ylabel('Task (U_{2})');
title('Stimulus');

%% Effective connectivity: J
[J, CU] =  BilinearModel_Neurodynamics_J(A, B,C, U);

%% Z ODE 

%ODE parameters
t0 = 0;
tf = 5;
tspan = [t0 tf];
z0 = [0,0];

tic                  %Equation must go to the dzdt function
 [t,z] = ode23t(@(t,z) J(:,:,1)*z+CU(:,1), tspan, z0); %Como darle J y CU de forma dinamica
toc

Zm1  = z(:,1);
Zsma = z(:,2);  
figure
ax1 = subplot(2,1,1); % top subplot
plot(ax1,t,Zm1,'LineWidth',2);
title(ax1,'Zm1');
ylabel(ax1,'Time');

ax2 = subplot(2,1,2); % bottom subplot
plot(ax2,t,Zsma,'LineWidth',2);
title(ax2,'Zsma');
ylabel(ax2,'Time');


