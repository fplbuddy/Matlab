N = 32;
G = 2;
n = [(-N/2+1):2:(N/2-1) (-N/2):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:); 
m = 1:N; m = repelem(   m, N/2);


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
tic
for i=1:length(n)
    ninst = n(i); minst = m(i);
    OnesWeWant1 = checkeeonenew(ninst, minst, N);
    OnesWeWant2 = checkeetwonew(ninst, minst, N);
    OnesWeWant3 = checkeethreenew(ninst, minst, N);
    
    
    for j=1:height(OnesWeWant1)
        modes = OnesWeWant1(j,:);
        npert = modes(1); mpert = modes(2); nsteady = modes(3); msteady = modes(4);
        %if abs(neven) < N/2 % as we do not have this in the steady state.
        %will just add a 0 in the PsiE and ThetaE after we expand
        columninst = columnfindnew(N, npert, mpert);
        steadypos = steadypositionnew(N, nsteady, msteady);

        AFact = Aeven(npert, mpert, nsteady, msteady,G, minst);
         
         % Adding to stencils
         Stencil1psi1(i,columninst) = (Square(npert,mpert,G) - Square(nsteady,msteady,G))*AFact;
         Stencil1psi2andtheta1(i,columninst) = AFact;
         % Adding to Factors
         FactorWeWant1(i, steadypos) = 1;
         FactorReshuffle1(i, columninst) = (steadypos-1)*(N^2/2)+i;
    end
    for j=1:height(OnesWeWant2)
        modes = OnesWeWant2(j,:);
        npert = modes(1); mpert = modes(2); nsteady = modes(3); msteady = modes(4);
        %if abs(neven) < N/2 % as we do not have this in the steady state
        columninst = columnfindnew(N, npert, mpert);
        steadypos = steadypositionnew(N, nsteady, msteady);

        AFact = A(npert, mpert, nsteady, msteady,G, minst);
         
         % Adding to psi1
         Stencil2psi1(i,columninst) = (Square(npert,mpert,G) - Square(nsteady,msteady,G))*AFact;
         % Adding psi2
         Stencil2psi2andtheta1(i,columninst) = AFact;
         % Adding to Factors
         FactorWeWant2(i, steadypos) = 1;
         FactorReshuffle2(i, columninst) = (steadypos-1)*(N^2/2)+i;

    end
    for j=1:height(OnesWeWant3)
        modes = OnesWeWant3(j,:);
        npert = modes(1); mpert = modes(2); nsteady = modes(3); msteady = modes(4);
        %if abs(neven) < N/2 % as we do not have this in the steady state
        columninst = columnfindnew(N, npert, mpert);
        steadypos = steadypositionnew(N, nsteady, msteady);

        AFact = A(npert, mpert, nsteady, msteady,G, minst);
         
         % Stencil
         Stencil3psi1(i,columninst) = (Square(npert,mpert,G) - Square(nsteady,msteady,G))*AFact;
         Stencil3psi2andtheta1(i,columninst) = AFact;
         % Adding to Factors
         FactorWeWant3(i, steadypos) = FactorWeWant3(i, steadypos) + 1;
         FactorReshuffle3(i, columninst) = (steadypos-1)*(N^2/2)+i;

    end
    
end
% saving
stencilsEven.Stencil1psi1 = Stencil1psi1;
stencilsEven.Stencil2psi1 = Stencil2psi1;
stencilsEven.Stencil3psi1 = Stencil3psi1;
stencilsEven.Stencil1psi2andtheta1 = Stencil1psi2andtheta1;
stencilsEven.Stencil2psi2andtheta1 = Stencil2psi2andtheta1;
stencilsEven.Stencil3psi2andtheta1 = Stencil3psi2andtheta1;
stencilsEven.FactorWeWant1 = FactorWeWant1;
stencilsEven.FactorWeWant2 = FactorWeWant2;
stencilsEven.FactorWeWant3 = FactorWeWant3;
stencilsEven.FactorReshuffle1 = FactorReshuffle1;
stencilsEven.FactorReshuffle2 = FactorReshuffle2;
stencilsEven.FactorReshuffle3 = FactorReshuffle3;
save(['/Volumes/Samsung_T5/SomeStencils/' 'eigEvenN_' num2str(N)], 'stencilsEven', '-v7.3')





