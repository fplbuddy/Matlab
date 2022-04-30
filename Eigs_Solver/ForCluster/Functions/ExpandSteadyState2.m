function [PsiE, ThetaE] = ExpandSteadyState2(PsiEOld,ThetaEOld,Nold, Nnew)
[~,~,nold,mold] = GetRemKeep(Nold,1);
[~,~,nnew,mnew] = GetRemKeep(Nnew,1);

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
PsiAdd = 0; %min(PsiEOld);
ThetaAdd = 0; %min(ThetaEOld);
for j=1:length(nnew)
    check = PsiE(j);
    if check == 0
        PsiE(j) = PsiAdd;
        ThetaE(j) = ThetaAdd;
    end
end
end

