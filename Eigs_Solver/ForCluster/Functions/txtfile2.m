function txtfile2(Data,Ra, Pr,ARS,type)
    % Getting data
    kappa = sqrt((pi)^3/(Ra*Pr));
    RaS = RatoRaS(Ra);
    PrS = PrtoPrS(Pr);
    PsiE = Data.(ARS).(type).(PrS).(RaS).PsiE*kappa;
    ThetaE = Data.(ARS).(type).(PrS).(RaS).ThetaE;
    typeF = convertStringsToChars(type); typeF = typeF(7:end);
    % Expand fields if needed
    N = str2num(typeF);
    if length(PsiE) < N^2/4 % then we need to expand
        n = [1:2:(N/2-1) 0:2:(N/2-2)]; n = repmat(n, N/2); n = n(1,:);
        m = 1:N; m = repelem(m, N/4);
        [Rem,~,~,~] = GetRemGeneral(n,m,N);
        [PsiE, ThetaE] = ExpandFields(Rem, PsiE, ThetaE);
    end  
    % making dir
    folder = ['/Volumes/Samsung_T5/SteadyStates/' convertStringsToChars(ARS) '/' typeF 'x' typeF '/' convertStringsToChars(PrS) '/' convertStringsToChars(RaS)];
    if ~exist(folder, 'dir')
       mkdir(folder)
    end
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