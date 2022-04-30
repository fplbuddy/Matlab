mmax =80;
list = [1 2];
for m=3:mmax
    add = 0;
    for n=0:floor(m/2)
        add = add + nchoosek(m-n,n);
    end
    list = [list add];  
end
% does seeem to work, but not same as given solution