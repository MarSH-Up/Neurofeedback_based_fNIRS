function [Bt] = BilinearModel_DynamicB(B, nRegions, U)
    %% Version V1
    Thershold = 0.2;
    if(U < Thershold) %Random Ucontrol to test
        min = -2; 
        max = 2;
        n = nRegions;
        r1 = min + rand(n)*(max-min);
        r2 = min + rand(n)*(max-min);
        Bt(:,:,1) = r1(:,:);
        Bt(:,:,2) = r2(:,:);
    else
       Bt = B(:,:,:);
    end
end

