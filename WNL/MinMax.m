datapath = '/Volumes/Samsung_T5/OldData/WNLData.mat';
load(datapath)
fpath = '/Users/philipwinchester/Dropbox/Matlab/WNL/Functions';
addpath(fpath)
G = 2;
GS = GtoGS(G);
As = WNLData.(GS).As;
Fs = WNLData.(GS).Fs;
sigmas = WNLData.(GS).sigmas;
alph = @(A,r) interp1(As,sigmas,A)./(A.*(r-A.^2));
bet = @(A) interp1(As,sigmas,A)./interp1(As,Fs,A);
Astar = fzero(@(A) bet(A),83.1);

%% 
r_list = 2.55e4:1e2:5e4;
thresh = 1e-7;
Amin_list = [];
Amax_list = [];
Bmax_list = [];
x = [0 7];
eps = 1e-2;
epsS = epstoepsS(eps)
for i=1:length(r_list)
    i
    r = r_list(i);
    x(1) = sqrt(r);
    done = 0;
    while not(done)
         J = Jacobian2(As, Fs, sigmas,x(2));

         fx = eval2(bet,r,x(2));
         dx = fx/J;
         x(2) = x(2) - dx; % NR
         if max(abs(dx)) < thresh
             done = 1;
         end
    end
    Amax_list = [Amax_list x(1)];
    Amin_list = [Amin_list x(2)];
    int = integral(bet, Astar,x(1));
    B = (1/eps)*sqrt(2*int);
    Bmax_list = [Bmax_list B];
end
stip
%%
% r_list = [2e4:-1e2:1.53e4];
% Amax = 140;
% Amin = 20;
% x = [Amax Amin];
r_list = 1.53e4:1e2:2.54e4;
%r_list = [1.53e4];
Amax = 90;
Amin = 70;
% r_list = 2.55e4;
x = [Amax Amin];
% x = [160 7];
eps = 1e-2;
epsS = epstoepsS(eps)
thresh = 1e-5;
Amin_list = [];
Amax_list = [];
Bmax_list = [];
for i=1:length(r_list)
    i
    r = r_list(i);
    done = 0;
    while not(done)
         J = Jacobian(As, Fs, sigmas,r,x(1),x(2));
         fx = eval(alph,bet,r,x(1),x(2));
         
         dx = J\fx';
         x = x - dx'; % NR
         if max(abs(dx)) < thresh
             done = 1;
         end
    end
    Amax_list = [Amax_list x(1)];
    Amin_list = [Amin_list x(2)];
    int = integral(bet, Astar,x(1));
    B = (1/eps)*sqrt(2*int);
    Bmax_list = [Bmax_list B];
    % Getting ready to move up
    if i == 1
        x(1) = x(1)*1.06;
        x(2) = x(2)*0.93; 
    else
        upfact = Amax_list(end)/Amax_list(end-1);
        downfact = Amin_list(end)/Amin_list(end-1);
        x(1) = x(1)*upfact;
        x(2) = x(2)*downfact; 
    end
end
% WNLData.(GS).(epsS).r = r_list;
% WNLData.(GS).(epsS).Amax = Amax_list;
% WNLData.(GS).(epsS).Amin = Amin_list;
% WNLData.(GS).(epsS).Bmax = Bmax_list;
% 
%save(datapath, "WNLData")
% for i=1:length(Amax_list)-1
%     ratio_max(i) = Amax_list(i+1)/Amax_list(i);
%     ratio_min(i) = Amin_list(i+1)/Amin_list(i);   
% end
%% figure
figpath = '/Users/philipwinchester/Desktop/Figures/';
TE = "latex";
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
%set(0,'defaultaxesfontsize',19,'defaultaxeslinewidth',.7, 'defaultlinelinewidth',.8,'defaultpatchlinewidth',.7, 'defaultlegendfontsize', 16)
TitleFS = 22;
LabelFS = 21;
lgndFS = 16;
numFS = 17;
MarkerS = 15;

figure('Renderer', 'painters', 'Position', [5 5 700 300])
plot([1.52e4 WNLData.(GS).(epsS).r],[Astar WNLData.(GS).(epsS).Amax],'DisplayName', "$A_{max}$"), hold on
plot([1.52e4 WNLData.(GS).(epsS).r],[Astar WNLData.(GS).(epsS).Amin],'DisplayName', "$A_{min}$")
plot([1.52e4 WNLData.(GS).(epsS).r],[sqrt(1.52e4) (WNLData.(GS).(epsS).r).^(0.5)],'DisplayName', "$\sqrt{r}$")
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$r$', 'FontSize', LabelFS)
legend('Location', 'Best', 'FontSize', numFS);
saveas(gcf,[figpath 'A.eps'], 'epsc')
figure('Renderer', 'painters', 'Position', [5 5 700 300])
plot([WNLData.(GS).(epsS).r],[WNLData.(GS).(epsS).Bmax])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$r$', 'FontSize', LabelFS)
ylabel('$B_{max}$', 'FontSize', LabelFS)
%saveas(gcf,[figpath 'B.eps'], 'epsc')





%% Functions


function J = Jacobian(As, Fs, sigmas,r,Amax,Amin)
    sigmax = interp1(As,sigmas,Amax);
    lammax = interp1(As,Fs,Amax);
    sigmin = interp1(As,sigmas,Amin);
    lammin = interp1(As,Fs,Amin);
    J(1,1) = sigmax/(Amax*(r-Amax^2));
    J(1,2) = -sigmin/(Amin*(r-Amin^2));
    J(2,1) = sigmax/lammax;
    J(2,2) = -sigmin/lammin;
end

function fx = eval(alph,bet,r,Amax,Amin)
    fx(1) = integral(@(A) alph(A,r), Amin, Amax);
    fx(2) = integral(bet, Amin, Amax);
end


function J = Jacobian2(As, Fs, sigmas,Amin)
    sigmin = interp1(As,sigmas,Amin);
    lammin = interp1(As,Fs,Amin);
    J = -sigmin/lammin;
end

function fx = eval2(bet,r,Amin)
    fx = integral(bet, Amin, sqrt(r));
end
