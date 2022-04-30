function ThetaE = ExpandSteadyState2inf(ThetaEOld,Nold, Nnew)
[~,~,nold,mold] = GetRemKeep(Nold,1);
[~,~,nnew,mnew] = GetRemKeep(Nnew,1);

ThetaE = zeros(length(nnew),1);

for i=1:length(nold)
    noldinst = nold(i);
    moldinst = mold(i);     
    ThetaAdd = ThetaEOld(i); % Getting thing we want to add
    for j=1:length(nnew)
        nnewinst = nnew(j);
        mnewinst = mnew(j);
        if nnewinst == noldinst && mnewinst == moldinst
            break
        end
    end
    ThetaE(j) = ThetaAdd;
end

% filling the remaining zeros
ThetaAdd = 0; %min(ThetaEOld);
for j=1:length(nnew)
    check = ThetaE(j);
    if check == 0
        ThetaE(j) = ThetaAdd;
    end
end
end

