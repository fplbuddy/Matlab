function txtfile2(Data,RaA, Pr,G,type,addeig,frac)
% Getting data
RaC = pi^4*(4+G^2)^3/(4*G^4);
Ra = RaC + RaA;
GS = GtoGS(G);
kappa = sqrt((pi)^3/(Ra*Pr));
RaAS = RaAtoRaAS(RaA);
if Pr < 1e-4
    PrS = PrtoPrSZero(Pr);
else
    PrS = PrtoPrS(Pr);
end
PsiE = Data.(GS).(type).(PrS).(RaAS).PsiE*kappa;
ThetaE = Data.(GS).(type).(PrS).(RaAS).ThetaE;
% check if we want to add eigenfunction to the
[Nx,Ny] = typetoNxNy(type);
if addeig
    n = [(-Nx/2):(Nx/2-1)]; n = repmat(n, Ny);  n = n(1,:);
    m = 1:Ny; m = repelem(m, Nx);
    [~,~,n,~] = GetRemGeneral_nxny(n,m,Nx,Ny);
    eigenvec = Data.(GS).(type).(PrS).(RaAS).eigv;
    PsiEadd = eigenvec(1:length(n))*kappa;
    ThetaEadd = eigenvec(length(n)+1:end);
    % remove conjugates
    Rem = [];
    for i=1:length(n)
        ninst = n(i);
        if ninst < 0 % checking if conj
            Rem = [Rem i];
        end
    end
    PsiEadd(Rem) = [];
    ThetaEadd(Rem) = [];
    % get the real and imag bit that we want, psi_o real, psi_e comp,
    % opposite for theta
    [~,~,n,m,~] = GetRemKeepnss_nxny(Nx,Ny);
    for i=1:length(n)
        ninst = n(i); minst = m(i);
        if rem(ninst+minst,2) == 0 % even
           PsiEadd(i) = imag(PsiEadd(i));
           ThetaEadd(i) = real(ThetaEadd(i));
        else % odd
            PsiEadd(i) = real(PsiEadd(i));
           ThetaEadd(i) = imag(ThetaEadd(i));    
        end
    end
    
    
    % now 0,1 should be in first entry, and we use this to define scaling
    fact = frac*PsiE(1)/PsiEadd(1); % frac is the percentage of 0,1 we want, and it get scalled down
    PsiEadd = fact*PsiEadd;
    ThetaEadd = fact*ThetaEadd;
    % combine it to what we alrady have
    PsiE = PsiE + PsiEadd;
    ThetaE = ThetaE + ThetaEadd;
end

% making dir
folder = ['/Volumes/Bamsung_T5/OtherSteadyStates/' GS '/'  num2str(Nx) 'x'  num2str(Ny) '/' convertStringsToChars(PrS) '/' convertStringsToChars(RaAS)];
if ~exist(folder, 'dir')
    mkdir(folder)
end
% expanding fields
%     mmax = floor(2*Nx/3);
%     nmax = floor(Nx*sqrt(1/9-1/(4*Nx^2)));
%     n = [0:nmax]; n = repmat(n, mmax);  n = n(1,:);
%     m = 1:mmax; m = repelem(m, nmax+1);  m = m(1,:);
n = [0:(Nx/2-1)]; n = repmat(n, Ny);  n = n(1,:);
m = 1:Ny; m = repelem(m, Nx/2);
[Rem,~,~,~] = GetRemGeneral_nxny(n,m,Nx,Ny);
%[Rem,~,~,~,~] = GetRemKeepnss(Nx);
[PsiEexp, ThetaEexp] = ExpandFields(Rem, PsiE, ThetaE);
% storing values
Out1 = zeros(length(PsiEexp)*2,1); % Real and imaginary values
Out2 = zeros(length(PsiEexp)*2,1); % Real and imaginary values
for i=1:2:length(PsiEexp)*2
    PsiEadd =  PsiEexp((i+1)/2);
    ThetaEadd = ThetaEexp((i+1)/2);
    % Making sure that we do not have super small bits
%     if abs(PsiEadd) < 1e-16
%         PsiEadd = 0;
%     end
%      if abs(ThetaEadd) < 1e-16
%         ThetaEadd = 0;
%     end
    if rem(n((i+1)/2) + m((i+1)/2),2) % if odd
        Out1(i) = PsiEadd;
        Out2(i+1) = ThetaEadd;
    else
        Out1(i+1) = PsiEadd; % this shift here sorts imag/real for even/odd
        Out2(i) = ThetaEadd;
    end
end
fileID = fopen([folder '/PsiE.txt'],'w');
fprintf(fileID,'%16.16e\n',Out1);
fileID = fopen([folder '/ThetaE.txt'],'w');
fprintf(fileID,'%16.16e\n',Out2);
end