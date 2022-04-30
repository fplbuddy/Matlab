function PsiEf = FormatFields_zero(PsiE, N)
ninst = [1:2:(N/2-1) 0:2:(N/2-2)]; ninst = repmat(ninst, N/2); ninst = ninst(1,:);
% Making sure inputs are in form we want it, ie psi imag and theta real
arg = angle(PsiE(1)) + pi/2;
mult = exp(-1i*ninst*arg);
mult = reshape(mult,length(mult),1);
PsiE = PsiE .* mult;
% putting them in form we want, it that they are both real. will transfor
% back at the end
PsiEf = imag(PsiE);
clearvars -except PsiEf
end

