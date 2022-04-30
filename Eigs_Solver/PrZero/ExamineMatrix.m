fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
fpath2 = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrZero/Functions/';
addpath(fpath)
addpath(fpath2)
% Loading in the old data
dpath = '/Volumes/Samsung_T5/OldData/PrZeroData.mat';
load(dpath);
% constants
RaC = 8*pi^4;
N = 32;
G = 2;
Pr_list = [1e-3];
RaA_list = 6.33e-2;
res = ['N_' num2str(N)];
for i=1:length(Pr_list)
    Pr = Pr_list(i);
    PrS = PrtoPrSZero(Pr);
    for j = 1:length(RaA_list)
        RaA = RaA_list(j);
        Ra = RaA + RaC;
        RaAS = RaAtoRaAS(RaA);      
        ThetaE = PrZeroData.(res).(PrS).(RaAS).ThetaE;
        PsiE = PrZeroData.(res).(PrS).(RaAS).PsiE;
        % Only keeping modes we want
        ThetaE([2:N/4, N/4+2:end]) = 0;
        PsiE(2:end) = 0;
        % Solving odd problem
        M = MakeMatrixForOddProblem(N,G, PsiE, ThetaE, Ra, Pr);
        rem = [1:N:N^2/2 N^2/2+1:N^2]; % get rid of the extra minus
        rem = [N^2/2+1:N^2];
        M(:,rem) = [];
        M(rem,:) = [];
    end
end
%% Peters stuff
%x = Pr/sqrt(dra). Want something in the form M = A - xI
% making sure diagonal is right
% x = Pr/RaA^2;
% for i=1:length(M)
%    fact = -x/M(i,i);
%    M(:,i) = M(:,i)*fact; % putting it into form we want
%    M(i,i) = 0;
% end


%M = M/RaA^2;

stop



%%
n = [(-N/2):2:(N/2-1) (-N/2+1):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:); 
m = 1:N; m = repelem(m, N/2);
nkeep = [0 -1 1];
mkeep = [1 2 2];
rem = [];
for i=1:length(n)
    ninst = n(i);
    minst = m(i);
    got = 0;
    for j=1:length(nkeep)
        ncomp = nkeep(j); mcomp = mkeep(j); 
        if ncomp == ninst && mcomp == minst
            got = 1;
        end
    end
    if not(got)
       rem = [rem i];
    end
end
M(:,rem) = [];
M(rem,:) = [];

%% Check with wolfram with 5 modes
A = abs(M(1,1));
B = abs(M(2,2));
C = abs(M(4,1));
D = abs(M(4,2));
E = abs(M(2,4));
% factors
fact1 = -A^4*B;
fact2 = 2*A^3*D*E;
fact3 = -2*A^2*B*C^2;
fact4 = 2*A*C^2*D*E;
fact5 = -B*C^4;
c = fact1 + fact2 + fact3 + fact4 + fact5

r = det(M)
stop

% fix scaling
for i=1:length(M)
    for j=1:length(M)
       if i == j
           M(i,j) = M(i,j)/Pr;
       else
           M(i,j) = (M(i,j)/sqrt(RaA))*sqrt(RaC)/2;
       end
       
    end
end

%%
N = 32;
mi = 7;
ni = 0;
check = N/2*(mi-1)-floor(mi/2)+1+(N/4-1/2-rem(mi,2)/2)+ni/2;
check2 = N/4*(2*mi-1)+1/2*(1+ni-mi);
check == check2

