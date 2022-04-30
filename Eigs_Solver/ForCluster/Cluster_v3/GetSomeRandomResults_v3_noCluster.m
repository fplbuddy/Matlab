Treads = 1;
maxNumCompThreads(Treads);
maxNumCompThreads(Treads);
% Adding the extra functions we want
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
addpath(fpath)
% Loading in the old data
dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
load(dpath);
% constants
N = 172;
G = 2;
AR = ['AR_' num2str(G)];
type = ['OneOne' num2str(N)];
% spath = '/Volumes/Samsung_T5/SomeStencils/';
% load([spath 'NL_' num2str(N)])
Pr_list = [8];
Ra_list = [1.41e6];
tic
for i=1:length(Pr_list)
    Pr = Pr_list(i);
    PrS = PrtoPrS(Pr);
    % Getting ICs
    for j = 1:length(Ra_list)
        try
            RaSold = RaS;        
            Ra = Ra_list(j);
            RaS = RatoRaS(Ra);
            % adding some stuff which will correct jump
            Data.(AR).(type).(PrS).(RaS).LJ = Data.(AR).(type).(PrS).(RaSold).TJ;
            Data.(AR).(type).(PrS).(RaS).Deltaeven = sigmaevennew - sigmaevenold;
            Data.(AR).(type).(PrS).(RaS).Deltaodd = sigmaoddnew - sigmaoddold; 
        catch
            Ra = Ra_list(j);
            RaS = RatoRaS(Ra);  
        end
        try ngot = not(isfield(Data.(AR).(type).(PrS), RaS)); catch, ngot = 1; end
        if ngot % If we need to do NR or not
            [PsiE, ThetaE] = GetIC(Ra, Pr, Data, AR, type);
            [PsiE, ThetaE, dxmin] = NR(PsiE, ThetaE, N, G, Ra, Pr);%, NL);
        else
            ThetaE = Data.(AR).(type).(PrS).(RaS).ThetaE;
            PsiE = Data.(AR).(type).(PrS).(RaS).PsiE;
        end
        [sigmaevenold,xeven, sigmaoddold,xodd, Raold] = GetClosestEigs(Data,N,Pr,Ra, AR);
        % Correcting the jumps with delta
        Data.(AR).(type).(PrS).(RaS).TJ = Ra/Raold; % Adding TJ to current
        try
            fact = Data.(AR).(type).(PrS).(RaS).TJ/Data.(AR).(type).(PrS).(RaS).LJ %LJ has been added before
        catch % Hacky way to add the things we need for factor corection
            RaS_list2 = string(fields(Data.(AR).(type).(PrS)));
            RaS_list2 = OrderRaS_list(RaS_list2);
            I = find(RaS_list2 == RaS);
            Data.(AR).(type).(PrS).(RaS).LJ = Data.(AR).(type).(PrS).(RaS_list2(I-1)).TJ;
            Data.(AR).(type).(PrS).(RaS).Deltaeven = Data.(AR).(type).(PrS).(RaS_list2(I-1)).sigmaevenbranch - Data.(AR).(type).(PrS).(RaS_list2(I-2)).sigmaevenbranch;
            Data.(AR).(type).(PrS).(RaS).Deltaodd = Data.(AR).(type).(PrS).(RaS_list2(I-1)).sigmaoddbranch - Data.(AR).(type).(PrS).(RaS_list2(I-2)).sigmaoddbranch;         
        end
        stop
        sigmaevenstart = sigmaevenold+fact*Data.(AR).(type).(PrS).(RaS).Deltaeven;
        sigmaoddstart = sigmaoddold+fact*Data.(AR).(type).(PrS).(RaS).Deltaodd;        
        % Solving odd problem
        M = MakeMatrixForOddProblem(N,G, PsiE, ThetaE, Ra, Pr);
        [xodd,sigmaoddnew] = eigs(M,1,sigmaoddstart,'StartVector', xodd,'Tolerance',1e-10);
        % Solve even problem
        clear M
        M = MakeMatrixForEvenProblem(N,G, PsiE,ThetaE, Ra, Pr);
        [xeven, sigmaevennew] = eigs(M,1,sigmaevenstart,'StartVector', xeven,'Tolerance',1e-10);
        clear M
        % Saving the data
        if not(isfield(Data.(AR).(type).(PrS), RaS))
            Data.(AR).(type).(PrS).(RaS).Ra = Ra;
            Data.(AR).(type).(PrS).(RaS).Pr = Pr;
            Data.(AR).(type).(PrS).(RaS).dxmin = dxmin;
            Data.(AR).(type).(PrS).(RaS).PsiE = PsiE;
            Data.(AR).(type).(PrS).(RaS).ThetaE = ThetaE;
            Data.(AR).(type).(PrS).(RaS).sigmaoddbranch = sigmaoddnew;
            Data.(AR).(type).(PrS).(RaS).sigmaevenbranch = sigmaevennew;
            Data.(AR).(type).(PrS).(RaS).xoddbranch = xodd;
            Data.(AR).(type).(PrS).(RaS).xevenbranch = xeven;
        else
            if not(isfield(Data.(AR).(type).(PrS).(RaS), 'sigmaoddbranch'))
                Data.(AR).(type).(PrS).(RaS).sigmaoddbranch = sigmaoddnew;
                Data.(AR).(type).(PrS).(RaS).sigmaevenbranch = sigmaevennew;
                Data.(AR).(type).(PrS).(RaS).xoddbranch = xodd;
                Data.(AR).(type).(PrS).(RaS).xevenbranch = xeven;
%             else
%                 Data.(AR).(type).(PrS).(RaS).sigmaoddbranch = [sigmaoddnew Data.(AR).(type).(PrS).(RaS).sigmaoddbranch];
%                 Data.(AR).(type).(PrS).(RaS).sigmaevenbranch = [sigmaevennew Data.(AR).(type).(PrS).(RaS).sigmaevenbranch];
%                 Data.(AR).(type).(PrS).(RaS).xoddbranch = [xodd Data.(AR).(type).(PrS).(RaS).xoddbranch];
%                 Data.(AR).(type).(PrS).(RaS).xevenbranch = [xeven Data.(AR).(type).(PrS).(RaS).xevenbranch];
             end            
        end
        
    end
end
toc