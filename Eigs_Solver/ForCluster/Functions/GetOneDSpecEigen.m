function [psiSpec,thetaSpec,Kmax] = GetOneDSpecEigen(Data,Nx,Ny,G,Ra,Pr)
%% Getting data
AR = ['AR_' num2str(G)];
type = ['OneOne' num2str(Nx)];
PrS = PrtoPrS(Pr);
RaS = RatoRaS(Ra);
EigV =  Data.(AR).(type).(PrS).(RaS).Eigv;
Psio = EigV(1:length(EigV)/2);
Thetao = EigV(length(EigV)/2+1:end);

%% Calc
n = [(-Nx/2):2:(Nx/2-1) (-Nx/2+1):2:(Nx/2-1)]; n = repmat(n, Ny/2);  n = n(1,:);
m = 1:Ny; m = repelem(m, Nx/2);
[~,~,n,m] = GetRemGeneral_nxny(n,m,Nx,Ny);
K_list = sqrt(n.^2+m.^2);
K_list2 = sqrt((2*pi*n.^2/G)+m.^2);
Kmax = ceil(max(K_list));
psiSpec = zeros(round(Kmax),1);
thetaSpec = zeros(round(Kmax),1);
for i=1:length(n)
    K = K_list(i);
    loc = round(K);
    psiSpec(loc) = psiSpec(loc)+(abs(Psio(i))^2)*K_list2(i)^2;
    thetaSpec(loc) =thetaSpec(loc)+(abs(Thetao(i))^2);
end
end

