function [Nx,Ny] = typetoNxNy(type)
    typeN = convertStringsToChars(type); 
    idx = strfind(typeN,'x');
    Nx = typeN(3:idx-1); 
    Nx = str2num(Nx);
    Ny = typeN(idx+1:end); Ny = str2num(Ny);
end

