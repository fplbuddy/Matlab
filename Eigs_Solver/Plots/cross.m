clearvars -except AllData Data NewData
PrS_list = string(fieldnames(Data.AR_2.OneOne));
cross_list1 = []; cross_list2 = [];
Pr_list1 = []; Pr_list2 = [];
for i=1:length(PrS_list)
    PrS = PrS_list(i);
    Pr = PrStoPr(PrS);
    if isfield(Data.AR_2.OneOne.(PrS), 'cross')
        Pr_list1 = [Pr Pr_list1];
        cross_list1 = [Data.AR_2.OneOne.(PrS).cross cross_list1];
    end
    if isfield(Data.AR_2.OneOne.(PrS), 'secondcross')
        Pr_list2 = [Pr Pr_list2];
        cross_list2 = [Data.AR_2.OneOne.(PrS).secondcross cross_list2];
    end
    
end
figure('Renderer', 'painters', 'Position', [5 5 540 200])
plot(cross_list1, Pr_list1, '*', 'DisplayName', 'First crossing'), hold on
plot(cross_list2, Pr_list2, '*', 'DisplayName', 'Regain stability')
legend('FontSize', 14)
title('Crossing the imaginary axis', 'FontSize', 15)
xlabel('$Ra$', 'FontSize', 14)
ylabel('$Pr$', 'FontSize', 14)
set(gca, 'xscale', 'log')
ylim([6 11])
