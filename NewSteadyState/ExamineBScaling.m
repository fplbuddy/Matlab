[~,~,n,m,~] = GetRemKeepnss_nxny(32,32);
evenmodes = [];
for i=1:length(n)
   if not(rem(n(i) + m(i),2))
       evenmodes = [evenmodes i];
   end  
end
% Look at constant dRa
GS = 'G_2';
res = 'N_32x32';
% Pr_list = [1e-4 6e-5 3e-5 2e-5 1e-5 6e-6 3e-6 2e-6 1e-6];
% RaA = 1.02e-3; RaAS = normaltoS(RaA,'RaA',1);
% ZeroOne = zeros(1,length(Pr_list));
% for i=1:length(Pr_list)
%    Pr = Pr_list(i); 
%    PrS = PrtoPrS(Pr);
%    PsiE = Data.(GS).(res).(PrS).(RaAS).PsiE;
%    ZeroOne(i) = PsiE(1);
% end

%% Look at psi_1,1/B at instability
Pr_list = [1e-4 6e-5 3e-5 2e-5 1e-5];
r = 1.02e-3/(1e-4)^2;
frac = zeros(1,length(Pr_list));
B_list = zeros(1,length(Pr_list));
for i=1:length(Pr_list)
   Pr = Pr_list(i); 
   PrS = PrtoPrS(Pr);
   RaA = round(r*Pr^2,3,'significant');
   RaAS = normaltoS(RaA,'RaA',1);
   PsiE = Data.(GS).(res).(PrS).(RaAS).PsiE;
   %frac(i) = PsiE(1)/PsiE(2);
   PsiE(evenmodes) = []; % removing even modes
   oddmodesamp = norm(PsiE); % so this is in theory B*Pr^2
   B = oddmodesamp/Pr^2;
   %frac(i) = PsiE(2)/B; % this should go like eps. since B const and psi1,1 goes like eps
   B_list(i) = B;
end
figure()
loglog(Pr_list,frac,'.')

