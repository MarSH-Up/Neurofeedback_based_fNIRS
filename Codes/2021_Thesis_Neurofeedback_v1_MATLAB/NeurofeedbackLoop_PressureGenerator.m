function [Pobs]=NeurofeedbackLoop_PressureGenerator(Zt,t)
%% Version V1
% Authors - Mario De Los Santos, Felipe Orihuela-Espina, Javier Herrara-Vega
% Date - July 17th, 2021
% Email - madlsh3517@gmail.com
%
%   Simulates the generation of the observed pressure (Pobs)
%   This is a naive model based on an RC circuit
%
%% Input Parameters
%
% - Zt   + Neural response of the motor region at time t, would be the equivalent of
%         the Voltage souce in RC
% - t    + Time (samples) since last change in Zt; e.g. t=tau-0.
%
%% Output Parameters
%
% - Pobs + Observed pressure at time t
%
%%

    %Play a bit herewith the values of R and C to get an idea of how
    %fast/slow converges


    R=1000; %Resistor [Ohms];
    C=400; %Capacitor [Faradays];

    V= Zt; %Voltage or system reference;
    
    [A,simulationLength] = size(Zt);
    Vc = zeros(1,simulationLength);
    for i = 1:simulationLength
        Vc(:,i) = V(:,i) * (1 - exp(-t(:,i)/R*C)); % Voltage at the capacitor
    end
    %-t(:,i)
        %Vs = V * (1-exp(-t/(R*C)));
    %Please note that there is a more elegant differential
    %expression in the Laplace domain (which will make passing t unnecesary),
    %but by now, this will do.
    
    
    Pobs = Vc;

end
