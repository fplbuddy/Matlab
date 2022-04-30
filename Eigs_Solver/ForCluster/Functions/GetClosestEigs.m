function [sigmaeven,xeven, sigmaodd,xodd, Raold] = GetClosestEigs(Data,N,Pr,Ra, AR)
% findind the closes point at which we have eigs and data for some new run 
% we want to do
% At the moment this does not loop round but maybe it should
N_list = string(fields(Data.(AR)));
for i=1:length(N_list)
   add = convertStringsToChars(N_list(i));
   N_list(i) = str2double(add(7:end)); % assuming oneone here
end
N_list(str2double(N_list)>N) = []; % in general, we only want to look down
[~, I] = sort(str2double(N_list), 'descend'); % sort it
N_list = N_list(I);
got = 0;
for i = 1:length(N_list)
    Ninst = N_list(i);
    if got; break; end
    type = ['OneOne' convertStringsToChars(Ninst)];
    PrS_list = string(fields(Data.(AR).(type)));
    Pr_list = [];
    for i=1:length(PrS_list)
       Pr_list = [Pr_list PrStoPr(PrS_list(i))]; 
    end
    % now we wanna put the Pr_list in order
    Pr_list_mod = abs(Pr_list-Pr);
    [~,I] = sort(Pr_list_mod);
    Pr_list = Pr_list(I);
    for j = 1:length(Pr_list)
        Prinst = Pr_list(j);
        if got; break; end
        PrS = PrtoPrS(Prinst);
        RaS_list = string(fields(Data.(AR).(type).(PrS)));
        Ra_list = [];
        for i=1:length(RaS_list)
           Ra_list = [Ra_list RaStoRa(RaS_list(i))]; 
        end
        Ra_list_mod = Ra_list/Ra;
        for i=1:length(Ra_list_mod) % making sure bigger than 1
            if Ra_list_mod(i) < 1
               Ra_list_mod(i) =  1/Ra_list_mod(i);
            end            
        end
        [~,I] = sort(Ra_list_mod);
        Ra_list = Ra_list(I);
        for k = 1:length(Ra_list)
            Rainst = Ra_list(k);
            if got; break; end
            RaS = RatoRaS(Rainst);
            if isfield(Data.(AR).(type).(PrS).(RaS), 'xoddbranch')
                Ngot = str2double(Ninst);
                Raold = Rainst;
                got = 1;
                sigmaeven = Data.(AR).(type).(PrS).(RaS).sigmaevenbranch;
                sigmaodd = Data.(AR).(type).(PrS).(RaS).sigmaoddbranch;
                xeven = Data.(AR).(type).(PrS).(RaS).xevenbranch;
                xodd = Data.(AR).(type).(PrS).(RaS).xoddbranch;               
            end            
        end                            
    end
end

% Now adding bits to eigenfunctions if needed
if Ngot ~= N
    xeven = ExpandEigenFunc(xeven,Ngot, N,'e');
    xodd = ExpandEigenFunc(xodd,Ngot, N,'o');
end
Ngot
Raold

end

