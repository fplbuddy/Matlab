% Input
AR = 2;
Pr = 50;
run SomeInputStuff.m
Ra_list = string(fieldnames(AllData.(ARS).(PrS)));
XPosShear = []; YPosShear = []; errPosShear = [];
XNegShear = []; YNegShear = []; errNegShear = [];
XNoShear = []; YNoShear = []; errNoShear = [];
for i=1:length(Ra_list)
    RaS = Ra_list(i);
    if isfield(AllData.(ARS).(PrS).(RaS),'ICT')
        PosShear = []; NegShear = []; NoShear = [];
        kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
        ZeroOne = kpsmodes1(:,2); ZeroOne = ZeroOne(AllData.(ARS).(PrS).(RaS).ICT:end);
        % Getting PosShear
        PosShearDP = AllData.(ARS).(PrS).(RaS).calcs.pos;
        for i=1:length(PosShearDP)
            section = PosShearDP{i};
            PosShear = [ZeroOne(section)
                PosShear];
        end
        if length(PosShear) > 1
            XPosShear = [AllData.(ARS).(PrS).(RaS).Ra XPosShear];
            YPosShear = [mean(PosShear) YPosShear];
            errPosShear = [std(PosShear) errPosShear];
        end
        % Getting NegShear
        NegShearDP = AllData.(ARS).(PrS).(RaS).calcs.neg;
        for i=1:length(NegShearDP)
            section = NegShearDP{i};
            NegShear = [ZeroOne(section)
                NegShear];
        end
        if length(NegShear) > 1
            XNegShear = [AllData.(ARS).(PrS).(RaS).Ra XNegShear];
            YNegShear = [mean(NegShear) YNegShear];
            errNegShear = [std(NegShear) errNegShear];
        end
        % Getting NoShear
        NoShearDP = AllData.(ARS).(PrS).(RaS).calcs.zero;
        for i=1:length(NoShearDP)
            section = NoShearDP{i};
            section(section > length(ZeroOne)) = [];
            NoShear = [ZeroOne(section)
                NoShear];
        end
        if length(NoShear) > 1
            XNoShear = [AllData.(ARS).(PrS).(RaS).Ra XNoShear];
            YNoShear = [mean(NoShear) YNoShear];
            errNoShear = [std(NoShear) errNoShear];
        end
    end
end

figure('Renderer', 'painters', 'Position', [5 5 540 200])
EBF = 1.5;
errorbar(XPosShear,YPosShear,errPosShear*EBF,'r*'); hold on
errorbar(XNegShear,YNegShear,errNegShear*EBF,'r*');
errorbar(XNoShear,YNoShear,errNoShear*EBF,'b*');
set(gca, 'XScale', 'log'); %hold off
title(['$Pr = ' num2str(Pr) '$'], 'FontSize', 15)
ylabel('$ \hat \psi_{0,1}$','FontSize', 14)
xlabel('$Ra$','FontSize', 14)
clearvars -except AllData
%% Other stuff
X = XNegShear;
Y = abs(YNegShear);

[X, I] = sort(X); Y = Y(I);
figure('Renderer', 'painters', 'Position', [5 5 540 200])
loglog(X(1:12),Y(1:12), 'r*'), hold on
[alpha, A, xFitted, yFitted, Rval] = FitsPowerLaw(X(1:12),Y(1:12));
plot(xFitted, yFitted, 'black--') 
xlim([1e4 1e5])
title('$Pr = 1$', 'FontSize', 15)
xlabel('$Ra$', 'FontSize', 14)
ylabel('$\mid \hat \psi_{0,1} \mid$', 'FontSize', 14)
gtext(['$\mid \hat \psi_{0,1} \mid \propto Ra^{'  num2str(alpha,3) '}$'],'FontSize',17,'color', 'black')
loglog(X(13:15),Y(13:15), 'r*')

%% Other stuff 2
Ra = 'Ra_3e4';
EBF = 1.5;
xlower = 1000;
kpsmodes1 = importdata(['/Volumes/Samsung_T5/Residue/64x64/Pr_1/' Ra '/Checks/kpsmodes1.txt' ]);
RaV = str2num(Ra(end-2:end));
Signal = kpsmodes1(:,2); t = kpsmodes1(:,1);
Signal = Signal(xlower:end); t = t(xlower:end);
Y = MyMeanEasy(Signal, t);
err = std(Y);
errorbar(RaV,Y,err*EBF,'b*'); hold on