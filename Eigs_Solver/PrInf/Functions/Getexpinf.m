function ThetaEexp = Getexpinf(ThetaE, N)
% Copying over
ThetaEexp = repmat(ThetaE, 2,1);
% Taking complex conj
ThetaEexp(N^2/4+1:end) = conj(ThetaEexp(N^2/4+1:end));
% removing n = -N/2
ThetaEexp(N^2/4+(N/4)+1:N/2:end) = 0;
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
ThetaEexp = ThetaEexp(expstruct);
ThetaEexp = reshape(ThetaEexp, 1, length(ThetaEexp));
clearvars -except PsiEexp ThetaEexp
end

