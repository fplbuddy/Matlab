if exist('AR','var') 
    AR_list =  string(fieldnames(AllData));

    ARS = convertCharsToStrings(['AR_' num2str(AR)]);
    ARS = replace(ARS, ".", "_");
    % Checking that we have that AR
     while not(ismember(ARS,AR_list))
        AR = input('Which AR? (input number) ');
        ARS = convertCharsToStrings(['AR_' num2str(AR)]);
        ARS = replace(ARS, ".", "_");
     end
end
if exist('Pr','var')
    Pr_list =  string(fieldnames(AllData.(ARS)))


    %PrS = ['Pr_' num2str(Pr,'%15.15f')];
    PrS = PrtoPrS(Pr)
%     en = PrS(end);
%     while en == '0'
%        PrS(end) = []; 
%        en = PrS(end);
%     end
%     PrS = convertCharsToStrings(PrS);
%     PrS = replace(PrS, ".", "_");
    % Checking that we have that Pr
     while not(ismember(PrS,Pr_list))
        Pr = input('Which Pr? (input number) ');
        PrS = convertCharsToStrings(['Pr_' num2str(Pr)]);
        PrS = replace(PrS, ".", "_"); 
     end
end
if exist('Ra','var')
    try % This will always run if we have done params before
        Ra_list = string(fieldnames(AllData.(ARS).(PrS)));
        RaS = RatoRaS(Ra);
        % Checking that we have that Ra
        while not(ismember(RaS,Ra_list))
            Ra = input('Which Ra? (input number) ');
            RaS = RatoRaS(Ra);
        end
        % Check if we have an xlower
        if isfield(AllData.(ARS).(PrS).(RaS),'ICT')
            xlower = AllData.(ARS).(PrS).(RaS).ICT;
        else
            if not(exist('xlower','var'))
                %run lowerx.m
            end
        end
    catch % Used for plots for example, if we dont have a PrS say
        RaS = RatoRaS(Ra);
    end  
end

