function [val] = NeruofeedbackLoop_getConnectivity(D)
%% Version V1
% Authors - Mario De Los Santos, Felipe Orihuela-Espina, Javier Herrara-Vega
% Date - July 17th, 2021
% Email - madlsh3517@gmail.com
%
%   A very naive connectivity model
%   Connected regions are those correlated (above a threshold) in BOTH Hb species
%
%% Input Parameters
%
% D is a windowed view of your fNIRS data. Use only the most recent k samples
% - D       + Data tensor sized <nSamples, nChannels, nHb>.
% - Aobs    + The observed connectivity matrix
%
%% Output Parameters
%
% - val     + Apply the AND function across Hb species.
%
%%
    DQ = zeros(1, 2);
    DQ(1,1)=D(1,1);
    DQ(1,2)=D(1,2);


    DH = zeros(1,2);
    DH(1,1)=D(1,3);
    DH(1,2)=D(1,4);

    
    rThresh= 0.2; % [0..1] A threshold on the correlation.

    [nSamples, nChannels, nHb]=size(DQ);
    disp(size(DQ));

    C = nan(nChannels, nChannels, nHb); %Matrix of channel pairwise correlations;

    %This part of the algorithm is HIGHLY inefficient but it does the job for now
    %but might not be sufficiently fast for "real time" neurofeedback

    for iHb = 1:nHb

        for iCh=1:nChannels

            for jCh=iCh:nChannels

                if iCh == jCh
                    
                 C(iCh,jCh,iHb) = 1;
                 disp(C)

               else

                 C(iCh,jCh,iHb) = xcorr2(DQ(:,iCh,iHb),DQ(:,jCh,iHb));
                 disp(C)

                end
                
            end

        end

    end

    %Threshold/Binarize C
    tmp = C > rThresh;
    %Finally "merge" accross Hb species

    val = all(tmp,3); %Apply the AND function across Hb species.
    disp(val)

end

