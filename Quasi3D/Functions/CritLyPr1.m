function LyC = CritLyPr1(Ra,alpha,Gy)
nu = sqrt(pi^3/Ra);
Ly = Gy*pi; % Gettinf Ly from aspect ratio
C = (nu*(2*pi)^2)*2; % is is from the squared
LyC = sqrt(1/(alpha/C + 1/Ly^2));
end

