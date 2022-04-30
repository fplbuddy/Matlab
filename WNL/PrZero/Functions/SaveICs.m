function Out =  SaveICs(Amp,B,eps,G,N)
% Here A and B are in the form before we have put in standard form
M = MakeMatrixEigProb_2(N,N,G, Amp,1);
[V, sigma] = eig(M);
sigma = diag(sigma);
[~,I] = max(real(sigma));
V = V(:,I);
% These are the n and m for V
n = [(-N/2):2:(N/2-1) (-N/2+1):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:);
m = 1:N; m = repelem(m, N/2);
[~,~,n,m] = GetRemGeneral_nxny(n,m,N,N);
%
% Make out
Out = zeros(N^2,1);
%
% Add 1,1 to it, in the imaginary column
Out(4) = -Amp;
%
% Now add the remaining tings in the real column
for i=1:length(n)
   if n(i) >= 0
    I = (N/2)*(m(i)-1)+n(i)+1;
    Out(2*I-1) = V(i)*B*eps;
   end
end
%
type = ['N_' num2str(N) 'x' num2str(N)];
GS = GtoGS(G); 
RaA = eps^2; RaAS = RaAtoRaAS(RaA);
AmpS = AmptoAmpS(Amp);
folder = ['/Volumes/Samsung_T5/ZeroICs/' type '/' convertStringsToChars(GS) '/'  convertStringsToChars(RaAS) '/' convertStringsToChars(AmpS) ];
% The solution we want is = -i*A*phi_{1,1}+eps*V*B, V is the vector of
% odd modes. All these modes should be real valued
if ~exist(folder, 'dir')
    mkdir(folder)
end
writematrix(Out,[folder '/PsiE.txt'],'Delimiter','tab')
end

