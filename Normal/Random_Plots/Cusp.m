%% data
AR = 2;
Pr = 1;
Ra = 6.4e6;
run SomeInputStuff.m
kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
kappa = AllData.(ARS).(PrS).(RaS).kappa;
ZeroOne = 2*kpsmodes1(:,2)/kappa;
t = kpsmodes1(:,1)/(pi^2/kappa);
mm = 20;
FS = 20;
%% clean before peaks
PeakSeries = abs(movmean(ZeroOne,mm));
thresh = 400;
PeakSeries(PeakSeries < thresh ) = 0;
% figure()
% plot(t, PeakSeries)
%% get peaks
[~,locs] = findpeaks(PeakSeries);
figure()
plot(t,ZeroOne)
hold on
plot(t(locs), ZeroOne(locs), 'r*')
ax = gca;
ax.XAxis.FontSize = FS;
ax.YAxis.FontSize = FS;
xlabel('$t/((\pi d)^2/\kappa)$', 'FontSize', FS)
ylabel('$\widehat \psi_{0,1}/\kappa$', 'FontSize', FS)
title('(Pr, Ra, $\Gamma)=($1, $6.4\times 10^6$, $2)$','Fontsize',FS)
%% plot tcusp map
tlocs = t(locs);
d = diff(tlocs);
figure()
hold on
for i=1:length(d)-1
    plot(d(i), d(i+1), 'b*')
end
ax = gca;
ax.XAxis.FontSize = FS;
ax.YAxis.FontSize = FS;
xlabel('$t(M_n)$', 'FontSize', FS)
ylabel('$t(M_{n+1})$', 'FontSize', FS)
%% plot cusp map
pks = movmean(ZeroOne,mm); pks = pks(locs); % maybe should not do the movmean here?
figure()
hold on
for i=1:length(pks)-1
    plot(pks(i), pks(i+1), 'b*')
end
ax = gca;
ax.XAxis.FontSize = FS;
ax.YAxis.FontSize = FS;
xlabel('$M_n/\kappa$', 'FontSize', FS)
ylabel('$M_{n+1}/\kappa$', 'FontSize', FS)
title('(Pr, Ra, $\Gamma)=($1, $6.4\times 10^6$, $2)$','Fontsize',FS)