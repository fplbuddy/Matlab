run Params.m
run SomeInputStuff.m

% Getting the data, currently it only does psi
data = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes' num2str(mrow) '.txt' ]);
signal = data(:,mcolumn + 1);
t = data(:,1);

% Getting rid of transient 
if not(exist('xlower','var'))
    h = figure;
    plot(signal);
    xlabel('Step, not time')
    xlower = input('Where do we start? ');
    close(h)
end
signal = signal(xlower:end);
t = t(xlower:end);
if NDT
    t = AllData.(ARS).(PrS).(RaS).kappa/pi^2*t;
end

% Making plot
[y,x] = hist(signal, 1000);
figure('Renderer', 'painters', 'Position', [1 50 540 200])
subplot(1,2,1)
plot(t,signal)
if NDT
    xlabel("$t$ $(d^2/\kappa)$",'Interpreter','latex', 'FontSize', 13)
else
    xlabel("$t$ $(s)$",'Interpreter','latex', 'FontSize', 13)
end
ylabel(join(["$\psi$, " Mode],""),'Interpreter','latex', 'FontSize', 13)
%title("(g)" ,'Interpreter','latex', 'FontSize', 14)
subplot(1,2,2)
semilogy(x,y/length(signal),'-o')
xlabel(join(["$\psi$, " Mode],""),'Interpreter','latex', 'FontSize', 13)
ylabel("PDF",'Interpreter','latex', 'FontSize', 13)
%title("(h)" ,'Interpreter','latex', 'FontSize', 14)
%sgtitle(AllData.(ARS).(PrS).(RaS).title,'Interpreter','latex', 'FontSize', 14)
RaT = RatoRaT(AllData.(ARS).(PrS).(RaS).Ra);
sgtitle(['$Ra = ' RaT '$'], 'FontSize', 14)
clearvars -except AllData
