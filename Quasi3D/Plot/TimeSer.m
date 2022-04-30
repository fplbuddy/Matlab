run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
W = 0.02; Pr = 10; Ra = 2e9;
WS = normaltoS(W,'Ly',1); PrS = normaltoS(Pr,'Pr',1); RaS = normaltoS(Ra,'Ra',1);
Nx = 1024; Ny = 512;
NS = ['N_' num2str(Nx) 'x' num2str(Ny)];
type = 'Shearing';
IC = ['IC_' type(1)];
path = AllData.(IC).(NS).(PrS).(RaS).(WS).path;
penergy2 = importdata([path '/Checks/kenergy2.txt']);
%%
figure('Renderer', 'painters', 'Position', [5 5 540 450])
subplot(2,1,1)
[alpha, A, ~, ~, ~] = Fitslogy(penergy2(:,1),penergy2(:,2));
semilogy(penergy2(:,1), penergy2(:,2),'Color', 'b'), hold on
plot(penergy2(:,1), A*exp(alpha*penergy2(:,1)),'Color', 'r')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylabel('$<\theta^2_{\perp}>$','FontSize',labelFS)
WT = RatoRaT(W); RaT = RatoRaT(Ra); PrT = RatoRaT(Pr);
sgtitle(['$\Gamma_y=' WT ',\, Ra = ' RaT ',\, Pr = ' PrT '$' ', ' type], 'FontSize',labelFS)
WS = convertStringsToChars(WS); PrS = convertStringsToChars(PrS);  RaS = convertStringsToChars(RaS);

subplot(2,1,2)
plot(penergy2(:,1), log(penergy2(:,2)./exp(alpha*penergy2(:,1))),'Color', 'b')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$t\,  (s)$','FontSize',labelFS)
ylabel('$<\theta^2_{\perp}>/e^{\tilde{\sigma}t}$','FontSize',labelFS)
%close all
%figure()
%plot(penergy2(:,1), log(penergy2(:,2)./(A*exp(alpha*penergy2(:,1)))))

%saveas(gcf,[figpath 'Ly_' WS 'Ra_' RaS 'Pr_' PrS '_' type], 'epsc')