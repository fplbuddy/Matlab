run SetUp.m
Nx = 32;
Ny = 16;
type  = ['N_' num2str(Nx) 'x' num2str(Ny)];
Pr = 1e-5;
G = 0.3;
GS = GtoGS(G);
PrS = PrtoPrS(Pr);
RaAS_list = string(fieldnames(Data.(GS).(type).(PrS)));
RaAS_list = OrderRaAS_list(RaAS_list);
RaA_list = zeros(length(RaAS_list),1);
ZeroOne_list = zeros(length(RaAS_list),1);
OneOne_list = zeros(length(RaAS_list),1);
for i=1:length(RaA_list)
    RaAS = RaAS_list(i);
    RaA_list(i) = RaAStoRaA(RaAS);
    PsiE = Data.(GS).(type).(PrS).(RaAS).PsiE;
    ZeroOne_list(i) = PsiE(1);
    OneOne_list(i) = PsiE(2);
end
figure()
loglog(RaA_list,abs(OneOne_list),'b-o'); hold on
plot(RaA_list,abs(ZeroOne_list),'r-o');
