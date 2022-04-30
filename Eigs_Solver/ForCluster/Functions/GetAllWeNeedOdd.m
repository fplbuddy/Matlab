function [sigmaodd,xodd,Data] = GetAllWeNeedOdd(Data,N,Pr,Ra, AR)
    % tt takes values 1 or 2 and depends on if we get (Ra, Pr) the same
    % but for some lower N or, if we get for (N, Pr) the same but with Ra
    % varying. 1 is preferable, but probably the one which will be used
    % less often
    % Imag part tends to increase and does so in someting like imag(sigma2)/imag(sigma
    %2) = Ra2/Ra1. We increase the real part as we did before.

    % Fixing type
    RaS = RatoRaS(Ra); % The Ra we are looking for
    PrS = PrtoPrS(Pr);
    types_list = Gettypes_list(Data,PrS, AR);
    typecheck = types_list(end-1); % Get the second largest N that we have
    typec = convertStringsToChars(typecheck);
    Ncheck = str2double(typec(7:end));
    if isfield(Data.(AR).(typecheck).(PrS), RaS)
        tt = 1;
    else
        tt = 2; % ASSUMING that we have at least one from before at same N
    end

    % Getting outputs
    type = ['OneOne' num2str(N)];
    if tt == 1 % we are going down
        % getting the thing for factor
        Data.(AR).(type).(PrS).(RaS).Deltaodd = 0; % as we are not changing Ra
        Data.(AR).(type).(PrS).(RaS).LJ = Data.(AR).(typecheck).(PrS).(RaS).LJ;
        Data.(AR).(type).(PrS).(RaS).TJ = Data.(AR).(typecheck).(PrS).(RaS).TJ;
        % getting the other stuff
        xodd = ExpandEigenFunc(Data.(AR).(typecheck).(PrS).(RaS).xoddbranch,Ncheck, N,'o');
        sigmaodd = Data.(AR).(typecheck).(PrS).(RaS).sigmaoddbranch; % Have not shifted these yet
    else %% tt = 2
        RaS_list_myN = string(fields(Data.(AR).(type).(PrS)));
        RaS_list_myN = OrderRaS_list(RaS_list_myN);
        myPos = find(RaS_list_myN == RaS);
        RaS1 = RaS_list_myN(myPos - 1); % One Ra down
        Ra1 = RaStoRa(RaS1);
        Data.(AR).(type).(PrS).(RaS).LJ = Data.(AR).(type).(PrS).(RaS1).TJ;
        Data.(AR).(type).(PrS).(RaS).TJ = Ra/Ra1;
        sigmaodd = Data.(AR).(type).(PrS).(RaS1).sigmaoddbranch;
        xodd = Data.(AR).(type).(PrS).(RaS1).xoddbranch;
        try % Try to go two down in current N
            RaS2 = RaS_list_myN(myPos - 2); % Two Ra down
            sigmmaodd2 = Data.(AR).(type).(PrS).(RaS2).sigmaoddbranch;
        catch % If we need to go down one for the second one
            RaS_list_lowerN = string(fields(Data.(AR).(typecheck).(PrS)));
            RaS_list_lowerN = OrderRaS_list(RaS_list_lowerN);
            RaS2 = RaS_list_lowerN(end-1); % Going to be the 2nd to last one
            sigmmaodd2 = Data.(AR).(typecheck).(PrS).(RaS2).sigmaoddbranch;
        end
        Data.(AR).(type).(PrS).(RaS).Deltaodd = sigmaodd - sigmmaodd2;
    end

    % Now we shift the sigmas
    fact = Data.(AR).(type).(PrS).(RaS).TJ/Data.(AR).(type).(PrS).(RaS).LJ;
    sigmaodd = real(sigmaodd)+fact*real(Data.(AR).(type).(PrS).(RaS).Deltaodd) + Data.(AR).(type).(PrS).(RaS).TJ*imag(sigmaodd)*1i;
    % adding the real and image part seperately
    clearvars -except Data xodd sigmaodd
end

