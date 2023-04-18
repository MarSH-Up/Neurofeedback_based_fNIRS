%
% author: Mario de los Santos
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


close all;
A = [-0.16 -0.49; -0.02 -0.33];
B1 = [0 0; 0 0]; %There must be a B per stimulus
B2 = [-0.02 -0.77; 0.33 -1.31];
%B2 = [0 0; 0 0];
B(:,:,1) = B1;
B(:,:,2) = B2;
C = [0.08 0; 0.06 0];

freq = 10.4;

[U_stimulus, timestamps] = BilinearModel_StimulusTrainGenerator(freq, 5, 25, 2); 
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


[Z] = BilinearModel_Neurodynamics_Z(A,B,C, U_stimulus, 1/freq);

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
title('Neural Response');


%Concept run

[P] = Neurofeedback_PressureGenerator_sensor(Zm1, timestamps);
figure;

plot(timestamps, P,'LineWidth',2);
title('Pressure Generator');
X = rand(4)< 0.5;
Y = X;
Z = rand(4)< 0.5;

[val, matrix] = NeurofeedbackLoop_proxySHD(X,Z);
disp('A_ref');
disp(X);
disp('A_obs');
disp(Z);
disp('SHD: ');
disp(val);
disp('SHD Matrix: ');
disp(matrix);

[E]= NeurofeedbackLoop_ErrorFunction(X, Z, 3.4, 1.5);
disp('Error function')
disp(E)

%Sin wave generation
x = 0:0.1:60;

%Equals
y_1 = sin(x);
noiseSigma= 0.05 * y_1;
noise = noiseSigma .* randn(1, length(y_1));
noisySignal = y_1 + noise;
y_2 = noisySignal;

%Noise
period = 30;
y_3 =  sin(2 * x);
noiseSigma_y3 = 0.5 * y_3;
noise_y3 = noiseSigma_y3 .* randn(1, length(y_3));
noisySignal_y3 = y_3 + noise_y3;

y_4 = sin(x*-1);


figure;
subplot(411);
plot(x,noisySignal,'LineWidth',2);
xlabel('Time (s)');
ylabel('Signal A');
title('Connectivity Signals');
hold on;    
subplot(412);
plot(x,y_2,'LineWidth',2);
xlabel('Time (s)');
ylabel('Signal A');
subplot(413);
plot(x,noisySignal_y3,'LineWidth',2);
xlabel('Time (s)');
ylabel('Signal C');
subplot(414);
plot(x,y_4,'LineWidth',2);
xlabel('Time (s)');
ylabel('Signal D');


% signals = {noisySignal, y_2,noisySignal_y3, y_4};
% nSamples = x;
% nChannels = 4; 
% nHb = signals;

D = zeros(300,4);
D = [noisySignal',y_2', y_2',y_3'];

%disp(size(D));
Aobs = NeruofeedbackLoop_getConnectivity(D);
disp('Connectivity: ');
disp(Aobs);


