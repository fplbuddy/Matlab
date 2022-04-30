% Getting functions we need
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
fpath2 = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrZero/Functions/';
fpath3 = '/Users/philipwinchester/Dropbox/Matlab/Normal/Functions/';
fpath4 = '/Users/philipwinchester/Dropbox/Matlab/Low_Dim/Functions';
addpath(fpath)
addpath(fpath2)
addpath(fpath3)
addpath(fpath4)

path = '/Volumes/Samsung_T5/OldData/LowDim.mat';
load(path)
%%
tic
G = 2;
RaC = 8*pi^4;
RaA_list = [3];
Pr_list = [1e-2];
tupper = 2*10^5;
gaps = 100;
last = 1;
for RaA = RaA_list
    % calculate steady state
    [psi1,theta1,theta2] = steadyNew(RaA);
    x0 = [psi1,theta1,theta2];
    delta = min(abs([psi1,theta1,theta2]))/10;
    for Pr = Pr_list
        Ra = RaC + RaA
        M = MakeMatrixLowDim(G, 1i*psi1, theta1, Ra, Pr);
        [v,eigs] =  eig(M);
        eigs = diag(eigs);
        
        % picking out eig with largest real part
        [eigMax,I] = max(real(eigs));
        v = v(:,I); % picking up vector
        delta = min(abs(x0))/(max(abs(v))*100);
        v = v*delta;
        
        PrS = PrtoPrSZero(Pr);
        kappa = sqrt(pi^3/(Ra*Pr));
        tmax = tupper*kappa/pi^2;
        RaAS = RaAtoRaAS(RaA);
        %y = SolveODEfunc(G,Ra,Pr,[0 psi1 real(v(2)) imag(v(3)) v(1) theta1 0 real(v(4)) imag(v(5)) theta2],[0 tmax]);
        if last % we continue on what we already have
            y0 = results.(RaAS).(PrS).y(:,end)';
            y = SolveODEfunc2(G,Ra,Pr,y0,[0 tmax]);
            % getting peaks which we will add to what we save
            ZeroOne = y.y(3,:);
            ll = length(ZeroOne);
            [~,locs] = findpeaks(ZeroOne);
            
            
            want = [1:gaps:ll locs];
            want = sort(want);
            
            results.(RaAS).(PrS).t = [results.(RaAS).(PrS).t y.x(want)+results.(RaAS).(PrS).t(end)];
            y = y.y;
            y = y(:,want);
            results.(RaAS).(PrS).y = [results.(RaAS).(PrS).y y];          
        else
            y0 = [psi1 real(v(2)) v(1) theta1 imag(v(5)) theta2];
            y = SolveODEfunc2(G,Ra,Pr,y0,[0 tmax]);
            % getting peaks which we will add to what we save
            ZeroOne = y.y(3,:);
            ll = length(ZeroOne);
            [~,locs] = findpeaks(ZeroOne);
            
            want = [1:gaps:ll locs];
            want = sort(want);
            
            results.(RaAS).(PrS).t = y.x(want);
            y = y.y;
            y = y(:,want);
            % removing stuff
            results.(RaAS).(PrS).y = y;
            
        end
    end
end
toc
save(path,'results')
stop
%% do some anal
y = results.RaA_1e1.Pr_1e_2.y(3,:);
t = results.RaA_1e1.Pr_1e_2.t;
figure()
plot(t,y,'-o')
[~,locs] = findpeaks(y);
hold on
plot(t(locs),y(locs),'r*')
