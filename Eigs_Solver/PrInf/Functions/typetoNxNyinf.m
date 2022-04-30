function [Nx,Ny] = typetoNxNyinf(type)
    type = convertStringsToChars(type);
    xloc = strfind(type, 'x');
    Nx = str2num(type(3:xloc-1));
    Ny = str2num(type(xloc+1:end));
end

