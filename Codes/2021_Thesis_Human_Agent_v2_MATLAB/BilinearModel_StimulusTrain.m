function [U, Time] = BilinearModel_StimulusTrain(freq, action_time, rest_time, totalSeconds)
%% Version V1
% Authors - Mario De Los Santos, Felipe Orihuela-Espina, Javier Herrara-Vega
% Date - July 17th, 2021
% Email - madlsh3517@gmail.com
%
%% Input Parameters
%
% freq         - Sampling Frequency (Recommend 10Hz)
% action_time  - Activation blocktime
% rest_time    - Rest blocktime (no activity)
% totalSeconds - Session Time
%
%% Output Parameters
%
% U - Complete Stimulus Train
% Time - Stimulus Train total time
% 
%%

    rest  = rest_time * freq;
    activation = action_time * freq;
    U=zeros(2,totalSeconds*freq);
    cycles=totalSeconds/(action_time+rest_time);
    
   
    %Task(U_1)
    for i=1:cycles
        block_ini=(rest*i)+(activation*(i-1));
        block_end=block_ini+activation;
        U(1,block_ini:block_end)=1;
    end
    
    %Task(U_2)
    U(2,451*freq:end+1)=1;
        
    Time=linspace(0,totalSeconds,totalSeconds*freq);
    
    %%Debug tools
    %figure;
    %subplot(211);
    %plot(Time,U(1,:));
    %ylim([-0.5 1.5]);
    %xlabel('Time (s)');
    %ylabel('Task (U_{1})');
    %hold on;
    
    %subplot(212);
    %plot(Time,U(2,:));
    %ylim([-0.5 1.5]);
    %xlabel('Time (s)');
    %ylabel('Task (U_{2})');
    
end