function EigenFunc = ExpandEigenFunc2(EigenFuncOld,Nold, Nnew)
% Takes some eigen function EigenFuncOld which was made using N = Nold and
% approximates a new on with N = Nnew. eo is if the eigen function is even
% or odd
     nnew = [(-Nnew/2):2:(Nnew/2-1) (-Nnew/2+1):2:(Nnew/2-1)]; nnew = repmat(nnew, Nnew/2);  nnew = nnew(1,:); 
     mnew = 1:Nnew; mnew = repelem(   mnew, Nnew/2);
     nold = [(-Nold/2):2:(Nold/2-1) (-Nold/2+1):2:(Nold/2-1)]; nold = repmat(nold, Nold/2);  nold = nold(1,:); 
     mold = 1:Nold; mold = repelem(   mold, Nold/2);
    [~,~,nold,mold] = GetRemGeneral(nold,mold,Nold);
    [~,~,nnew,mnew] = GetRemGeneral(nnew,mnew,Nnew);
    

    EigenFunc = zeros(length(nnew)*2,1);
    for i=1:length(nold)
        noldinst = nold(i);
        moldinst = mold(i);    
        PsiAdd = EigenFuncOld(i); % Getting thing we want to add
        ThetaAdd = EigenFuncOld(i+length(nold));
        for j=1:length(nnew)
            nnewinst = nnew(j);
            mnewinst = mnew(j);
            if nnewinst == noldinst && mnewinst == moldinst
                break
            end
        end
        EigenFunc(j) = PsiAdd;
        EigenFunc(j+length(nnew)) = ThetaAdd;
    end
end

