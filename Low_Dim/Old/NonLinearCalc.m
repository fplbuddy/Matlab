v1 = [1 2; -1 2; 0 1];
v2 = [1 1; -1 1; 0 2];

res = NLC(v1, v2)
clb(res, 1, 2)
%cl(res)


%% Functions
function res = NLC(v1, v2)
    n = length(v1);
    m = length(v2);
    res = zeros(2*n*m,6);
    for i=1:n
       x1 = v1(i,1); y1 = v1(i,2); % Get from v1
       for j=1:m
          x2 = v2(j,1); y2 = v2(j,2); % Get from v2
          respos = (m*(i-1)*2+2*(j-1)+1);
          % adding to res 
          res(respos,1) = x1+x2; res(respos,2) = y1+y2;
          res(respos,3) = x1; res(respos,4) = y1;
          res(respos,5) = x2; res(respos,6) = y2;
          res(respos+1,1) = x1+x2; res(respos+1,2) = abs(y1-y2);
          res(respos+1,3) = x1; res(respos+1,4) = y1;
          res(respos+1,5) = x2; res(respos+1,6) = y2;
          
       end
        
        
    end
end

function res = cl(res)
    n = length(res);
    rem = [];
    for i=1:n
        check = res(i,2);
        if check == 0 % Removing zeros
            rem = [rem i];
        end
    end
    res(rem,:) = [];
    
    rem = []; 
    n = length(res);
    for i=1:n
        xc =res(i,1); yc = res(i,2);
        for j=i+1:n
            xc2 =res(j,1); yc2 = res(j,2);
            if xc == xc2 && yc == yc2 % Removing doubles
                rem = [rem j];
            end
        end
    end
    res(rem,:) = [];
end

function res = clb(res, x, y)
% Clear all but some mode
    rem = []; 
    n = length(res);
    for i=1:n
        xc =res(i,1); yc = res(i,2);
        if abs(x) ~= abs(xc) || y ~= yc
            rem = [rem i];
        end
    end
    res(rem,:) = [];
end

