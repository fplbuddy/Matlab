function A = Aeven(npert, mpert, nsteady, msteady,G, minst)
    A = (pi^2*2/G)*(npert*msteady*feven(msteady, mpert, minst)-mpert*nsteady*feven(mpert, msteady, minst));
end

