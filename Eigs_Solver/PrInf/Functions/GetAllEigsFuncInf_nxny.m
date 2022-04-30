function Data = GetAllEigsFuncInf_nxny(Data,Ra,Nx,Ny,G,thres,getEigv,searchType,O,E)
AR = ['AR_' strrep(num2str(G),'.','_')];
type = ['N_' num2str(Nx) 'x' num2str(Ny)];
RaS = RatoRaS(Ra);
try ngot = not(isfield(Data.(AR).(type), RaS)); catch, ngot = 1; end
if ngot % If we need to do NR or not
    ThetaE = GetICinf_nxny(Ra, Data, AR, type,searchType);
    [ThetaE, dxmin] = NR3inf_nxny(ThetaE, Nx, Ny,G, Ra,thres);
    Data.(AR).(type).(RaS).Ra = Ra;
    Data.(AR).(type).(RaS).dxmin = dxmin;
    Data.(AR).(type).(RaS).ThetaE = ThetaE;
else
    ThetaE = Data.(AR).(type).(RaS).ThetaE;
end
if O
    % Solving odd problem
    M = MakeMatrixForOddProblem2inf_nxny(Nx,Ny,G, ThetaE, Ra);
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
        Data.(AR).(type).(RaS).Eigvodd = Eigv;
        clear Eigv
    end
    sigmaoddr = real(sigmaodd);
    sigmaodd(sigmaoddr < -200) = [];
    Data.(AR).(type).(RaS).sigmaodd = sigmaodd;
end
if E
    % Solving even problem
    M = MakeMatrixForEvenProblem2inf_nxny(Nx,Ny,G, ThetaE, Ra);
    if not(getEigv)
        sigmaeven = eig(M);
        clear M
        % remove origion eig
        small = abs(sigmaeven)<1e-8;
        small = find(small == 1);
        if length(small) > 1
            'There are more than one thing we are removing'
            stop
        else
            sigmaeven(small) = [];
        end
    else
        [Eigv,sigmaeven] = eig(M);
        clear M
        sigmaeven = diag(sigmaeven);
        % remove origion eig
        small = abs(sigmaeven)<1e-8;
        small = find(small == 1);
        if length(small) > 1
            'There are more than one thing we are removing'
            stop
        else
            sigmaeven(small) = [];
            Eigv(:,small) = [];
        end
        [~,indices] = sort(real(sigmaeven),'descend');
        % getting location of most unstable eigenvalue
        Eigv = Eigv(:,indices(1));
        Data.(AR).(type).(RaS).Eigveven = Eigv;
        clear Eigv
    end
    sigmaevenr = real(sigmaeven);
    sigmaeven(sigmaevenr < -200) = [];
    Data.(AR).(type).(RaS).sigmaeven = sigmaeven;
end
end
