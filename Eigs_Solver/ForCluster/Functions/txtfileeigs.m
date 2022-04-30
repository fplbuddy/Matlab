function txtfileeigs(Data,Ra, Pr,ARS,type,eigtype)
    % Getting data
    kappa = sqrt((pi)^3/(Ra*Pr));
    RaS = RatoRaS(Ra);
    PrS = PrtoPrS(Pr);
    typeF = convertStringsToChars(type); typeF = typeF(7:end);
    N = str2num(typeF);
    vector = Data.(ARS).(type).(PrS).(RaS).(eigtype);
    PsiV = vector(1:length(vector)/2)*kappa;
    ThetaV = vector(length(vector)/2+1:end);
    vector = [PsiV; ThetaV];
    vector = vector/norm(vector); % rescaling
    PsiV = vector(1:length(vector)/2);
    ThetaV = vector(length(vector)/2+1:end);
    % Remove conjugates
    n = [(-N/2):2:(N/2-1) (-N/2+1):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:); 
    m = 1:N; m = repelem(m, N/2);
    [~,~,n,~] = GetRemGeneral(n,m,N);
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
    thres = 1e-13;
    Out1(abs(Out1)<thres) = 0;
    Out2(abs(Out2)<thres) = 0;
    writematrix(Out1,[folder '/PsiV.txt'],'Delimiter','tab')
    writematrix(Out2,[folder '/ThetaV.txt'],'Delimiter','tab')
end
