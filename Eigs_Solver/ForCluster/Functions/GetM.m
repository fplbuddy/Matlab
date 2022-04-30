function M = GetM(Data, PrS, types, AR,n, t,EO, branch)
% Make the combined RaS_list
% branch will be 1 or 0 depending on if we are looking at the branch or
% not
RaS_list = [];
type_list = [];
for i=1:length(types)
    type = types(i);
    try
        RaS_add = string(fieldnames(Data.(AR).(type).(PrS)));
        RaS_list = [RaS_list; RaS_add];
        type_add = repmat(type, length(RaS_add), 1);
        type_list = [type_list; type_add];
    catch
    end
end

[RaS_list, I] = OrderRaS_list(RaS_list);
type_list = type_list(I);
% Remove ones we dont have data for
rem = [];
for i = 1:length(RaS_list)
    RaS = RaS_list(i);
    Ra = RaStoRa(RaS);
    if branch
        try
            Data.(AR).(type).(PrS).(RaS).sigmaoddbranch;
        catch
            rem = [rem i];
        end
    else
        % This is pretty hacky, only workds if we have two types
        try
            Data.(AR).(types(1)).(PrS).(RaS).sigmaodd;
        catch
            try
                Data.(AR).(types(2)).(PrS).(RaS).sigmaodd;
            catch
                rem = [rem i];
            end
        end
    end
end
RaS_list(rem) = [];
type_list(rem) = [];

M = zeros(2,length(RaS_list));
for i=1:length(RaS_list)
    type = type_list(i);
    RaS = RaS_list(i);
    Ra = RaStoRa(RaS);
    if EO == "odd"
        if branch
            sigma = Data.(AR).(type).(PrS).(RaS).sigmaoddbranch;
        else
            sigma = Data.(AR).(type).(PrS).(RaS).sigmaodd;
        end
    else
        if branch
            sigma = Data.(AR).(type).(PrS).(RaS).sigmaevenbranch;
        else
            sigma = Data.(AR).(type).(PrS).(RaS).sigmaeven;
            sigmaabs = abs(sigma);
            rem = find(sigmaabs < 0.1); % removing eig at 0 due to trans invariance
            sigma(rem) = [];
        end
    end
    y = sort(real(sigma), 'descend');
    maxreal = y(n);
    M(1,i) = Ra;
    M(2,i) = maxreal;
end
sigmas = M(2,:);
s = sign(sigmas);
d = diff(s);
cross = find(d ~= 0);
try
    cww = cross(t);
    M = [M(1,cww) M(1,cww+1) ; M(2,cww) M(2,cww+1)];
catch
    M = [];
end
end

