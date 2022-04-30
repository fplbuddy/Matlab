% Treads = 1;
% maxNumCompThreads(Treads);
% maxNumCompThreads(Treads);
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
Nx = 152;
Ny = 152;
G = 2;
AR = ['AR_' num2str(G)];
type = ['OneOne' num2str(Nx)];
Pr_list = [20];
Ra_list = [3e4 1e5];
thres = 1e-14;
getEigv = 0;
WO = 1;
WE = 0;
tic
for i=1:length(Pr_list)
    Pr = Pr_list(i)
    PrS = PrtoPrS(Pr);
    for j = 1:length(Ra_list)
        Ra = Ra_list(j)
        RaS = RatoRaS(Ra);
        try ngot = not(isfield(NewData.(AR).(type).(PrS), RaS)); catch, ngot = 1; end
        if ngot % If we need to do NR or not
            [PsiE, ThetaE] = GetIC(Ra, Pr, NewData, AR, type);
            [PsiE, ThetaE, dxmin] = NR2_nxny(PsiE, ThetaE, Nx,Ny, G, Ra, Pr, thres);%, NL);
            NewData.(AR).(type).(PrS).(RaS).Ra = Ra;
            NewData.(AR).(type).(PrS).(RaS).Pr = Pr;
            NewData.(AR).(type).(PrS).(RaS).dxmin = dxmin;
            NewData.(AR).(type).(PrS).(RaS).PsiE = PsiE;
            NewData.(AR).(type).(PrS).(RaS).ThetaE = ThetaE;
        else
            ThetaE = NewData.(AR).(type).(PrS).(RaS).ThetaE;
            PsiE = NewData.(AR).(type).(PrS).(RaS).PsiE;
        end
        %save(spath,'NewData');
        if WO
            % Solving odd problem
            M = MakeMatrixForOddProblem2_nxny(Nx,Ny,G, PsiE, ThetaE, Ra, Pr);
            if getEigv
                [Eigv,sigmaodd] = eig(M);
                clear M
                sigmaodd = diag(sigmaodd);
                [~,indices] = sort(real(sigmaodd),'descend');
                % getting location of most unstable eigenvalue
                Eigvnotconj = Eigv(:,indices(1));
                Eigvconj = Eigv(:,indices(2));
                clear Eigv
                sigmaodd(real(sigmaodd) < -200) = [];
                NewData.(AR).(type).(PrS).(RaS).sigmaodd = sigmaodd;
                NewData.(AR).(type).(PrS).(RaS).Eigv = Eigvnotconj;
                NewData.(AR).(type).(PrS).(RaS).Eigvconj = Eigvconj;
            else
                sigmaodd = eig(M);
                sigmaodd(real(sigmaodd) < -200) = [];
                clear M
                NewData.(AR).(type).(PrS).(RaS).sigmaodd = sigmaodd;
            end
        end
        %save(spath,'NewData');
        if WE
            M = MakeMatrixForEvenProblem2_nxny(Nx,Ny,G, PsiE, ThetaE, Ra, Pr);
            if getEigv
                [Eigv,sigmaeven] = eig(M);
                clear M
                sigmaeven = diag(sigmaeven);
                [~,indices] = sort(real(sigmaeven),'descend');
                % getting location of most unstable eigenvalue
                Eigvnotconje = Eigv(:,indices(1));
                Eigvconje = Eigv(:,indices(2));
                clear Eigv
                sigmaeven(real(sigmaeven) < -200) = [];
                NewData.(AR).(type).(PrS).(RaS).sigmaeven = sigmaeven;
                NewData.(AR).(type).(PrS).(RaS).Eigve = Eigvnotconje;
                NewData.(AR).(type).(PrS).(RaS).Eigvconje = Eigvconje;
            else
                sigmaeven = eig(M);
                sigmaeven(real(sigmaeven) < -200) = [];
                clear M
                NewData.(AR).(type).(PrS).(RaS).sigmaeven = sigmaeven;
            end
            
        end
        %save(spath,'NewData');
    end
end
toc
%save(spath,'NewData');
