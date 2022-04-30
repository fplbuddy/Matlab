function M = GetFullMZeronss(Data,GS,PrS,remPitch,res_list)
%res_list = ["N_32x32"]; % assuming these are the res we have.
M = [];
for j=1:length(res_list)
    res = res_list(j);
    try % make sure we have res
    RaAS_list = string(fields(Data.(GS).(res).(PrS)));
    RaAS_list = OrderRaAS_list(RaAS_list);
    for i=1:length(RaAS_list)
       RaAS =  RaAS_list(i);
       ind = width(M); 
       RaA = RaAStoRaA(RaAS);
       sigs = Data.(GS).(res).(PrS).(RaAS).sigma;
       if remPitch
           sigs(imag(sigs) < 1e-10) = [];
       end
       sig = max(real(sigs));
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