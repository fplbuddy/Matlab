Nnew = 88;
Nold = 172;
Ra = 4e5;
RaS = RatoRaS(Ra);
Pr = 12;
PrS = PrtoPrS(Pr);
typenew = 'OneOne88';
typeold = 'OneOne172';
nnew = [1:2:(Nnew/2-1) 0:2:(Nnew/2-2)]; nnew = repmat(nnew, Nnew/2); nnew = nnew(1,:);
mnew = 1:Nnew; mnew = repelem(mnew, Nnew/4);
nold = [1:2:(Nold/2-1) 0:2:(Nold/2-2)]; nold = repmat(nold, Nold/2); nold = nold(1,:);
mold = 1:Nold; mold = repelem(mold, Nold/4);
PsiEOld = Data.AR_2.(typeold).(PrS).(RaS).PsiE;
ThetaEOld = Data.AR_2.(typeold).(PrS).(RaS).ThetaE;
PsiENew = zeros(length(nnew),1);
ThetaENew = zeros(length(nnew),1);
for i=1:length(nold)
   noldinst = nold(i); moldinst = mold(i);
   for j =1:length(nnew)
      nnewinst = nnew(j); mnewinst = mnew(j);
      if noldinst == nnewinst && mnewinst == moldinst
          PsiENew(j) = PsiEOld(i);
          ThetaENew(j) = ThetaEOld(i);
      end
   end
end
Data.AR_2.(typenew).(PrS).(RaS).PsiE = PsiENew;
Data.AR_2.(typenew).(PrS).(RaS).ThetaE = ThetaENew;


