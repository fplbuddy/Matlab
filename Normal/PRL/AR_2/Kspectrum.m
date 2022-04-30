run SetUp.m
AR = 2;
Pr = 30;
Ra = 6.4e6;
xlower = 3000;
run SomeInputStuff.m
files = ["Ekspectrum" "Epspectrum"];

urms = AllData.(ARS).(PrS).(RaS).urms;
NDs = [(1/urms)^2 1];
PrintTimes = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Spectra/spec_times.txt']);
Times = PrintTimes(:,2);
Prints = PrintTimes(:,1);
Times(Times<xlower) = [];
Prints= Prints(end-length(Times)+1:end);
num = length(Prints);
result = zeros(242,2);
% for j=1:2
% file = convertStringsToChars(files(j));
% ND = NDs(j);
% for i=1:num
%     Print = num2str(Prints(i));
%     while length(Print) < 4
%        Print = ['0' Print];
%     end
%     Data = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Spectra/' file '.' Print '.txt']);
%     Data = Data(:,2);
%     result(:,j) = result(:,j) + Data; % Adding to reults
% end
% result(:,j) = result(:,j)*ND/num; % non-dim and average
% end

% try instantanious
for j=1:2
file = convertStringsToChars(files(j));
ND = NDs(j);
Print = '21';
while length(Print) < 4
   Print = ['0' Print];
end
Data = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Spectra/' file '.' Print '.txt']);
Data = Data(:,2);
result(:,j) = result(:,j) + Data; % Adding to reults

result(:,j) = result(:,j)*ND; % non-dim and average
end


%% Get stuff for f spectrum also
kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
ICT = AllData.(ARS).(PrS).(RaS).ICT;
t = kpsmodes1(:,1); t = t(ICT:end);
OneOne = kpsmodes1(:,2); OneOne = OneOne(ICT:end);
urms = AllData.(ARS).(PrS).(RaS).urms;
h = pi;

% non dim and get spectra
OneOne = 2*OneOne/(h*urms); % 2 because of error in DNS...
t = t/(h/urms);

OneOneShearing = OneOne(1:1e5); tShearing = t(1:1e5);
OneOneNonShearing = OneOne(2e5:3e5); tNonShearing = t(2e5:3e5);

[fS, PS] = GetSpectra(OneOneShearing, tShearing);
[fNS, PNS] = GetSpectra(OneOneNonShearing, tNonShearing);
% power = (P1.^2)*length(OneOne);

%% Make plot
figure('Renderer', 'painters', 'Position', [5 5 700 600])
subplot(2,2,1)
loglog(result(:,1) , 'Color', [0 0.5 0])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$K$', 'FontSize', LabelFS)
ylabel('$\widehat E^k/u_{rms}^2$', 'FontSize', LabelFS)
ylim([1e-8 1e0])
xlim([1 100])
yticks([1e-8 1e-6 1e-4 1e-2 1])
text(5e1, 2e-1, '(a)',  'FontSize', LabelFS)
%
subplot(2,2,2)
loglog(result(:,2) , 'Color', [0 0.5 0])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$K$', 'FontSize', LabelFS)
ylabel('$\widehat E^{\theta}/(\Delta T)^2$', 'FontSize', LabelFS)
ylim([1e-9 1e-1])
xlim([1 100])
xticks([1 10 100])
yticks([1e-9 1e-7 1e-5 1e-3 1e-1])
sgtitle('Ra $= 6.4 \times 10^6$, Pr $= 30$', 'Fontsize',TitleFS)
text(5e1, 2e-2, '(b)',  'FontSize', LabelFS)
%
subplot(2,2,3)
loglog(fS,PS, 'Color', [0 0.5 0]);
xlim([0 10]);
ylim([1e-6 1e-2]);
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylabel('FFT$(\widehat \psi_{0,1})/(\pi du_{rms})$', 'Fontsize', LabelFS)
xlabel('$f/(u_{rms}/\pi d)$', 'Fontsize', LabelFS)
text(2.5, 4.5e-3, '(c)',  'FontSize', LabelFS)
yticks([1e-6 1e-4 1e-2])
xticks([1e-3 1e-1 10])
title('Shearing', 'Fontsize',TitleFS)
%
subplot(2,2,4)
loglog(fNS,PNS, 'Color', [0 0.5 0]);
xlim([0 10]);
ylim([1e-5 1e-1]);
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
%ylabel('FFT$(\widehat \psi_{0,1})$', 'Fontsize', LabelFS)
xlabel('$f/(u_{rms}/\pi d)$', 'Fontsize', LabelFS)
text(2.5, 4.5e-2, '(d)',  'FontSize', LabelFS)
yticks([1e-5 1e-3 1e-1])
xticks([1e-3 1e-1 10])
title('Non-Shearing', 'Fontsize',TitleFS)