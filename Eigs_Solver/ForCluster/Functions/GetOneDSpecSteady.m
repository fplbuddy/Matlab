function [psiSpec,thetaSpec,Kmax] = GetOneDSpecSteady(Data,Nx,Ny,G,Ra,Pr)
%% Getting data
AR = ['AR_' num2str(G)];
type = ['OneOne' num2str(Nx)];
PrS = PrtoPrS(Pr);
RaS = RatoRaS(Ra);
PsiE = Data.(AR).(type).(PrS).(RaS).PsiE;
ThetaE = Data.(AR).(type).(PrS).(RaS).ThetaE;

%% Calc
[~,~,n,m] = GetRemKeep_nxny(Nx,Ny,1);
K_list = sqrt(n.^2+m.^2);
K_list2 = sqrt((2*pi*n/G).^2+(m*pi).^2);
Kmax = ceil(max(K_list));
psiSpec = zeros(round(Kmax),1);
thetaSpec = zeros(round(Kmax),1);
for i=1:length(n)
    K = K_list(i);
    loc = round(K);
    if n(i) == 0
        two = 1;
    else
        two =2;
    end
    psiSpec(loc) = psiSpec(loc)+(abs(PsiE(i))^2)*two*K_list2(i)^2;
    thetaSpec(loc) =thetaSpec(loc)+(abs(ThetaE(i))^2)*two;
end
end

