set(0,'DefaultFigureColormap',feval('jet'));
Pr_list2 = [3 5 10 50 30 100 150 200 250 300];
data = GetExpAndPF(Pr_list2, 2, AllData);
ay = data.ay;
aE = data.aE;
Ay = data.Ay;
AE = data.AE;
ax = data.ax;
Ax = data.Ax;

PrRange = min(Pr_list2):max(Pr_list2);

%% Make some plots with exponents against each other
% Setting up figures
figure(1); % f vs g
set(gcf, 'Position',  [5 5 540 200])
figure(2); % F vs G
set(gcf, 'Position',  [5 5 540 200])
figure(3); % f vs F
set(gcf, 'Position',  [5 5 540 200])
figure(4); % g vs G
set(gcf, 'Position',  [5 5 540 200])
% Making colourmap
cmap = colormap(winter(length(Pr_list2)));
for i=1:length(Pr_list2)
    Pr = Pr_list2(i);
    figure(1), hold on
    plot(ay(i), aE(i), '*', 'Color',cmap((length(Pr_list2)-i+1),:),'DisplayName', num2str(Pr))
    if i == length(Pr_list2) 
        hold off, lgnd = legend('Location', 'Best'); title(lgnd,'$Pr$'), xlabel('$f(Pr)$', 'FontSize',14) , ylabel('$g(Pr)$', 'FontSize',14) 
    end
    figure(2), hold on
    plot(Ay(i), AE(i), '*', 'Color',cmap((length(Pr_list2)-i+1),:),'DisplayName', num2str(Pr))
    if i == length(Pr_list2) 
        hold off, set(gca,'yscale','log'),lgnd = legend('Location', 'Best'); title(lgnd,'$Pr$'), xlabel('$F(Pr)$', 'FontSize',14) , ylabel('$G(Pr)$', 'FontSize',14) 
    end
    figure(3), hold on
    plot(ay(i), Ay(i), '*', 'Color',cmap((length(Pr_list2)-i+1),:),'DisplayName', num2str(Pr))
    if i == length(Pr_list2) 
        hold off, lgnd = legend('Location', 'Best'); title(lgnd,'$Pr$'), xlabel('$f(Pr)$', 'FontSize',14) , ylabel('$F(Pr)$', 'FontSize',14) 
    end
    figure(4), hold on
    plot(aE(i), AE(i), '*', 'Color',cmap((length(Pr_list2)-i+1),:),'DisplayName', num2str(Pr))
    if i == length(Pr_list2) 
        hold off, set(gca,'yscale','log'),lgnd = legend('Location', 'Best'); title(lgnd,'$Pr$'), xlabel('$g(Pr)$', 'FontSize',14) , ylabel('$G(Pr)$', 'FontSize',14) 
    end
end

%% AE
figure('Renderer', 'painters', 'Position', [5 5 540 200])
plot(Pr_list2,AE,'x')
hold on
AEfit = feval(fit(reshape(Pr_list2,length(Pr_list2),1),reshape(AE,length(AE),1),'pchipinterp'),PrRange);
plot(PrRange, AEfit)
ylabel('$G(Pr)$', 'FontSize',14)
xlabel('$Pr$', 'FontSize',14)
set(gca, 'yscale','log')
hold off
%% aE
figure('Renderer', 'painters', 'Position', [5 5 540 200])
plot(Pr_list2,aE,'x')
hold on
aEfit = feval(fit(reshape(Pr_list2,length(Pr_list2),1),reshape(aE,length(aE),1),'pchipinterp'),PrRange);
plot(PrRange, aEfit)
ylabel('$g(Pr)$', 'FontSize',14)
xlabel('$Pr$', 'FontSize',14)
hold off
%% Ay
figure('Renderer', 'painters', 'Position', [5 5 540 200])
plot(Pr_list2,Ay,'x')
hold on
Ayfit = feval(fit(reshape(Pr_list2,length(Pr_list2),1),reshape(Ay,length(Ay),1),'pchipinterp'),PrRange);
plot(PrRange, Ayfit)
ylabel('$F(Pr)$', 'FontSize',14)
xlabel('$Pr$', 'FontSize',14)
hold off
%% ay
figure('Renderer', 'painters', 'Position', [5 5 540 200])
plot(Pr_list2,ay,'x')
hold on
ayfit = feval(fit(reshape(Pr_list2,length(Pr_list2),1),reshape(ay,length(ay),1),'pchipinterp'),PrRange);
plot(PrRange, ayfit)
ylabel('$f(Pr)$', 'FontSize',14)
xlabel('$Pr$', 'FontSize',14)
hold off
%% Ax
figure('Renderer', 'painters', 'Position', [5 5 540 200])
plot(Pr_list2,Ax,'x')
hold on
Axfit = feval(fit(reshape(Pr_list2,length(Pr_list2),1),reshape(Ax,length(Ax),1),'pchipinterp'),PrRange);
plot(PrRange, Axfit)
ylabel('$H(Pr)$', 'FontSize',14)
xlabel('$Pr$', 'FontSize',14)
hold off
%% ay
figure('Renderer', 'painters', 'Position', [5 5 540 200])
plot(Pr_list2,ax,'x')
hold on
axfit = feval(fit(reshape(Pr_list2,length(Pr_list2),1),reshape(ax,length(ax),1),'pchipinterp'),PrRange);
plot(PrRange, axfit)
ylabel('$h(Pr)$', 'FontSize',14)
xlabel('$Pr$', 'FontSize',14)
hold off
%% Make 2D plot 
Normalise = 0;
UseEx = 1;
TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)


RaRange = logspace(4, 9,1000);

[X,Y] = meshgrid(RaRange,PrRange);
% Making the factors in format we want
[X,AEfit2] = meshgrid(RaRange,AEfit);
[X,aEfit2] = meshgrid(RaRange,aEfit);
[X,Ayfit2] = meshgrid(RaRange,Ayfit);
[X,ayfit2] = meshgrid(RaRange,ayfit);
[X,Axfit2] = meshgrid(RaRange,Axfit);
[X,axfit2] = meshgrid(RaRange,axfit);


E = AEfit2.*X.^aEfit2;
Ey = Ayfit2.*X.^ayfit2;
Ex = log(Axfit2.*X.^axfit2).^2;
if not(UseEx)
    Ex = E - Ey;
end

figure
if Normalise
    ExE = (Ex)./E;
    if not(UseEx)
        ExE(ExE<0.5) = 0.5;
    end
    surf(X,Y,ExE);
    title('$\frac{E_x}{E}$', 'FontSize',20)
else
    if not(UseEx)
        change = find(Ex < E/2);
        for i=1:length(change)
            index = change(i);
            Ex(index) = E(index)/2;
        end
    end
    surf(X,Y,Ex);
    set(gca,'ColorScale','log')
    title('$E_x$', 'FontSize',20)
end
hold on
shading interp
colorbar()
set(gca,'XScale','log')
set(gca,'yScale','log')
xlabel('$Ra$', 'FontSize',14)
ylabel('$Pr$', 'FontSize',14)
view(2)
ylim([min(Pr_list2) max(Pr_list2)])
hold off
clearvars -except AllData
