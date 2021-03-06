%% Input
AR = 2.8; Pr = 1; RaC = 27*pi^4/4;
run SomeInputStuff.m
Mode1list = []; Mode2list = []; Ra = [];
Ra_list = string(fieldnames(AllData.(ARS).(PrS)));
RaMin = 658;
Mode1 = "Re(1,1)"; Mode2 = "Re(0,1)"; type1 = 'ps'; type2 = 'ps';
Mode1tit = Modetit(Mode1, type1); Mode2tit = Modetit(Mode2, type2); 
%% Getting data
for i=1:length(Ra_list)
    RaInst = AllData.(ARS).(PrS).(Ra_list(i)).Ra;
    %if RaInst > RaMin
    Ra = [RaInst Ra];
    [Mode1Inst, ~] = GetSignal(Mode1,type1, AllData, ARS, PrS, Ra_list(i));
    [Mode2Inst, ~] = GetSignal(Mode2,type2, AllData, ARS, PrS, Ra_list(i));
    Mode1list = [Mode1Inst(end) Mode1list]; Mode2list = [Mode2Inst(end) Mode2list]; 
    %end
end
%% Make plot
% Sorting
[Ra, I] = sort(Ra);
Mode2list = Mode2list(I); Mode1list = Mode1list(I);
cmap = colormap(winter(length(Ra))); close
figure('Renderer', 'painters', 'Position', [5 5 540 250]), hold on
for i=1:length(Ra)
    %plot(abs(Mode1list(i)), abs(Mode2list(i)), '*', 'Color',cmap((length(Ra)-i+1),:),'DisplayName', num2str(Ra(i)))
    plot(Ra(i)-RaC, abs(Mode1list(i)), '*', 'Color',cmap((length(Ra)-i+1),:),'DisplayName', num2str(Ra(i)))
end
set(gca, 'xscale', 'log'), set(gca, 'yscale', 'log'), 
%Model
%[alpha, ~, xFitted, yFitted, ~] = FitsPowerLaw(abs(Mode1list),abs(Mode2list));
%plot(xFitted, yFitted, 'black--');
%gtext(['$' Mode2tit '\propto ' Mode1tit '^{'  num2str(alpha,3) '}$'],'FontSize',20,'color', 'black')
[alpha, ~, xFitted, yFitted, ~] = FitsPowerLaw(Ra - RaC,abs(Mode1list));
plot(xFitted, yFitted, 'black--');
gtext(['$' Mode1tit '\propto (Ra-Ra_c)^{'  num2str(alpha,3) '}$'],'FontSize',20,'color', 'black')

lgnd = legend('Location', 'BestOutside'); title(lgnd,'$Ra$'), xlabel(['$' Mode1tit '$'], 'FontSize',14) , ylabel(['$' Mode2tit '$'], 'FontSize',14)
title(['$\Gamma = ' num2str(AR) ', Pr = ' num2str(Pr) '$'], 'FontSize', 14)

clearvars -except AllData