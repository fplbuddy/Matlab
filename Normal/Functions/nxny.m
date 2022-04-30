function [nx, ny] = nxny(Res)
    Res = convertStringsToChars(Res);
    nx = '';
    ny = '';
    for i=1:find('x' == Res)-1
       nx = [nx Res(i)];
    end
    for i=find('x' == Res)+1:length(Res)
       ny = [ny Res(i)];
    end
    nx = str2num(nx);
    ny = str2num(ny);
end