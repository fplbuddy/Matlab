Ra_list = [1.1e6 1.2e6 3.2e4 3.3e4];
Pr_list = [1 1 10 10];
type_list = [ 'd' 'u' 'd' 'u'];
type_list3 = ["OneOne256" "OneOne256" "OneOne152" "OneOne152"];
addpath('/Users/philipwinchester/Dropbox/Matlab/JFM')
run SetUp.m
figure('Renderer', 'painters', 'Position', [5 5 700 400])
shift = 7;
Tshift1 = 0.3;
Tshift2 = 0.15;

for i=1:length(Pr_list)
    type = type_list(i);
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
    [f, P1] = GetSpectra(Signal, t);
    subplot(2,2,i)
    [~,I] = max(P1);
    semilogy(f,P1,'r-o'), hold on
    xlim([f(I-shift) f(I+shift)])
    % add stab an stuff
    sig = Data.AR_2.(type3).(PrS).(RaS).sigmaodd;
    [~,I2] = max(real(sig));
    freq = abs(imag(sig(I2))/(2*pi))
    plot([freq freq], [min([P1(I-shift) P1(I+shift)]) P1(I)], 'k--'), hold off
    
    RaS = num2str(Ra);
    title(['$Ra = ' RaS(1) '.' RaS(2) '\times 10^' num2str(length(RaS)-1) '$'],'FontSize',TitleFS)
    
    ax = gca;
    ax.XAxis.FontSize = numFS;
    ax.YAxis.FontSize = numFS;
    if Pr == 1
        ax.Title.Position(1) = ax.Title.Position(1) + Tshift1;
    else
        ax.Title.Position(1) = ax.Title.Position(1) + Tshift2;
    end
    if type == 'd'
        ylabel('FFT$(\widehat \psi_{0,1})$', 'FontSize',LabelFS)
    end
    if Pr == 10
        xlabel('$f/(\kappa/d^2)$', 'FontSize',LabelFS)
    end
end

start = 3e-5;
diff = 13;
text(25.35,start,'$Pr= 1$','FontSize',TitleFS,'Rotation',  270)
text(25.35,start/diff,'$Pr= 10$','FontSize',TitleFS,'Rotation',  270)

saveas(gcf,[figpath2 'Freq.eps'], 'epsc')