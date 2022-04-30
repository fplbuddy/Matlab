Ra_list = [785 786 3.7e4 3.8e4 1.1e6 1.2e6 3.2e4 3.3e4];
Pr_list = [0.01 0.01 0.1 0.1 1 1 10 10];
type_list = ['d' 'u' 'd' 'u' 'd' 'u' 'd' 'u'];
type_list2 = ['s' 's' 's' 's' 'o' 'o' 'o' 'o'];
type_list3 = ["OneOne64" "OneOne64" "OneOne152" "OneOne152" "OneOne256" "OneOne256" "OneOne152" "OneOne152"];
addpath('/Users/philipwinchester/Dropbox/Matlab/JFM')
run SetUp.m
figure('Renderer', 'painters', 'Position', [5 5 700 600])

for i=1:length(Pr_list)
    type = type_list(i);
    type2 = type_list2(i);
    type3 = type_list3(i);
    Pr = Pr_list(i);
    Ra = Ra_list(i);
    PrS = PrtoPrS(Pr);
    RaS = RatoRaS(Ra);
    ICT = AllData.AR_2.(PrS).(RaS).ICT;
    kpsmodes1 = importdata([convertStringsToChars(AllData.AR_2.(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
    kappa = AllData.AR_2.(PrS).(RaS).kappa;
    Signal = kpsmodes1(:,2); t = kpsmodes1(:,1); Signal(1:ICT) = []; t(1:ICT) = [];
    t = t/(pi^2/kappa);
    Signal = Signal/kappa;
    if Pr == 0.01 || Pr == 0.1
        [alpha, A, ~, ~, ~] = Fitslogy(t,abs(Signal));
        alpha
        if type == 'u'
            yend = max(abs(Signal))*1e3;
        else
            yend = max(abs(Signal))*1e-3;
        end
        tend = (log(yend) - log(A))/alpha;
        Signal = [Signal; yend];
        t = [t; tend];
    end
    subplot(4,2,i)
    semilogy(t,abs(Signal), 'LineWidth', 2, 'Color', 'r'), hold on
    % find what is predicted by matlab
    sig = max(real(Data.AR_2.(type3).(PrS).(RaS).sigmaodd));
    x(1) = t(1);
    if type2 == 's'
        y(1) = abs(Signal(1));
    else
        pks = findpeaks(abs(Signal));
        y(1) = pks(1);
    end
    A = y(1)/exp(sig*x(1));
    x(2) = t(end);
    y(2) = A*exp(x(2)*sig);
    plot(x,y, '--k', 'LineWidth',2), hold off
    xlim([0 t(end)])
    if type2 == 'o'
        ylim([min(pks) max(pks)])
    end
    if Ra == 3.2e4
        ylim([min(pks) 1e-8])
    end
    RaS = num2str(Ra);    
    if Pr == 0.01
        title(['$Ra = ' RaS(1) '.' RaS(2) RaS(3) '\times 10^' num2str(length(RaS)-1) '$'],'FontSize',TitleFS)     
    else
        title(['$Ra = ' RaS(1) '.' RaS(2) '\times 10^' num2str(length(RaS)-1) '$'],'FontSize',TitleFS)      
    end
    tic = logspace(-16,3,20);
    tic = tic(1:2:length(tic));
    yticks(tic)
    ax = gca;
    ax.XAxis.FontSize = numFS;
    ax.YAxis.FontSize = numFS;
    if type == 'd'
       ylabel('$|\widehat \psi_{0,1}|/\kappa$', 'FontSize',LabelFS)   
    end
    if Pr == 10
        xlabel('$t/(d^2/\kappa)$', 'FontSize',LabelFS)
    end
end

start = 5e15;
diff = 5e6;
text(20,start,'$Pr= 10^{-2}$','FontSize',TitleFS,'Rotation',  270)
text(20,start/diff,'$Pr= 10^{-1}$','FontSize',TitleFS,'Rotation',  270)
text(20,start/diff^2,'$Pr= 1$','FontSize',TitleFS,'Rotation',  270)
text(20,start/diff^3,'$Pr= 10$','FontSize',TitleFS,'Rotation',  270)

saveas(gcf,[figpath2 'TimeSer.eps'], 'epsc')