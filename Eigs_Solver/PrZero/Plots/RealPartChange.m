G = 0.3;
GS = GtoGS(G);
N = 32;
type = ['N_' num2str(N)];
Pr = 1e-4;
PrS = PrtoPrSZero(Pr);
RaAS_list = string(fields(PrZeroData.(GS).(type).(PrS)));
%oe_list = ["sigmaodd" "sigmaeven"];
oe_list = ["sigmaodd"];
   figure()
for j=1:length(oe_list)
    oe = oe_list(j);
for i=1:length(RaAS_list)
   RaAS = RaAS_list(i);
    try
   sigma = PrZeroData.(GS).(type).(PrS).(RaAS).(oe);
   sigma_list(i) = max(real(sigma));
   RaA_list(i) = RaAStoRaA(RaAS);  
    catch
    end
end
   [RaA_list,I] = sort(RaA_list); 
   sigma_list = sigma_list(I);
   plot(RaA_list,sigma_list,'*'), hold on 
   clear RaA_list sigma_list
end
hold off