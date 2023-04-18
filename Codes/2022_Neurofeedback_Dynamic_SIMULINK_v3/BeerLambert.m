%Load intensity measured data (raw)
%            698   828
%     data=| a11   a12|
%          | a21   a22|
%          | a31   a32|
%            ...
%          | aN1   aN2|
%

%data=load('Data.mat');
%loadData;


%Molar extinction coefficients for HbO2 and Hb for the wavlengths 698nm and
%828 (http://omlc.org/spectra/hemoglobin/summary.html)
%         HbO2   Hb
%   698 | 286   1846.08 |
%   828 | 965.2  693.2  |
%

e_Coeffs=[735.8251, 1104.715; 1159.306, 785.8993];
      


      
%Differential Path Lenght Factor (DPF) this is a function of the wavelength
DPF=[10.3; 8.4];
%DPF=[6.26,6.26];


%Source-Detector distance
d=3;

%Results stored in vector X
X=zeros(size(Data,1),2);


A=[e_Coeffs(1,1)*d*DPF(1), e_Coeffs(1,2)*d*DPF(1);...
   e_Coeffs(2,1)*d*DPF(2), e_Coeffs(2,2)*d*DPF(2)];
   
n=size(Data,1);
for i=1:1:n-1;

    deltaOD_L1=(-1)*log(Data(i+1,1)/Data(1,1));
    deltaOD_L2=(-1)*log(Data(i+1,2)/Data(1,2));
    
    b=[deltaOD_L1; deltaOD_L2];
    

    X(i,:) = linsolve(A,b)'*(10^5);   
   
end

%X = movingmean(X,10,1);
figure;
hold on;
plot(1:length(X(:,1)),X(1:end,1),'b-');
hold on;
plot(1:length(X(:,2)),X(1:end,2),'r-');
title('Reconstructed Oxy and Deoxy-haemoglobin with MBLL');
