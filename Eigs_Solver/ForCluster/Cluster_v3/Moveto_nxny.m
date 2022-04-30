% Treads = 1;
% maxNumCompThreads(Treads);
% maxNumCompThreads(Treads);
% % Adding the extra functions we want
% fpath = '/mi/share/scratch/winchester/Matlab/Eigs/';
% addpath(fpath)
% % Loading in the old data
% dpath = '/home/winchester/MatlabDatatop/Data/masternew.mat';
% spath = [pwd '/NewData.mat'];
% load(dpath);
% NewData = Data;
% clear Data;
% constants
Nx = 512;
Ny = 128;
N = 400;
G = 2;
AR = ['AR_' num2str(G)];
type = ['OneOne' num2str(Nx)];
Pr = 4e5;
Ra = 2.55e7;
PrS = PrtoPrS(Pr);
RaS = RatoRaS(Ra);
thres = 1e-14;


PsiEold = NewData.(AR).OneOne400.(PrS).(RaS).PsiE;
ThetaEold = NewData.(AR).OneOne400.(PrS).(RaS).ThetaE;
[~,~,nold,mold] = GetRemKeep(N,1);
[~,~,n,m] = GetRemKeep_nxny(Nx,Ny,1);
PsiE = zeros(length(n), 1);
ThetaE = zeros(length(n), 1);
for i=1:length(nold)
    noldinst = nold(i); moldinst = mold(i);
    for j=1:length(n)
        ninst = n(j); minst = m(j);
        if ninst == noldinst && minst == moldinst
            PsiE(j) = PsiEold(i);
            ThetaE(j) = ThetaEold(i);
         break
        end
    end
end
[PsiE, ThetaE, dxmin] = NR2_nxny(PsiE, ThetaE, Nx,Ny, G, Ra, Pr, thres);%, NL);
NewData.(AR).(type).(PrS).(RaS).Ra = Ra;
NewData.(AR).(type).(PrS).(RaS).Pr = Pr;
NewData.(AR).(type).(PrS).(RaS).dxmin = dxmin;
NewData.(AR).(type).(PrS).(RaS).PsiE = PsiE;
NewData.(AR).(type).(PrS).(RaS).ThetaE = ThetaE;

%save(spath,'NewData');
