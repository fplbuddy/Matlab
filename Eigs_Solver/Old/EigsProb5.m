% Check if the stead even solution is stable to even pertubations

%steadypositioneven(N, 8, 8)
%stop

%% Getting steady state and solving corresponding eigenvalue problem



%% Soling eigenvalue problem when we already have steady solutions
addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/Functions'); % So that we can use the functions
TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
OldData = load('/Volumes/Samsung_T5/OldData/Pr30Correct.mat');
Pr = 30;
PrS = PrtoPrS(Pr);
%RaS_list = string(fieldnames(OldData.Data));
RaS_list = ["Ra_4_74e4" "Ra_4_75e4" "Ra_4_76e4" "Ra_4_77e4" "Ra_4_78e4"];
for i=1:length(RaS_list)
   i
   RaS = convertStringsToChars(RaS_list(i));
   Ra = RaStoRa(RaS);
   NewData.(PrS).(RaS).Ra = Ra;
   NewData.(PrS).(RaS).Pr = Pr;
   PsiE = OldData.Data.Pr_30.(RaS).PsiE;
   ThetaE = OldData.Data.Pr_30.(RaS).ThetaE;
   [V, sigma] = eigensolvereven(PsiE, ThetaE, 32, 2, Pr, Ra);
   NewData.(PrS).(RaS).V = V; 
   NewData.(PrS).(RaS).sigma = diag(sigma);
end

%% Functions
function [V, sigma] = eigensolvereven(PsiE, ThetaE, N, G, Pr, Ra)
kx = [(-N/2+1):2:(N/2-1) (-N/2):2:(N/2-2)]; kx = repmat(kx, N);  kx = kx(1,:)*2*pi/G; % N rather than N/2 as we want theta also
ky = 1:N; ky = repelem(ky, N/2); ky = repmat(ky, 2); ky = ky(1,:)*pi;
Ktwo = kx.^2 + ky.^2;
kx = diag(kx); ky = diag(ky); Ktwo = diag(Ktwo);

% Easy ones
M2 = -1i*Ra*Pr*inv(Ktwo)*kx*[zeros((N^2/2),(N^2/2)) eye((N^2/2)); zeros((N^2/2),(N^2/2)) zeros((N^2/2),(N^2/2))];
M3 = -Pr*Ktwo*[eye((N^2/2)) zeros((N^2/2),(N^2/2)); zeros((N^2/2),(N^2/2)) zeros((N^2/2),(N^2/2))];
M5 = 1i*kx*[zeros((N^2/2),(N^2/2)) zeros((N^2/2),(N^2/2)); eye((N^2/2)) zeros((N^2/2),(N^2/2))];
M6 = -Ktwo*[zeros((N^2/2),(N^2/2)) zeros((N^2/2),(N^2/2)); zeros((N^2/2),(N^2/2)) eye((N^2/2))];

% Hard ones
kx_list = diag(kx); ky_list = diag(ky);
kx_list = kx_list(1:(length(kx_list)/2)); ky_list = ky_list(1:(length(ky_list)/2));
psi1 = zeros((N^2/2),(N^2/2)); psi2 = zeros((N^2/2),(N^2/2)); theta1 = zeros((N^2/2),(N^2/2));
for i=1:length(kx_list)
    ninst = round(kx_list(i)*G/(2*pi)); minst = round(ky_list(i)/pi);
    OnesWeWant = checkeeeven(N,ninst,minst);
    for j=1:length(OnesWeWant)
        modes = OnesWeWant(j,:);
        npert = modes(1); mpert = modes(2); nsteady = modes(3); msteady = modes(4);
        columninst = columnfindeven(N, npert, mpert);
        % Getting factors        
        if nsteady == -N/2; PsiFact = 0; ThetaFact = 0; else; steadypos = steadypositioneven(N, abs(nsteady), msteady); PsiFact = PsiE(steadypos); ThetaFact = ThetaE(steadypos); end
        % in the above, we have the steadyposfind behind the else, since it
        % breaks for nsteady == -N/2
        if sign(nsteady) == -1; PsiFact = conj(PsiFact); ThetaFact = conj(ThetaFact); end % Getting conjugate if needed
        AFact = Aeven(npert, mpert, nsteady, msteady,G, minst);
        
        % Adding to psi1
        psi1(i,columninst) = psi1(i,columninst) + (Squareeven(npert,mpert,G) - Squareeven(nsteady,msteady,G))*AFact*PsiFact;
        % Adding psi2
        psi2(i,columninst) = psi2(i,columninst) + AFact*ThetaFact;
        % Adding theta1 
        theta1(i,columninst) = theta1(i,columninst) - AFact*PsiFact; 
    end
end
M1 = (1i/2)*inv(Ktwo)*[psi1 zeros((N^2/2),(N^2/2)); zeros((N^2/2),(N^2/2)) zeros((N^2/2),(N^2/2))];
M4 = (-1i/2)*[zeros((N^2/2),(N^2/2)) zeros((N^2/2),(N^2/2)); psi2 theta1];

M = M1 + M2 + M3 + M4 + M5 + M6;

[V,sigma] = eig(M);
end

function res = checkeeeven(N, ninst, minst)
    n = [-(N/2-1):2:(N/2-1) -(N/2):2:(N/2-2)]; n = repmat(n, N/2); n = n(1,:); % We want the negative ones here also, they might not appear actually... they will!
    m = 1:N; m = repelem(m, N/2); % Hava included -(N/2) even though it does not technically exist. Should think about what i do for this in v4
    res = [];
    for i=1:length(n)
        n1 = n(i); m1 = m(i);
        for j=1:length(n)
            n2 = n(j); m2 = m(j);
            if ninst == n2 + n1 && (minst == m1 + m2 || minst == abs(m1 - m2)) && not(n1 == n2 && m1 == m2)
                s = size(res);
                res(s(1)+1, 1) = n1; res(s(1)+1, 2) = m1; res(s(1)+1, 3) = n2; res(s(1)+1, 4) = m2;
            end
        end
    end
end

function pos = steadypositioneven(N, ninst, minst)
    n = [1:2:(N/2-1) 0:2:(N/2-2)]; n = repmat(n, N/2); n = n(1,:);
    m = 1:N; m = repelem(m, N/4);
    for i=1:length(n)
       ncheck = n(i); mcheck = m(i);
       if ninst == ncheck && minst == mcheck
           pos = i;
       end
    end
end

function f = feven(a,b,c)
    if a == b + c
        f = -1;
    else
        f = 1;
    end
end

function A = Aeven(npert, mpert, nsteady, msteady,G, minst)
    A = (pi^2*2/G)*(npert*msteady*feven(msteady, mpert, minst)-mpert*nsteady*feven(mpert, msteady, minst));
end

function S = Squareeven(ninst,minst,G)
    S = (ninst^2)*(2*pi/G)^2 + (minst*pi)^2;
end

function pos = columnfindeven(N,ninst,minst)
    n = [(-N/2+1):2:(N/2-1) (-N/2):2:(N/2-1) ]; n = repmat(n, N/2);  n = n(1,:);
    m = 1:N; m = repelem(m, N/2); m = m(1,:);
    for i=1:length(n)
       ncheck = n(i); mcheck = m(i);
       if ninst == ncheck && minst == mcheck
           pos = i;
       end
    end
end
