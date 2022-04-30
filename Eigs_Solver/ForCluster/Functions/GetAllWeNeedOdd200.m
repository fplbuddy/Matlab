function [sigmaodd,xodd, M] = GetAllWeNeedOdd200(Data,N,Pr,Ra, AR,PsiE,ThetaE,G)
    % At a first instance, we should look at 172
    RaS = RatoRaS(Ra);
    PrS = PrtoPrS(Pr);
    M = MakeMatrixForOddProblem(N,G, PsiE, ThetaE, Ra, Pr); % The matrix
    [M,rem] = CleanEigenMatrix(M, N,"odd",0);
    try
        sigmaodd = Data.(AR).OneOne172.(PrS).(RaS).sigmaoddbranch; % Assuming 172 here
        xodd = ExpandEigenFunc(Data.(AR).OneOne172.(PrS).(RaS).xoddbranch,172, N,'o');
        % clean
        xodd(rem) = [];
    catch % If we have not get it, then we assume that we are looking for the crossing
        D = GetM(NewData, PrS, "OneOne200", AR,1, 1,"odd", 1);
        RaBef = D(1,1);
        RaBefS = RatoRaS(RaBef);
        xodd = Data.(AR).OneOne200.(PrS).(RaBefS).xoddbranch;
        
        TJ = Ra/RaBef;
        sigmaodd =  Data.(AR).OneOne200.(PrS).(RaBefS).sigmaoddbranch;
        sigmaodd = imag(sigmaodd)*TJ*1i; % Assuming that we are looking for crossing, so real part is 0.
    end
end

