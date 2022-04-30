ARS = "AR_2";
Pr_list = string(fieldnames(AllData.(ARS)));
Pr_list2 = 1e10*ones(length(Pr_list), 1);
Ra_list2 = 1e10*ones(length(Pr_list), 1);

for i=1:length(Pr_list)
    PrS = Pr_list(i);
    Pr_list2(i) = str2double(erase(strrep(PrS,"_","."),"Pr."));
    Ra_list = string(fieldnames(AllData.(ARS).(PrS)));
    for j=1:length(Ra_list)
        RaS = Ra_list(j);
        RaInst = AllData.(ARS).(PrS).(RaS).Ra;
        if isfield(AllData.(ARS).(PrS).(RaS),'ICT')
            PosShear = not(sum(size(AllData.(ARS).(PrS).(RaS).calcs.pos{1})) == 1);
            NegShear = not(sum(size(AllData.(ARS).(PrS).(RaS).calcs.neg{1})) == 1);
            if PosShear || NegShear
               if RaInst < Ra_list2(i); Ra_list2(i) = RaInst; end
            end
        end
    end
end
remove = [0.1 1.5 2 5 8 20 4 6.8 120 110 150];
for i=remove
    I = find(Pr_list2 == i);
    Pr_list2(I) = [];
    Ra_list2(I) = [];
end

% Plot
figure('Renderer', 'painters', 'Position', [5 5 540 200])
loglog(Ra_list2, Pr_list2, '*')
title('Where Shearing Starts', 'Fontsize', 15)
xlabel('$Ra$', 'Fontsize', 14)
ylabel('$Pr$', 'Fontsize', 14)
clearvars -except AllData