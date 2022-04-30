function PsiEexp = Getexp_zero(PsiE, N)
% Copying over
PsiEexp = repmat(PsiE, 2,1); 
% Taking complex conj
PsiEexp(N^2/4+1:end) = conj(PsiEexp(N^2/4+1:end));
% removing n = -N/2
PsiEexp(N^2/4+(N/4)+1:N/2:end) = 0;
% Shoufling arround.
% Could maybe save the expstruct for each N. It is pretty fast tho even for
% large N
expstruct = [];
for i=1:N^2/(N)
    if mod(i,2) 
        expstruct = [expstruct N^2/4+i*(N/4):-1:N^2/4+(i-1)*(N/4)+1 (i-1)*(N/4)+1:i*(N/4)];
    else
        expstruct = [expstruct N^2/4+(i-1)*(N/4)+1 N^2/4+i*(N/4):-1:N^2/4+(i-1)*(N/4)+2 (i-1)*(N/4)+1:i*(N/4)];
    end
end
PsiEexp = PsiEexp(expstruct);
PsiEexp = reshape(PsiEexp, 1, length(PsiEexp));
clearvars -except PsiEexp

end

