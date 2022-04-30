nu = sqrt(pi^3/6e6);
comp = (nu*(2*pi)^2)*2;
run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m

%%
IC = 'IC_S';
PrS = "Pr_1e0";
reslist = string(fields(AllData.(IC)));
TotalPoitnts = [];
Ra_list = [];
for i=1:length(reslist)
    res = reslist(i);
    N = convertStringsToChars(res);
    N = str2num(N(3:5));
    RaS_list = string(fields(AllData.(IC).(res).(PrS)));
    for j=1:length(RaS_list)
        RaS = RaS_list(j);
        Gy_list = string(fields(AllData.(IC).(res).(PrS).(RaS)));
        LyC_list = [];
        for k=1:length(Gy_list)
            GyS = Gy_list(k);
            path = AllData.(IC).(res).(PrS).(RaS).(GyS).path;
            penergy2 = importdata([path '/Checks/penergy2.txt']);
            Ra = StoNormal(RaS,4); Gy = StoNormal(GyS,4);
            t = penergy2(:,1);
            s = penergy2(:,2);
            % remove zeros
            t(s == 0) = [];
            s(s == 0) = [];
            [alpha, ~, ~, ~, ~] = Fitslogy(t,s);
            AllData.(IC).(res).(PrS).(RaS).(GyS).alpha = alpha;
            LyC = CritLy(Ra,alpha,Gy);
            LyC_list = [LyC_list LyC];
        end
        LyCm = mean(LyC_list);
        TotalPoitnts = [TotalPoitnts LyCm];
        Ra_list = [Ra_list Ra];
        errorbar(Ra,LyCm/pi,abs(LyCm - min(LyC_list))/pi,abs(LyCm - max(LyC_list))/pi,'b.','MarkerSize',MS*2), hold on
        set(gca, 'YScale', 'log')
        set(gca, 'XScale', 'log')
        
    end
end
[Ra_list,I] = sort(Ra_list);
TotalPoitnts = TotalPoitnts(I);
plot(Ra_list,TotalPoitnts/pi,'b-','LineWidth',1)
% Make power law
Ra_listp = Ra_list(3:end);
TotalPoitntsp = TotalPoitnts(3:end);
[alpha, ~, xFitted, yFitted, ~] = FitsPowerLaw(Ra_listp,TotalPoitntsp);
yFitted = yFitted(1e6 < xFitted);
xFitted = xFitted(1e6 < xFitted);
yFitted = yFitted(1e8 > xFitted);
xFitted = xFitted(1e8 > xFitted);
plot(xFitted, yFitted/5,'--r','LineWidth',1)
text(1e5, 0.25,['$\Gamma_y \propto Ra^{' num2str(alpha) '}$'],'FontSize',labelFS,'Color','r')
title('$Pr = 1$','FontSize',labelFS)

ylabel('$\Gamma_y$','FontSize',labelFS)
xlabel('$Ra$','FontSize',labelFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
LyT = RatoRaT(Ly); RaT = RatoRaT(Ra); PrT = RatoRaT(Pr);
saveas(gcf,[figpath 'GyCritPr1'], 'epsc')


