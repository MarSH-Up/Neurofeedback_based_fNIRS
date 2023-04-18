function [SemiSyntheticNoiseOxy1, SemiSyntheticNoiseDeoxy1,SemiSyntheticNoiseOxy2, SemiSyntheticNoiseDeoxy2, timeSize] = Neurofeedback_SemiSyntheticNoise_extraction(nameDeoxy,nameOxy, nSets, freq, Setsize, nChannels)

timeSize = (1/freq) * (1:Setsize);
%timeSize = timeSize';
actualFreq = 4;

%File format
fileFormat = '.txt'; %define your file type
fileFoldername = 'Data/';
%Random file selection
SetSelector =  int32(1 + (nSets-1) * rand());
SetSelector = int2str(SetSelector);

%File name composition
temp = append(SetSelector, fileFormat);

FileNameDeoxy = append(nameDeoxy, temp);
FileNameDeoxy = append(fileFoldername, FileNameDeoxy);

FileNameOxy = append(nameOxy, temp);
FileNameOxy = append(fileFoldername, FileNameOxy);


%Opening files
fileID_Deoxy = fopen(FileNameDeoxy, 'r');
formatSpec = '%f';
sizeV = [nChannels Setsize];
Deoxy = fscanf(fileID_Deoxy, formatSpec, sizeV);
Deoxy = resample(Deoxy, 10, 4);
fclose(fileID_Deoxy);

fileID_Oxy = fopen(FileNameOxy, 'r');
Oxy = fscanf(fileID_Oxy, formatSpec, sizeV);
Oxy = resample(Oxy, 11, 4);
fclose(fileID_Deoxy);


%Random channel selection
Channel =  int32(1 + (nChannels-1) * rand());
SemiSyntheticNoiseOxy1 = timeseries(Oxy(Channel,:), timeSize);
SemiSyntheticNoiseDeoxy1 = timeseries(Deoxy(Channel,:), timeSize);
SemiSyntheticNoiseOxy2 = timeseries(Oxy(Channel+1,:), timeSize);
SemiSyntheticNoiseDeoxy2 = timeseries(Deoxy(Channel+1,:), timeSize);

end

