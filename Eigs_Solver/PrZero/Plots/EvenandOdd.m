Pr = 1e-4; PrS = PrtoPrSZero(Pr);
G = 2.3; GS = GtoGS(G);
res = "N_64";
RaAS_list = string(fields(PrZeroData.(GS).(res).(PrS)));
even_list = zeros(length(RaAS_list),1);
odd_list = zeros(length(RaAS_list),1);
RaA_list = zeros(length(RaAS_list),1);
for i=1:length(RaAS_list)
   RaAS = RaAS_list(i);
   RaA = RaAStoRaA(RaAS);
   RaA_list(i) = RaA;
   even = PrZeroData.(GS).(res).(PrS).(RaAS).sigmaeven; even = max(real(even));
   odd =  PrZeroData.(GS).(res).(PrS).(RaAS).sigmaodd; odd = max(real(odd));
   odd_list(i) = odd;
   even_list(i) = even;
end
[RaAS_list, I]= OrderRaAS_list(RaAS_list);
figure()
odd_list = odd_list(I);
even_list = even_list(I);
RaA_list =RaA_list(I);
semilogy(RaA_list,abs(odd_list),'-o'), hold on
plot(RaA_list,abs(even_list),'-o')
plot(RaA_list(odd_list<0), abs(odd_list(odd_list<0)),'b*')
plot(RaA_list(odd_list>0), odd_list(odd_list>0),'r*')