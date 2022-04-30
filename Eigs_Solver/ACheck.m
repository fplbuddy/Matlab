% switch order of hej2
s = size(hej2); s = s(1);
for i=1:s
   hej3(i,3) = hej2(i,1);
   hej3(i,1) = hej2(i,3);
   hej3(i,4) = hej2(i,2);
   hej3(i,2) = hej2(i,4);
end

% Check differences
s2 = size(hej); s2 = s2(1);
res = [];
for i=1:s2
    hejnodd = hej(i,1); hejmodd = hej(i,2); hejneven = hej(i,3); hejmeven = hej(i,4);
    add = 1;
    % Check if exist in hej3
    for j=1:s
        if hejnodd == hej3(j,1) && hejmodd == hej3(j,2) && hejneven == hej3(j,3) && hejmeven == hej3(j,4)
            add = 0;
        end 
    end
    if add
        s3 = size(res);
        res(s3(1)+1, 1) = hejnodd; res(s3(1)+1, 2) = hejmodd; res(s3(1)+1, 3) = hejneven; res(s3(1)+1, 4) = hejmeven; 
    end  
end