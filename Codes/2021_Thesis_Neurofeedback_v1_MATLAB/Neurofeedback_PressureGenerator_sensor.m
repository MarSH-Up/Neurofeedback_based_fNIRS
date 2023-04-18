function [Pobs] = Neurofeedback_PressureGenerator_sensor(Zt, t)
%% Version V1
% Authors - Mario De Los Santos, Felipe Orihuela-Espina, Javier Herrara-Vega
% Date - February, 2022
% Email - madlsh3517@gmail.com
%
%   Simulates the generation of the observed pressure (Pobs)
%   This is a more complex model where we consider a resistive force sensor, 
%   and the behaivor of a RC circuit to emulate the force in kgf created 
%   by a user on a physical sensor. 
%
%% Input Parameters
%
% - Zt   + Neural response of the motor region at time t, would be the equivalent of
%         the Voltage souce in RC
% - t    + Time (samples) since last change in Zt; e.g. t=tau-0.
%
%% Output Parameters
%
% - Pobs + Observed pressure at time t in kgf
% Note: We consider 1 N = 0.1019716213 kgf
%
%%

C = 0.000001; % 0.1uF
Vcc = 5000; %Considering 5V as a real sensor, the value is on mV
Rf = 10000; %Fixed resistor 10k ohms
kgf = 0.1019716213; % 1N = 0.1019716213 kgf

[A,simulationLength] = size(Zt);
Vout = zeros(1, simulationLength);
Fsrforce = zeros(1, simulationLength);
Fsr = zeros(1, simulationLength); % FSR RESISTOR SENSOR

Vout(:,1) = 0.0001; %Used a small value to not use zero at time 0
Fsr (:,1) = 0.0001;
for i = 2:simulationLength
    Vout(:,i-1) = Zt(:,i) * (1 - exp(-t(:,i)/(Fsr(:,i-1)*C)));%Emulation of the capacitor
    Fsr(:,i) = (Vcc - Vout(:,i-1) * Rf) / Vout(:,i-1);

    FsConductance = 1000000; %Sensor conductance in uOhms
    FsConductance = FsConductance/Fsr(:,i);
    if FsConductance <= 1000
        Fsrforce(:,i) = FsConductance / 80; %Force on Newtons
    else
        Fsrforce(:,i) = FsConductance - 1000;
        Fsrforce(:,i) = Fsrforce(:,i) / 30;
    end


end
Pobs = Fsrforce(:,:) .* kgf; %Return the pressure transforming N to kgf
end


