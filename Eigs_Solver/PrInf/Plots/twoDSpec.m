run SetUp.m
%% Getting data
dpath = '/Volumes/Samsung_T5/OldData/PrInfData.mat';
load(dpath);
Nx = 152;
Ny = 152;
G = 1.9;
AR = ['AR_' strrep(num2str(G),'.','_')];
type = ['N_' num2str(Nx) 'x' num2str(Ny)];
Ra = 2e5;
RaS = RatoRaS(Ra);
ThetaE = PrInfData.(AR).(type).(RaS).ThetaE;

%% Calc
[~,~,n,m] = GetRemKeep_nxny(Nx,Ny,1);
Penergy = zeros(max(n)+1, max(m));
for i=1:length(n)
   ninst = n(i); minst = m(i);
   Penergy(ninst+1, minst) = abs(ThetaE(i))^2*two(ninst);       
end

%% Plot
figure('Renderer', 'painters', 'Position', [5 5 400 300])
pcolor(Penergy');
colormap('jet')
colorbar
caxis([1e-25, max(max(Penergy))])
set(gca,'ColorScale','log')
xlabel('$k_x$', 'FontSize', 16)
ylabel('$k_y$', 'FontSize', 16)

%% Functions
function two = two(n)
    if n == 0
        two = 1;
    else
        two = 2;
    end
end