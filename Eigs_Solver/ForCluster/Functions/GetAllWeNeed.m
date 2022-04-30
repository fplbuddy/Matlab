function [sigmaeven,xeven, sigmaodd,xodd,Data] = GetAllWeNeed(Data,N,Pr,Ra, AR)
    % tt takes values 1 or 2 and depends on if we get (Ra, Pr) the same
    % but for some lower N or, if we get for (N, Pr) the same but with Ra
    % varying. 1 is preferable, but probably the one which will be used
    % less often

    % Fixing type
    RaS = RatoRaS(Ra); % The Ra we are looking for
    PrS = PrtoPrS(Pr);
    N_list = string(fields(Data.(AR)));
    for i=1:length(N_list)
        add = convertStringsToChars(N_list(i));
        N_list(i) = str2double(add(7:end)); % assuming oneone here
    end
    N_list(str2double(N_list)>N) = []; % in general, we only want to look down
    [~, I] = sort(str2double(N_list), 'descend'); % sort it
    N_list = N_list(I);
    Ncheck = N_list(2); % Probably just want to check one below
    typecheck = ['OneOne' convertStringsToChars(Ncheck)];
    if isfield(Data.(AR).(typecheck).(PrS), RaS)
        tt = 1;
    else
        tt = 2; % ASSUMING that we have at least one from before at same N
    end

    % Getting outputs
    type = ['OneOne' num2str(N)];
    if tt == 1 % we are going down
        % getting the thing for factor
        Data.(AR).(type).(PrS).(RaS).Deltaeven = 0; % as we are not changing Ra
        Data.(AR).(type).(PrS).(RaS).Deltaodd = 0;
        Data.(AR).(type).(PrS).(RaS).LJ = Data.(AR).(typecheck).(PrS).(RaS).LJ;
        Data.(AR).(type).(PrS).(RaS).TJ = Data.(AR).(typecheck).(PrS).(RaS).TJ;
        % getting the other stuff
        xeven = ExpandEigenFunc(Data.(AR).(typecheck).(PrS).(RaS).xevenbranch,str2double(Ncheck), N,'e');
        xodd = ExpandEigenFunc(Data.(AR).(typecheck).(PrS).(RaS).xoddbranch,str2double(Ncheck), N,'o');
        sigmaeven = Data.(AR).(typecheck).(PrS).(RaS).sigmaevenbranch; % Have not shifted these yet
        sigmaodd = Data.(AR).(typecheck).(PrS).(RaS).sigmaoddbranch; %
    else %% tt = 2
        RaS_list_myN = string(fields(Data.(AR).(type).(PrS)));
        RaS_list_myN = OrderRaS_list(RaS_list_myN);
        myPos = find(RaS_list_myN == RaS);
        RaS1 = RaS_list_myN(myPos - 1); % One Ra down
        Ra1 = RaStoRa(RaS1);
        Data.(AR).(type).(PrS).(RaS).LJ = Data.(AR).(type).(PrS).(RaS1).TJ;
        Data.(AR).(type).(PrS).(RaS).TJ = Ra/Ra1;
        sigmaeven = Data.(AR).(type).(PrS).(RaS1).sigmaevenbranch;
        sigmaodd = Data.(AR).(type).(PrS).(RaS1).sigmaoddbranch;
        xeven = Data.(AR).(type).(PrS).(RaS1).xevenbranch;
        xodd = Data.(AR).(type).(PrS).(RaS1).xoddbranch;
        try % Try to go two down in current N
            RaS2 = RaS_list_myN(myPos - 2); % Two Ra down
            sigmmaeven2 = Data.(AR).(type).(PrS).(RaS2).sigmaevenbranch;
            sigmmaodd2 = Data.(AR).(type).(PrS).(RaS2).sigmaoddbranch;
        catch % If we need to go down one for the second one
            RaS_list_lowerN = string(fields(Data.(AR).(typecheck).(PrS)));
            RaS_list_lowerN = OrderRaS_list(RaS_list_lowerN);
            RaS2 = RaS_list_lowerN(end-1); % Going to be the 2nd to last one
            sigmmaeven2 = Data.(AR).(typecheck).(PrS).(RaS2).sigmaevenbranch;
            sigmmaodd2 = Data.(AR).(typecheck).(PrS).(RaS2).sigmaoddbranch;
        end
        Data.(AR).(type).(PrS).(RaS).Deltaeven = sigmaeven - sigmmaeven2;
        Data.(AR).(type).(PrS).(RaS).Deltaodd = sigmaodd - sigmmaodd2;
    end

    % Now we shift the sigmas
    fact = Data.(AR).(type).(PrS).(RaS).TJ/Data.(AR).(type).(PrS).(RaS).LJ;
    sigmaeven = sigmaeven+fact*Data.(AR).(type).(PrS).(RaS).Deltaeven;
    sigmaodd = sigmaodd+fact*Data.(AR).(type).(PrS).(RaS).Deltaodd;
    clearvars -except Data xodd xeven sigmaeven sigmaodd
end

