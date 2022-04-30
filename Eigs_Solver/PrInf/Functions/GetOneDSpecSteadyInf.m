function [thetaSpec,xdata] = GetOneDSpecSteadyInf(Data,Nx,Ny,G,Ra)
% do jumps of max(pi,pi*2/Gamma)
jump = max(pi,pi*2/G);
% Do jumps of pi, ie K = n, take everything from [n-pi/2,n+pi/2).
%% Getting data
AR = ['AR_' strrep(num2str(G),'.','_')];
type = ['N_' num2str(Nx) 'x' num2str(Ny)];
RaS = RatoRaS(Ra);
ThetaE = Data.(AR).(type).(RaS).ThetaE;
%% Calc
[~,~,n,m] = GetRemKeep_nxny(Nx,Ny,1);
K_list = sqrt((2*pi*n/G).^2+(m*pi).^2);
Kmax = ceil(max(K_list))/jump;
thetaSpec = zeros(round(Kmax),1);
for i=1:length(n)
    K = K_list(i);
    loc = round(K/jump);
    if n(i) == 0
        two = 1;
    else
        two =2;
    end
    thetaSpec(loc) =thetaSpec(loc)+(abs(ThetaE(i))^2)*two;
end
xdata = jump*(1:length(thetaSpec));
end

