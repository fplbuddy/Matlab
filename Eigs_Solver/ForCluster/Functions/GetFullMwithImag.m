function M = GetFullMwithImag(Data, PrS, AR,type)
if type == ""
% Idea is that we get an full M for som PrS and AR
types_list = string(fields(Data.(AR)));
types_list = Ordertypes_list(types_list);
else % if we only want to look at one type
   types_list = convertCharsToStrings(type);
end
    
M = [];
for i=1:length(types_list) % looping round types
    type = types_list(i);
    if isfield(Data.(AR).(type),PrS)
        RaS_list = string(fields(Data.(AR).(type).(PrS)));
        RaS_list = OrderRaS_list(RaS_list);
        for j=1:length(RaS_list)
            RaS = RaS_list(j);
            ind = width(M);
            Ra = RaStoRa(RaS);
            if isfield(Data.(AR).(type).(PrS).(RaS),"sigmaodd")
                sigmaodd =Data.(AR).(type).(PrS).(RaS).sigmaodd;
                [~,I] = max(real(sigmaodd)); 
                sig = sigmaodd(I);
                if imag(sig) < 0, sig = conj(sig); end
                M(1,ind+1) = Ra; M(2,ind+1) = sig;
            end
        end
    end    
end 
% order so that Pr is increasing
Pr = M(1,:);
sigs = M(2,:);
[Pr, I] = sort(Pr);
M = [Pr; sigs(I)];
end