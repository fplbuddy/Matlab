path = '/Volumes/Samsung_T5/OldData/NewSteadyState.mat';
load(path)
run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
GS = 'G_2';
res = 'N_32x32';
Pr_list = [1e-4 6e-5 3e-5 2e-5 1e-5];
r = 1.02e-3/(1e-4)^2;
period = zeros(1,length(Pr_list));
for i=1:length(Pr_list)
   Pr = Pr_list(i); 
   PrS = PrtoPrS(Pr);
   RaA = round(r*Pr^2,3,'significant');
   RaAS = normaltoS(RaA,'RaA',1);
   sigma = Data.(GS).(res).(PrS).(RaAS).sigma;
   [~,I] = max(real(sigma));
   period(i) = 2*pi/abs(imag(sigma(I)));
end
figure()
loglog(Pr_list,period,'.')
ylabel('Period')
xlabel('$Pr$')
saveas(gcf,[figpath 'PeriodScaling'], 'epsc')

