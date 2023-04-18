FreqM = 1.08;
FreSD = 0.16;
FreqStep = 1/100;
start =  FreqM - 2 * FreSD;
endS = FreqM +  2 * FreSD + FreqStep;
range = endS - start;
disp('Start');
disp(start);
disp('End');
disp(endS);
disp('range');
disp(range);

PalFor = range/FreqStep;
int16(PalFor);
FrequencySet = zeros(1, 65);
FrequencySet(1,1) = start;
for i =  2:PalFor
    FrequencySet(1,i) = FrequencySet(1,1) + (i * FreqStep);
end