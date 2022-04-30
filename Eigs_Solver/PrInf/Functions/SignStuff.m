function SS = SignStuff(npert,mpert,nsteady,msteady,minst)
SS = npert*msteady*f(msteady,minst,mpert) - mpert*nsteady*f(mpert,minst,msteady);
end

