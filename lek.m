nx = 32;
ny = 32;
xr = floor(nx/3 + 1) + 1;
yr = floor(2*ny/3 + 1);
fid = fopen('/Users/philipwinchester/Desktop/spectrum2D_UU.0001.out','r');
fread(fid,1, 'real*4');
Spectra = fread(fid,inf, 'real*8');
fclose(fid);
% Reshape and plot
Spectra = 2*reshape(Spectra,xr,yr);