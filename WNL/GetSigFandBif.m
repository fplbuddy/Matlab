Treads = 1;
maxNumCompThreads(Treads);
maxNumCompThreads(Treads);
fpath = '/Users/philipwinchester/Dropbox/Matlab/WNL/Functions';
addpath(fpath)
dpath = '/Volumes/Samsung_T5/OldData/WNLData.mat';
load(dpath)
%%
prec = 5;
N = 128;
G_list = 2.37;
n = [-(N/2):2:(N/2-1) -(N/2-1):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:);
m = 1:N; m = repelem(m, N/2);
[~,~,n,m] = GetRemGeneral(n,m,N);
positionMatrix = MakePositionMatrix(n,m);
for i = 1:length(G_list)
    G =  G_list(i);
    % first make sure that we have crossing
    Fs = [];
    sigmas = [];
    As = [];
    % looking roughlt where we expect the cross to be
    GCS = ClosestG(G, WNLData);
    GC = GStoG(GCS);
    Astar = WNLData.(GCS).calcs.Astar;
    % putting Astar in normal units
    Ktwo = (2*pi/GC)^2 + pi^2;
    a = (1/pi)*(4*GC^3/(Ktwo^2*(4+GC^2)^2))^(1/3);
    Astar = Astar*a;
    jump = round(Astar/2,1,'significant');
    A = 0;
    done = 0;
    while not(done)
        As = [As A];
        [sig, F] = GetFandSig(A,n,m,N,G,positionMatrix);
        Fs = [Fs F];
        sigmas = [sigmas sig];
        if sig > 0
            done = 1;
        else
            A = A + jump
        end
    end
    % now we zoom in
    done = 0;
    while not(done)
        A = NextAHalv(As,sigmas)
        A = round(A,prec,'significant')
        if not(ismember(A,As))
            As = [As A];
            [sig, F] = GetFandSig(A,n,m,N,G,positionMatrix);
            Fs = [Fs F];
            sigmas = [sigmas sig];
            [As,I] = sort(As);
            Fs = Fs(I);
            sigmas = sigmas(I);
        else
            done = 1;
        end       
    end 
    % now save it all
    Ktwo = (2*pi/G)^2 + pi^2;
    a = (1/pi)*(4*G^3/(Ktwo^2*(4+G^2)^2))^(1/3);
    As = As/a;
    GS = GtoGS(G);
    WNLData.(GS).As = As;
    WNLData.(GS).Fs = Fs;
    WNLData.(GS).sigmas = sigmas;
    [Astar, ~,~,pitch,hopf] = FindZero(As,sigmas, Fs);
    WNLData.(GS).calcs.Astar = Astar;
    WNLData.(GS).calcs.pitch = pitch;
    WNLData.(GS).calcs.hopf = hopf;
end

save(dpath, "WNLData")