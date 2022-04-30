addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrActuallyZero/Functions');
addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions');
addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrZero/Functions');
dpath = '/Volumes/Samsung_T5/OldData/PrAZero.mat';
load(dpath)
%%
Nx = 32;
Ny = 16;
RaA = 1e-1; RaAS = RaAtoRaAS(RaA);
%Amp_list = 1i*round(logspace(0,2,10),1,'significant');
Amp_list = 1i*(17:0.1:18);
G = 2;
GS = ['G_' num2str(G)];
type = ['N_' num2str(Nx) 'x' num2str(Ny)];
for i=1:length(Amp_list)
    RaC =  RaCfunc(G);
    Ra = RaC + RaA;
    Amp = Amp_list(i);
    AmpS = AmptoAmpS(imag(Amp));
    M = MakeMatrix_paz_v1(Amp,Ra,G,Nx,Ny);
    [eigv,sigma] = eig(M);
    sigma = diag(sigma);
    [~,I] = max(real(sigma));
    eigv =  eigv(:,I);
    PrAZero.(type).(GS).(RaAS).(AmpS).sigma = sigma;
    PrAZero.(type).(GS).(RaAS).(AmpS).eigv = eigv;
    PrAZero.(type).(GS).(RaAS).(AmpS).Amp = Amp;
end

%% make real plot
% AmpS_list = string(fields(PrAZero.AR_2_8.(RaS)));
% for i=1:length(AmpS_list)
%     Amp = Amp_list(i);
%     AmpS = AmptoAmpS(imag(Amp));
%     rsigma = real(PrAZero.AR_2_8.(RaS).(AmpS).sigma);
%     [r,I] = max(rsigma);
%     real1(i) = r;
%     rsigma(I) = [];
%     [r,I] = max(rsigma);
%     real2(i) = r;
%     rsigma(I) = [];
%     [r,I] = max(rsigma);
%     real3(i) = r;
%     rsigma(I) = [];
% end

save(dpath,"PrAZero")

