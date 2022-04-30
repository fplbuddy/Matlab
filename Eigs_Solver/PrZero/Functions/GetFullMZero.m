function M = GetFullMZero(PrZeroData,GS,PrS,type, res_list)
if type == "Odd"
    type = "sigmaodd";
else
    type = "sigmaeven";
end
%res_list = ["N_32" "N_64" "N_128"]; % assuming these are the res we have.
M = [];
for j=1:length(res_list)
    res = res_list(j);
    try % make sure we have res
    RaAS_list = string(fields(PrZeroData.(GS).(res).(PrS)));
    RaAS_list = OrderRaAS_list(RaAS_list);
    for i=1:length(RaAS_list)
       RaAS =  RaAS_list(i);
       ind = width(M); 
       RaA = RaAStoRaA(RaAS);
       sig = PrZeroData.(GS).(res).(PrS).(RaAS).(type);
       if type == "sigmaeven"
        sig(abs(sig)<1e-8) = []; % removing eig at origin
       end
       sig = max(real(sig));
       M(1,ind+1) = RaA; M(2,ind+1) = sig;
    end
    catch
    end
end
% put in right order
Pr = M(1,:);
sigs = M(2,:);
[Pr, I] = sort(Pr);
M = [Pr; sigs(I)];
end