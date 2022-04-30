function [PsiE, ThetaE] = ExpandSteadyState(PsiEOld,ThetaEOld,Nold, Nnew)
nnew = [1:2:(Nnew/2-1) 0:2:(Nnew/2-1)]; nnew = repmat(nnew, Nnew/2);  nnew = nnew(1,:);
mnew = 1:Nnew; mnew = repelem(   mnew, Nnew/4);
nold = [1:2:(Nold/2-1) 0:2:(Nold/2-1)]; nold = repmat(nold, Nold/2);  nold = nold(1,:);
mold = 1:Nold; mold = repelem(   mold, Nold/4);

PsiE = zeros(length(nnew),1);
ThetaE = zeros(length(nnew),1);

for i=1:length(nold)
    noldinst = nold(i);
    moldinst = mold(i);    
    PsiAdd = PsiEOld(i); % Getting thing we want to add
    ThetaAdd = ThetaEOld(i);
    for j=1:length(nnew)
        nnewinst = nnew(j);
        mnewinst = mnew(j);
        if nnewinst == noldinst && mnewinst == moldinst
            break
        end
    end
    PsiE(j) = PsiAdd;
    ThetaE(j) = ThetaAdd;
end

% filling the remaining zeros
PsiAdd = min(PsiEOld);
ThetaAdd = min(ThetaEOld);
for j=1:length(nnew)
    check = PsiE(j);
    if check == 0
        PsiE(j) = PsiAdd;
        ThetaE(j) = ThetaAdd;
    end
end
end

