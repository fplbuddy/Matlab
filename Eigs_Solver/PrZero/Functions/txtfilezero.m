function txtfilezero(PrZeroData,RaA, Pr,type,G)
    % Getting data
    RaC = RaCfunc(G); % not good for different aspect ratios
    GS = GtoGS(G);
    Ra = RaA + RaC;
    kappa = sqrt((pi)^3/(Ra*Pr));
    RaAS = RaAtoRaAS(RaA);
    PrS = PrtoPrSZero(Pr);
    PsiE = PrZeroData.(GS).(type).(PrS).(RaAS).PsiE*kappa;
    ThetaE = PrZeroData.(GS).(type).(PrS).(RaAS).ThetaE;
    % making dir
    typeF = convertStringsToChars(type); typeF = typeF(3:end);
    folder = ['/Volumes/Samsung_T5/SteadyStates/' GS '/' typeF 'x' typeF '/' convertStringsToChars(PrS) '/' convertStringsToChars(RaAS)];
    if ~exist(folder, 'dir')
       mkdir(folder)
    end
    % expand
    N = str2num(typeF);
    n = [1:2:(N/2-1) 0:2:(N/2-2)]; n = repmat(n, N/2); n = n(1,:);
    m = 1:N; m = repelem(m, N/4);
    [Rem,~,~,~] = GetRemGeneral_nxny(n,m,N,N);
    [PsiE, ThetaE] = ExpandFields(Rem, PsiE, ThetaE);
    % storing values
    Out1 = zeros(length(PsiE)*2,1); % Real and imaginary values
    Out2 = zeros(length(PsiE)*2,1); % Real and imaginary values
    for i=1:2:length(PsiE)*2
        Out1(i) = real(PsiE((i+1)/2));
        Out1(i+1) = imag(PsiE((i+1)/2));
        Out2(i) = real(ThetaE((i+1)/2));
        Out2(i+1) = imag(ThetaE((i+1)/2));  
    end
    writematrix(Out1,[folder '/PsiE.txt'],'Delimiter','tab')
    writematrix(Out2,[folder '/ThetaE.txt'],'Delimiter','tab')
end

