function M = GetFullMinf(Data, AR,type)
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
    RaS_list = string(fields(Data.(AR).(type)));
    RaS_list = OrderRaS_list(RaS_list);
    for j=1:length(RaS_list)
        RaS = RaS_list(j);
        ind = width(M);
        Ra = RaStoRa(RaS);
        if isfield(Data.(AR).(type).(RaS),"sigmaodd")
            sig = max(real(Data.(AR).(type).(RaS).sigmaodd));
            M(1,ind+1) = Ra; M(2,ind+1) = sig;
        elseif isfield(Data.(AR).(type).(RaS),"sigmaoddbranch")
            sig = real(Data.(AR).(type).(RaS).sigmaoddbranch);
            M(1,ind+1) = Ra; M(2,ind+1) = sig;
        end
    end
end
% order so that Ra is increasing
Ra = M(1,:);
sigs = M(2,:);
[Ra, I] = sort(Ra);
M = [Ra; sigs(I)];
end