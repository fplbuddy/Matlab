Treads = 1;
maxNumCompThreads(Treads);
maxNumCompThreads(Treads);
% Adding the extra functions we want
%fpath = '/mi/share/scratch/winchester/Matlab/Eigs/';
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions';
addpath(fpath)
% Loading in the old data
%dpath = '/home/winchester/MatlabDatatop/Data/masternew.mat';
dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
%spath = [pwd '/NewData.mat'];
load(dpath);
NewData = Data;
clear Data;
% constants
N = 400;
G = 2;
AR = ['AR_' num2str(G)];
type = ['OneOne' num2str(N)];
Pr_list = [7e5];
for i=1:length(Pr_list)
   Pr = Pr_list(i);
   PrS = PrtoPrS(Pr);
   % Get conj for zonal first
   A = GetFullMZonal(NewData, PrS);
   [~,Ra] = GetNextRaNonLinear(A);
   RaS = RatoRaS(Ra);
   sigmaoddguess = conj(NewData.(AR).(type).(PrS).(RaS).sigmaoddZ); 
   sigmaoddguess = 1.1*real(sigmaoddguess) + 1i*1.1*imag(sigmaoddguess); % move away from it a little
   EigvZ = NewData.(AR).(type).(PrS).(RaS).EigvZ;
   EigvZ = [conj(EigvZ(1:length(EigvZ)/2)); -real(EigvZ(length(EigvZ)/2+1:end)) + 1i*imag(EigvZ(length(EigvZ)/2+1:end))];
   ThetaE = NewData.(AR).(type).(PrS).(RaS).ThetaE;
   PsiE = NewData.(AR).(type).(PrS).(RaS).PsiE;
   'Start Zonal'
   M = MakeMatrixForOddProblem2(N,G, PsiE, ThetaE, Ra, Pr);
   [EigvZconj,sigmaoddZconj] = eigs(M,1,sigmaoddguess,'StartVector', EigvZ,'Tolerance',1e-10);
   NewData.(AR).(type).(PrS).(RaS).sigmaoddZconj = sigmaoddZconj;
   NewData.(AR).(type).(PrS).(RaS).EigvZconj = EigvZconj;
   save(spath,'NewData')
   'Done Zonal'
   % non zonal first
   A = GetFullMNonZonal(NewData, PrS);
   RaOld = Ra;
   [~,Ra] = GetNextRaNonLinear(A);
   RaS = RatoRaS(Ra);
   sigmaoddguess = conj(NewData.(AR).(type).(PrS).(RaS).sigmaoddNZ); 
   sigmaoddguess = 1.1*real(sigmaoddguess) + 1i*1.1*imag(sigmaoddguess); % move away from it a little
   EigvNZ = NewData.(AR).(type).(PrS).(RaS).EigvNZ;
   EigvNZ = [conj(EigvNZ(1:length(EigvNZ)/2)); -real(EigvNZ(length(EigvNZ)/2+1:end)) + 1i*imag(EigvNZ(length(EigvNZ)/2+1:end))];
   if Ra ~= RaOld % checking that we dont already have M
       clear M
       ThetaE = NewData.(AR).(type).(PrS).(RaS).ThetaE;
       PsiE = NewData.(AR).(type).(PrS).(RaS).PsiE;
       M = MakeMatrixForOddProblem2(N,G, PsiE, ThetaE, Ra, Pr);
   end
   [EigvNZconj,sigmaoddNZconj] = eigs(M,1,sigmaoddguess,'StartVector', EigvNZ,'Tolerance',1e-10);
   NewData.(AR).(type).(PrS).(RaS).sigmaoddNZconj = sigmaoddNZconj;
   NewData.(AR).(type).(PrS).(RaS).EigvNZconj = EigvNZconj;
   save(spath,'NewData')
end