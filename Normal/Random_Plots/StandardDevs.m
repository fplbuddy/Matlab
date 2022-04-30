%% Input
AR = 2; Pr = 30;
run SomeInputStuff.m
Ra_list = string(fieldnames(AllData.(ARS).(PrS)));
Rmin = 1.4e4;
Mode1list = []; Mode2list = []; Ra = [];
Mode1 = "Re(1,1)"; Mode2 = "Re(1,2)"; type1 = 'ps'; type2 = 'ps';
Mode1tit = Modetit(Mode1, type1); Mode2tit = Modetit(Mode2, type2);
for i=1:length(Ra_list)
    RaInst = AllData.(ARS).(PrS).(Ra_list(i)).Ra;
    if RaInst > Rmin
        Ra = [RaInst Ra];
        [Mode1Inst, ~] = GetSignal(Mode1,type1, AllData, ARS, PrS, Ra_list(i));
        [Mode2Inst, ~] = GetSignal(Mode2,type2, AllData, ARS, PrS, Ra_list(i));
        xlower = AllData.(ARS).(PrS).(Ra_list(i)).ICT;
        Mode1Inst = Mode1Inst(xlower:end); Mode2Inst = Mode2Inst(xlower:end);        
        Mode1list = [std(Mode1Inst) Mode1list]; Mode2list = [std(Mode2Inst) Mode2list];
    end  
end
%% Make plot
% Sorting
[Ra, I] = sort(Ra);
Mode2list = Mode2list(I); Mode1list = Mode1list(I);
cmap = colormap(winter(length(Ra))); close
figure('Renderer', 'painters', 'Position', [5 5 540 250]), hold on
for i=1:length(Ra)
    %if Ra(i) < 57700 && Ra(i) > 47690
    %plot(Mode1list(i), Mode2list(i), '*', 'Color',cmap((length(Ra)-i+1),:),'DisplayName', num2str(Ra(i)))
    plot(Mode1list(i), Mode2list(i),'*', 'DisplayName', num2str(Ra(i)))
    %end
end
lgnd = legend('Location', 'BestOutside'); title(lgnd,'$Ra$'), xlabel(['$' Mode1tit '$'], 'FontSize',14) , ylabel(['$' Mode2tit '$'], 'FontSize',14)
