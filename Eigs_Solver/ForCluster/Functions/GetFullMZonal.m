function M = GetFullMZonal(Data, PrS)
M = [];
RaS_list = string(fields(Data.AR_2.OneOne400.(PrS)));
RaS_list = OrderRaS_list(RaS_list);
for j=1:length(RaS_list)
    RaS = RaS_list(j);
    ind = width(M);
    Ra = RaStoRa(RaS);
    try % might not have sigmaoddZ
    sig = real(Data.AR_2.OneOne400.(PrS).(RaS).sigmaoddZ);
    M(1,ind+1) = Ra; M(2,ind+1) = sig;
    catch
    end
end
% order so that Pr is increasing
Pr = M(1,:);
sigs = M(2,:);
[Pr, I] = sort(Pr);
M = [Pr; sigs(I)];
end