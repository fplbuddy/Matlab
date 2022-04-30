function GetICsforDNS(PrAZero, Nx,Ny,GS,RaA,Amp,fact,phase)
type = ['N_' num2str(Nx) 'x' num2str(Ny)];
AmpS = AmptoAmpS(Amp); RaAS = RaAtoRaAS(RaA);
eigv = PrAZero.(type).(GS).(RaAS).(AmpS).eigv;
G = GStoG(GS);
%
n = [(-Nx/2):(Nx/2-1)]; n = repmat(n, Ny);  n = n(1,:);
m = 1:Ny; m = repelem(m, Nx);
[~,~,n,~] = GetRemGeneral_nxny(n,m,Nx,Ny);
% clean eigv
eigv(n<0) = [];
eigv(abs(eigv)<1e-10) = 0;
eigv = eigv*fact;
% adding 1,1, make sure it is complex
eigv(2) = 1i*Amp;
% Expand fields
n = [0:(Nx/2-1)]; n = repmat(n, Ny);  n = n(1,:);
m = 1:Ny; m = repelem(m, Nx/2);
[Rem,~,ni,~] = GetRemGeneral_nxny(n,m,Nx,Ny); % ni is used for max below
[eigv, ~] = ExpandFields(Rem, eigv, eigv);
% adding the phase
if phase
    phase = G/(4*(max(ni)+1)); % make sure we have some complex and real in each of the modes
    for i=1:length(n)
        ninst = n(i);
        eigv(i) = eigv(i)*exp(1i*phase*2*pi*ninst/G);
    end
end
% storing values
Out1 = zeros(length(eigv)*2,1); % Real and imaginary values
for i=1:2:length(eigv)*2
    Out1(i) = real(eigv((i+1)/2));
    Out1(i+1) = imag(eigv((i+1)/2));
end
folder = ['/Volumes/Samsung_T5/ZeroICs/' type '/' convertStringsToChars(GS) '/'  convertStringsToChars(RaAS) '/' convertStringsToChars(AmpS) ];
if ~exist(folder, 'dir')
    mkdir(folder)
end
writematrix(Out1,[folder '/PsiE.txt'],'Delimiter','tab')
end

