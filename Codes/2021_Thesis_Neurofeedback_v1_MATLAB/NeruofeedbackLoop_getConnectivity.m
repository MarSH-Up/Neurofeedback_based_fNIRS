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
%% https://www.statlect.com/fundamentals-of-probability/linear-correlation
    
    rThresh= 0.4; % [0..1] A threshold on the correlation.

    [nSamples, nChannels, nHb]=size(D);
    disp(size(D));

    C = nan(nChannels, nChannels, nHb); %Matrix of channel pairwise correlations;

    %This part of the algorithm is HIGHLY inefficient but it does the job for now
    %but might not be sufficiently fast for "real time" neurofeedback

    for iHb = 1:nHb

        for iCh=1:nChannels

            for jCh=iCh:nChannels

                if iCh == jCh
                    
                 C(iCh,jCh,iHb) = 1;
                 disp('iCh == jCh')
                 disp(C(iCh,jCh,iHb));

               else

                 C(iCh,jCh,iHb) = corr(D(:,iCh,iHb),D(:,jCh,iHb));
                 disp('else')
                 disp(C(iCh,jCh,iHb));

                end
            end

        end

    end

    %Threshold/Binarize C

    tmp = C > rThresh;

    %Finally "merge" accross Hb species

    val = all(tmp,3); %Apply the AND function across Hb species.

end

