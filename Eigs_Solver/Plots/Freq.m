clearvars -except AllData Data NewData
PrS_list = string(fieldnames(Data));
freq_list = [];
Pr_list = [];
for i=1:length(PrS_list)
    PrS = PrS_list(i);
    Pr = PrStoPr(PrS);
    if isfield(Data.(PrS), 'cross')
        Pr_list = [Pr Pr_list];
        freq_list = [abs(Data.(PrS).freq) freq_list];
    end
end
figure('Renderer', 'painters', 'Position', [5 5 540 200])
plot(Pr_list, freq_list, '*')
title('Crossing the imaginary axis', 'FontSize', 15)
xlabel('$Pr$', 'FontSize', 14)
ylabel('$imag(\sigma)$', 'FontSize', 14)