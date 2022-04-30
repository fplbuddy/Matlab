%% Getting data
N = 400;
G = 2;
AR = ['AR_' num2str(G)];
type = ['OneOne' num2str(N)];
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Cluster_v3/Functions/';
addpath(fpath)
Pr = 12;
Ra = 3e5;
PrS = PrtoPrS(Pr);
RaS = RatoRaS(Ra);
PsiE = Data.(AR).(type).(PrS).(RaS).PsiE;
ThetaE = Data.(AR).(type).(PrS).(RaS).ThetaE;

%% Calc
n = [1:2:(N/2-1) 0:2:(N/2-2)]; n = repmat(n, N/2); n = n(1,:);
m = 1:N; m = repelem(m, N/4);
Kmin = (4 + (N/2-2)^2)^0.5;
Kenergy = zeros(round(Kmin),1);
Penergy = zeros(round(Kmin),1);
for i=1:length(n)
   ninst = n(i); minst = m(i);
   K = (ninst^2 + minst^2)^0.5;
   loc = round(K);
   if K <= Kmin
      Kenergy(loc) = Kenergy(loc)+abs(PsiE(i))^2*(ninst*2*pi/G)^2*two(ninst);
      Penergy(loc) = Penergy(loc)+abs(ThetaE(i))^2*two(ninst);       
   end
    
end

%% Plot
% Kenergy 
figure('Renderer', 'painters', 'Position', [5 5 540 200])
semilogy(Kenergy.*reshape((1:round(Kmin)).^2, round(Kmin),1))
figure('Renderer', 'painters', 'Position', [5 5 540 200])
semilogy(Penergy.*reshape((1:round(Kmin)).^2, round(Kmin),1))

%% Functioms
function two = two(n)
    if n == 0
        two = 1;
    else
        two = 2;
    end
end