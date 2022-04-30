run Params.m
run SomeInputStuff.m
path = convertStringsToChars(AllData.(ARS).(PrS).(RaS).path);
%Ra = 6e4;
%Pr = 6.2;
%path = '/Volumes/Samsung_T5/EigComp/Pr_6_2/Ra_6e4';
kpsmodes1 = importdata([path '/Checks/kpsmodes1.txt']);
% if not(exist('type','var'))
%     type = input('ps or theta? Input as char ');
% end
% 
% if convertCharsToStrings(type) == "ps"
%    Table = ['kpsmodes' num2str(mrow)];
%    label = join(["$\psi$, " Mode],"");
%    type = [type 'i']; % For label later
% elseif convertCharsToStrings(type) == "theta"
%    Table = ['kthetamodes' num2str(mrow)];
%    label = join(["$\theta$" Mode],"");
% end
% Table = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/' Table '.txt']);
%t = Table(:,1);
%Signal = Table(:,mcolumn+1);
t = kpsmodes1(:,1);
Signal = kpsmodes1(:,2);

try 
    xlower =  AllData.(ARS).(PrS).(RaS).ICT;
catch
    xlower = input('xlower? (input number) ');
end
try
    kappa = AllData.(ARS).(PrS).(RaS).kappa;
catch
    kappa = sqrt((pi^3/(Ra*Pr)));
end
t = t(xlower:end); t = t/(pi^2/kappa);
Signal = Signal(xlower:end);

% Plot spectra
figure('Renderer', 'painters', 'Position', [5 5 540 200])
subplot(1,2,1)
L = length(Signal);
tdiff = diff(t);
T = mean(tdiff);
Fs = 1/T;
Y = fft(Signal);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
semilogy(f, P1, '-o');
xlim([10 40])
%sgtitle(join(['$' AllData.(ARS).(PrS).(RaS).title '$'],""), 'FontSize', 15);
%xlabel('Frequency (Hz)', 'FontSize', 14)
xlabel('Frequency', 'FontSize', 14)
subplot(1,2,2)
plot(t, Signal)
xlabel('$t (d^2/\kappa)$', 'FontSize', 14)
ylabel('$\hat \psi_{0,1}$', 'FontSize', 14)
%xlim([1 2])

%clearvars -except AllData