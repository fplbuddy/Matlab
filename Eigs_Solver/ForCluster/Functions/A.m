function A = A(nodd, modd, neven, meven,G, minst)
A = (pi^2*2/G)*(nodd*meven*f(meven, modd, minst)-modd*neven*f(modd, meven, minst));
end

