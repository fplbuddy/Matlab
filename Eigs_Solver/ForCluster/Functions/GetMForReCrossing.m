function M = GetMForReCrossing(Data, PrS, AR)
% This is going to work exclusevly for N = 100. Will be looking in the
% range Pr = 8.5-8.6

M = [];
type = "OneOne100";
if isfield(Data.(AR).(type),PrS)
    RaS_list = string(fields(Data.(AR).(type).(PrS)));
    RaS_list = OrderRaS_list(RaS_list);
    for j=1:length(RaS_list)
        RaS = RaS_list(j);
        ind = width(M);
        Ra = RaStoRa(RaS);
        sigmaodd = Data.(AR).(type).(PrS).(RaS).sigmaodd;
        sigmaodd(abs(imag(sigmaodd)) > 1e3) = []; % Only consider the eig that is going back on itself
        sig = max(real(sigmaodd));
        M(1,ind+1) = Ra; M(2,ind+1) = sig;
    end
end
% order so that Pr is increasing
Pr = M(1,:);
sigs = M(2,:);
[Pr, I] = sort(Pr);
M = [Pr; sigs(I)];
end

