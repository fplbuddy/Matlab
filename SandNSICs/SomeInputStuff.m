if exist('Ra','var')
    try % This will always run if we have done params before
        Ra_list = string(fieldnames(AllData.(ARS).(PrS)));
        RaS = RatoRaS(Ra);
        % Checking that we have that Ra
        while not(ismember(RaS,Ra_list))
            Ra = input('Which Ra? (input number) ');
            RaS = RatoRaS(Ra);
        end
    catch % Used for plots for example, if we dont have a PrS say
        RaS = RatoRaS(Ra);
    end  
end

