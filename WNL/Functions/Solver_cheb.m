function [A,phi] = Solver_cheb(A0,phi0,tmax,r,As,sigmas,Fs,eps)
addpath('/Users/philipwinchester/Dropbox/Matlab/chebfun-master');
N = chebop(0,tmax);
% N.op = @(t,A,phi) [ ...
%      -diff(A)-exp(phi*2)*interp1(As,Fs,A)+r*A-A.^3
%      -diff(phi)-interp1(As,sigmas,A)/eps^2];
N.op = @(t,A,phi) [ ...
     -diff(A)-exp(phi*2)*tanh(A)+r*A-A.^3
     -diff(phi)/eps^2];
N.lbc = @(A,phi) [A-A0; phi-phi0];
[A,phi] = N\0;
end



