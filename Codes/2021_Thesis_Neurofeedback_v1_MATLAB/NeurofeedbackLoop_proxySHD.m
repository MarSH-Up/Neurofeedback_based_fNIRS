function [val, matrix] = NeurofeedbackLoop_proxySHD(H,G)
%% Version V1
% Authors - Mario De Los Santos, Felipe Orihuela-Espina, Javier Herrara-Vega
% Date - July 17th, 2021
% Email - madlsh3517@gmail.com
%
%   Naive model
%
%% Input Parameters
%
% - H       + Adjacency matrix (binary) of the observed graph
% - G       + Adjacency matrix (binary) of the reference graph
%
%% Output Parameters
%
% - matrix  + XOR between H and G
% - val     + Sum of the XOR relations between H and G
%
%%
    val = sum(sum(xor(H,G)));
    matrix = xor(H,G);

end