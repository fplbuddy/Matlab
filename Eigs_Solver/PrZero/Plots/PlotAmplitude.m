run SetUp.m
% Loading in the old data
dpath = '/Volumes/Samsung_T5/OldData/PrZeroData.mat';
%load(dpath)
Pr = 1e-4; PrS = PrtoPrSZero(Pr);
G = 2; GS = GtoGS(G);
N = 32;
type = ['N_' num2str(N)];
RaAS_list = string(fields(PrZeroData.(GS).(type).(PrS)));
% fact = 2*G/(pi*(4+G^2));
%fact = 1;
fact = 2*G^2/(pi*(4+G^2));
for i=1:length(RaAS_list)
    RaAS = RaAS_list(i);
    RaA_list(i) = RaAStoRaA(RaAS);
    PsiE = PrZeroData.(GS).(type).(PrS).(RaAS).PsiE;
    ThetaE = PrZeroData.(GS).(type).(PrS).(RaAS).ThetaE;
%     A = PsiE(1)*fact;
%     A2_list(i) = A^2;
    A2_list(i) = ThetaE(9)*fact;
end
figure
plot(RaA_list,abs(A2_list)), hold on
plot(RaA_list,RaA_list*8*G^6/(pi^6*(4+G^2)^4))
