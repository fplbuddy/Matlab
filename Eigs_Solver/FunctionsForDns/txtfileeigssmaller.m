function txtfileeigssmaller(Data,Ra, Pr,ARS,type)
    % Getting data
    kappa = sqrt((pi)^3/(Ra*Pr));
    RaS = RatoRaS(Ra);
    PrS = PrtoPrS(Pr);
    typeF = convertStringsToChars(type); typeF = typeF(7:end);
    N = str2num(typeF);
    % get the vectors and adding them in the approprate way
    Eigv =  Data.(ARS).(type).(PrS).(RaS).Eigv;
    Eigvconj =  Data.(ARS).(type).(PrS).(RaS).Eigvconj;
    % need to find location of 0,1 and then look either side of this to get
    % phase
    n = [(-N/2):2:(N/2-1) (-N/2+1):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:); 
    m = 1:N; m = repelem(m, N/2);
    [~,~,n,~] = GetRemGeneral(n,m,N);
    Izo = find(n == 0); Izo = Izo(1);
    len = length(Eigv);
    PhasesToTry = [(-real(Eigv(Izo-1))+1i*imag(Eigv(Izo-1)))/Eigvconj(Izo-1) conj(Eigv(Izo-1))/Eigvconj(Izo-1)];
    got = 0;
    for i=1:length(PhasesToTry)
        Phase = PhasesToTry(i);
        EigvconjTest = Eigvconj*Phase;
        vectortest = Eigv + EigvconjTest;
        if abs(vectortest(Izo-1) - conj(vectortest(Izo+1))) < 1e-5 && abs(vectortest(Izo-1+len/2) - conj(vectortest(Izo+1+len/2))) < 1e-5
            got = 1;
            break
        end
    end
    if got == 1
        vector = vectortest;
    else
        Error
    end
    PsiV = vector(1:length(vector)/2)*kappa;
    ThetaV = vector(length(vector)/2+1:end);
    vector = [PsiV; ThetaV];
    vector = vector/norm(vector); % rescaling
    PsiV = vector(1:length(vector)/2);
    ThetaV = vector(length(vector)/2+1:end);
    % Remove conjugates
    Rem = [];
    for i=1:length(n)
       ninst = n(i); 
       if ninst < 0 % checking if conj
           Rem = [Rem i];
       end    
    end
    PsiV(Rem) = [];
    ThetaV(Rem) = [];
    % Expand fields
    n = [0:2:(N/2-1) 1:2:(N/2-1)]; n = repmat(n, N/2); n = n(1,:);
    m = 1:N; m = repelem(m, N/4);
    [Rem,~,~,~] = GetRemGeneral(n,m,N);
    [PsiV, ThetaV] = ExpandFields(Rem, PsiV, ThetaV);
    % making dir
    folder = ['/Volumes/Samsung_T5/EigenVec/' convertStringsToChars(ARS) '/' typeF 'x' typeF '/' convertStringsToChars(PrS) '/' convertStringsToChars(RaS)];
    if ~exist(folder, 'dir')
       mkdir(folder)
    end
    % storing values
    Out1 = zeros(length(PsiV)*2,1); % Real and imaginary values
    Out2 = zeros(length(PsiV)*2,1); % Real and imaginary values
    for i=1:2:length(PsiV)*2
        Out1(i) = real(PsiV((i+1)/2));
        Out1(i+1) = imag(PsiV((i+1)/2));
        Out2(i) = real(ThetaV((i+1)/2));
        Out2(i+1) = imag(ThetaV((i+1)/2));  
    end
    % removing very small values
    thres = 1e-12;
    Out1(abs(Out1)<thres) = 0;
    Out2(abs(Out2)<thres) = 0;
    writematrix(Out1,[folder '/PsiV.txt'],'Delimiter','tab')
    writematrix(Out2,[folder '/ThetaV.txt'],'Delimiter','tab')
end
