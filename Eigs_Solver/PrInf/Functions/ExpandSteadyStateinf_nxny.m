function ThetaE = ExpandSteadyStateinf_nxny(ThetaEOld,Nxold,Nyold,Nxnew,Nynew)
[~,~,nold,mold] = GetRemKeep_nxny(Nxold,Nyold,1);
[~,~,nnew,mnew] = GetRemKeep_nxny(Nxnew,Nynew,1);
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
end

