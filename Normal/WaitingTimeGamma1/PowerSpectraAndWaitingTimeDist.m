run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
G = 1;
ARS = ['AR_' num2str(G)];
Pr = 30;
PrS = ['Pr_' num2str(Pr)];
Ra = 5e5; RaS = normaltoS(Ra,'Ra',1); RaT = RatoRaT(Ra);
kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
xlower = AllData.(ARS).(PrS).(RaS).ICT;
t = kpsmodes1(:,1); t = t(xlower:end);
s = kpsmodes1(:,2); s = s(xlower:end);
%% Get waiting time
thresh = mean(abs(s));
Status = sign(s(1));
timesSwitch = [t(1)];
for j=2:length(s)
    if Status == 1 % we are positive and going negative
        if s(j) < -thresh % we have switched!
            Status = -1;
            timesSwitch = [timesSwitch t(j)];
        end
    else % we are negative and going posiive
        if s(j) > thresh % we have switched!
            Status = 1;
            timesSwitch = [timesSwitch t(j)];
        end
    end
    
end
WaitingTimes = diff(timesSwitch);
%%
[f, P1] = GetSpectra(s, t);
%%
figure()
subplot(2,1,1)
loglog(f,P1,'HandleVisibility','off'), hold on
xlabel('$f$')
ylabel('$S(f)$')
% add lines to guied the eye
alpha = 1;
x1 = 5e-4;
y1 = 1e-2;
x2 = 1e-2;
A = y1/x1^(-alpha);
y2 = A*x2^(-alpha);
plot([x1 x2], [y1 y2],'--k','DisplayName',['$\alpha = ' num2str(alpha) '$']);

alpha = 5;
x1 = 1e-1;
y1 = 5e-5;
x2 = max(f);
A = y1/x1^(-alpha);
y2 = A*x2^(-alpha);
plot([x1 x2], [y1 y2],'--r','DisplayName',['$\alpha = ' num2str(alpha) '$']);
legend('Location','bestoutside')



subplot(2,1,2)
eps = 0.1;

nbins = 15;
barriers = logspace(log10(min(WaitingTimes)-eps), log10(max(WaitingTimes)),nbins+1);
y = zeros(1,nbins);
x = zeros(1,nbins);
for i=1:length(barriers)-1
    x(i) = (barriers(i) + barriers(i+1))/2;
end

for i=1:length(WaitingTimes)
    wt = WaitingTimes(i);
    for j=1:length(barriers)
       if wt <  barriers(j)
           y(j-1) = y(j-1) + 1;
           break
       end
    end
end
loglog(x,y,'.b','HandleVisibility','off'), hold on
yticks([1 10])
% guide the eye
beta = 2.8;
x1 = x(end-4);
y1 = 31;
x2 = x(end);
A = y1/x1^(-beta);
y2 = A*x2^(-beta);
plot([x1 x2], [y1 y2],'--k','DisplayName',['$\beta = ' num2str(beta) '$']);
legend('Location','bestoutside')
xlabel('$\tau$')
ylabel('$P(\tau)$')
sgtitle(['$Ra = ' RaT ',\,Pr = ' num2str(Pr) ',\, \Gamma = ' num2str(G) '$'])
saveas(gcf,[figpath 'PSWT_' RaS '_' PrS '_' ARS], 'epsc')


