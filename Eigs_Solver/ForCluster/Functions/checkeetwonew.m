function res = checkeetwonew(ninst, minst, N)
% addapted to only look at when kye + kyo = kx
nsteady = [-(N/2-1):2:(N/2-1) -(N/2):2:(N/2-2)]; nsteady = repmat(nsteady, N/2); nsteady = nsteady(1,:); % We want the negative ones here also, they might not appear actually... they will!
msteady = 1:N; msteady = repelem(msteady, N/2);
res = [zeros(N^2/2,2) reshape(nsteady, N^2/2,1) reshape(msteady, N^2/2,1)];
rem = [];
for i=1:length(nsteady)
    nsteadyinst = res(i,3);
    msteadyinst = res(i,4);
    npertinst = ninst - nsteadyinst;
    mpertinst = - minst + msteadyinst;
    if -N/2 <= npertinst && npertinst < N/2 && mpertinst <= N && mpertinst >= 1 && not(npertinst ==  nsteadyinst && mpertinst == msteadyinst)
        res(i,1) = npertinst;
        res(i,2) = mpertinst;
    else
        rem = [i rem];
    end
end
res(rem,:) = [];
end
