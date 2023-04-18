x = 1;
i=0;
Bt = [-0.02, -0.77; 0.33, -1.31];
while x==1
 dB = (1-(-1.5)).*rand(3,3) + (-1.5);
 if(det(dB) >= det(Bt)  && det(dB) <= 0.7)
     disp(dB)
    i = i + 1;
 end
 if i == 9
     x=0;
 end
end