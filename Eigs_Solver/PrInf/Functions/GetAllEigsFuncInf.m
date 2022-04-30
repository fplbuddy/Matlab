function Data = GetAllEigsFuncInf(Data,Ra,N,G,thres,getEigv,searchType)
AR = ['AR_' strrep(num2str(G),'.','_')];
type = ['N_' num2str(N)];
RaS = RatoRaS(Ra);
try ngot = not(isfield(Data.(AR).(type), RaS)); catch, ngot = 1; end
if ngot % If we need to do NR or not
    ThetaE = GetICinf(Ra, Data, AR, type,searchType);
    [ThetaE, dxmin] = NR3inf(ThetaE, N, G, Ra,thres);
    Data.(AR).(type).(RaS).Ra = Ra;
    Data.(AR).(type).(RaS).dxmin = dxmin;
    Data.(AR).(type).(RaS).ThetaE = ThetaE;
else
    ThetaE = Data.(AR).(type).(RaS).ThetaE;
end
% Solving odd problem
M = MakeMatrixForOddProblem2inf(N,G, ThetaE, Ra);
if not(getEigv)
    sigmaodd = eig(M);
    clear M
else
    [Eigv,sigmaodd] = eig(M);
    clear M
    sigmaodd = diag(sigmaodd);
    [~,indices] = sort(real(sigmaodd),'descend');
    % getting location of most unstable eigenvalue
    Eigv = Eigv(:,indices(1));
    Data.(AR).(type).(PrS).(RaS).Eigv = Eigv;
    clear Eigv
end
sigmaoddr = real(sigmaodd);
sigmaodd(sigmaoddr < -200) = [];
Data.(AR).(type).(RaS).sigmaodd = sigmaodd;
end
