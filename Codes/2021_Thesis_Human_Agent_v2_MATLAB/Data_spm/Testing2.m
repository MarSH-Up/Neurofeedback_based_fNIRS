A = [-0.16 -0.49; -0.02 -0.33];
B = [-0.02 -0.77; 0.33 -1.31];
C = [0.08 0; 0.06 0];
step = 10;

U = [1;1];
Zt = [0.01;0.01];

nRegions  = size(A,1);
T = zeros(nRegions);
for uu = 1:2
    tmp = U(uu) * B(uu,uu);
    T = -0.5*exp(T + tmp);
end
Zdot = (A + T) * Zt + C * U;

Z = Zt + step * Zdot;

ZM1 = Z(1);
ZSMA = Z(2);
disp(ZM1);