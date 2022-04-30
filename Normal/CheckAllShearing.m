AR_list =string(fieldnames(AllData));
count = 0;
for i=1:length(AR_list)
    ARS = AR_list(i);
    Pr_list = string(fieldnames(AllData.(ARS)));
    for i=1:length(Pr_list)
        PrS = Pr_list(i);
        Ra_list = string(fieldnames(AllData.(ARS).(PrS)));
        for i=1:length(Ra_list)
            RaS = Ra_list(i);
            if isfield(AllData.(ARS).(PrS).(RaS),'ICT')
                xlower = AllData.(ARS).(PrS).(RaS).ICT;
                run OneMode.m
                count = count + 1;
                if count == 5
                    pause
                    count = 0;
                end
            end
        end
    end
end