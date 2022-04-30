tic
N = 88;
G = 2;
n = [(-N/2):2:(N/2-1) (-N/2+1):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:); 
m = 1:N; m = repelem(m, N/2);


%%
Stencil1psi1 = zeros((N^2/2),(N^2/2));
Stencil1psi2andtheta1 = zeros((N^2/2),(N^2/2)); % Remember it is negative for theta
Stencil2psi1 = zeros((N^2/2),(N^2/2));
Stencil2psi2andtheta1 = zeros((N^2/2),(N^2/2)); % Remember it is negative for theta
Stencil3psi1 = zeros((N^2/2),(N^2/2));
Stencil3psi2andtheta1 = zeros((N^2/2),(N^2/2)); % Remember it is negative for theta
FactorWeWant1 = zeros((N^2/2),(N^2/2));
FactorReshuffle1 = ones((N^2/2),(N^2/2))*(N/2)*(N^2/2)+1; % This mode is always zero, m = -N/2
FactorWeWant2 = zeros((N^2/2),(N^2/2));
FactorReshuffle2 = FactorReshuffle1;
FactorWeWant3 = zeros((N^2/2),(N^2/2));
FactorReshuffle3 = FactorReshuffle1;
for i=1:length(n)
    ninst = n(i); minst = m(i);
    OnesWeWant1 = checkoeonenew(ninst, minst, N);
    OnesWeWant2 = checkoetwonew(ninst, minst, N);
    OnesWeWant3 = checkoethreenew(ninst, minst, N);
    
    
    for j=1:height(OnesWeWant1)
        modes = OnesWeWant1(j,:);
        nodd = modes(1); modd = modes(2); neven = modes(3); meven = modes(4);
        %if abs(neven) < N/2 % as we do not have this in the steady state.
        %will just add a 0 in the PsiE and ThetaE after we expand
        columninst = columnfindnew(N, nodd, modd);
        steadypos = steadypositionnew(N, neven, meven);

        AFact = A(nodd, modd, neven, meven,G, minst);
         
         % Adding to stencils
         Stencil1psi1(i,columninst) = (Square(nodd,modd,G) - Square(neven,meven,G))*AFact;
         Stencil1psi2andtheta1(i,columninst) = AFact;
         % Adding to Factors
         FactorWeWant1(i, steadypos) = 1;
         FactorReshuffle1(i, columninst) = (steadypos-1)*(N^2/2)+i;
    end
    for j=1:height(OnesWeWant2)
        modes = OnesWeWant2(j,:);
        nodd = modes(1); modd = modes(2); neven = modes(3); meven = modes(4);
        %if abs(neven) < N/2 % as we do not have this in the steady state
        columninst = columnfindnew(N, nodd, modd);
        steadypos = steadypositionnew(N, neven, meven);

        AFact = A(nodd, modd, neven, meven,G, minst);
         
         % Adding to psi1
         Stencil2psi1(i,columninst) = (Square(nodd,modd,G) - Square(neven,meven,G))*AFact;
         % Adding psi2
         Stencil2psi2andtheta1(i,columninst) = AFact;
         % Adding to Factors
         FactorWeWant2(i, steadypos) = 1;
         FactorReshuffle2(i, columninst) = (steadypos-1)*(N^2/2)+i;

    end
    for j=1:height(OnesWeWant3)
        modes = OnesWeWant3(j,:);
        nodd = modes(1); modd = modes(2); neven = modes(3); meven = modes(4);
        %if abs(neven) < N/2 % as we do not have this in the steady state
        columninst = columnfindnew(N, nodd, modd);
        steadypos = steadypositionnew(N, neven, meven);

        AFact = A(nodd, modd, neven, meven,G, minst);
         
         % Stencil
         Stencil3psi1(i,columninst) = (Square(nodd,modd,G) - Square(neven,meven,G))*AFact;
         Stencil3psi2andtheta1(i,columninst) = AFact;
         % Adding to Factors
         FactorWeWant3(i, steadypos) = FactorWeWant3(i, steadypos) + 1;
         FactorReshuffle3(i, columninst) = (steadypos-1)*(N^2/2)+i;

    end
    
end
% saving
stencilsOdd.Stencil1psi1 = Stencil1psi1;
stencilsOdd.Stencil2psi1 = Stencil2psi1;
stencilsOdd.Stencil3psi1 = Stencil3psi1;
stencilsOdd.Stencil1psi2andtheta1 = Stencil1psi2andtheta1;
stencilsOdd.Stencil2psi2andtheta1 = Stencil2psi2andtheta1;
stencilsOdd.Stencil3psi2andtheta1 = Stencil3psi2andtheta1;
stencilsOdd.FactorWeWant1 = FactorWeWant1;
stencilsOdd.FactorWeWant2 = FactorWeWant2;
stencilsOdd.FactorWeWant3 = FactorWeWant3;
stencilsOdd.FactorReshuffle1 = FactorReshuffle1;
stencilsOdd.FactorReshuffle2 = FactorReshuffle2;
stencilsOdd.FactorReshuffle3 = FactorReshuffle3;
toc
save(['/Volumes/Samsung_T5/SomeStencils/' 'eigOddN_' num2str(N)], 'stencilsOdd',  '-v7.3')
%%

% function pos = columnfindnew(N,ninst,minst)
% pos = (minst-1)*(N/2) + floor((N/2+ninst)/2)+1;
% end
% 
% function A = A(nodd, modd, neven, meven,G, minst)
% A = (pi^2*2/G)*(nodd*meven*f(meven, modd, minst)-modd*neven*f(modd, meven, minst));
% end
% 
% function S = Square(ninst,minst,G)
% S = (ninst^2)*(2*pi/G)^2 + (minst*pi)^2;
% end
% 
% function f = f(a,b,c)
% if a == b + c
%     f = -1;
% else
%     f = 1;
% end
% end
% 
% function pos = steadypositionnew(N, ninst, minst)
%     pos = (minst-1)*(N/2) + floor((N/2+ninst)/2)+1;
% end




