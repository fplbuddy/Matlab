run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
run SetUp.m
AR_list = string(fields(PrInfData));
Ra_list = [];
G_list = [];
for i=1:length(AR_list)
    AR = AR_list(i);
    AR = convertStringsToChars(AR); 
    G = str2num(strrep(AR(4:end),'_','.'));
    M = GetFullMinf(PrInfData, AR,"");
    Raout = GetCrossings(M, "NonLinear",3);
    Ra_list = [Ra_list Raout];
    G_list = [G_list G*ones(1,length(Raout))];   
end
figure()
[G_list,I] = sort(G_list);
Ra_list = Ra_list(I);
semilogy(G_list,Ra_list,'-o', 'LineWidth',1,'MarkerSize',10);
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$\Gamma$', 'FontSize',LabelFS);
ylabel('$Ra$', 'FontSize',LabelFS);
saveas(gcf,[figpath 'GammaDept'], 'epsc')