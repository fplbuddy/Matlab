path = '/Volumes/Samsung_T5/EigComp/LargeAmp';
d = dir(path);
RaS_list = string({d.name}); RaS_list(1:2) = [];
addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/Functions/'); % Adding functions

Ra_list = []; Amp_list = [];

for i=1:length(RaS_list)
   RaS = convertStringsToChars(RaS_list(i));
   kpsmodes = importdata([path '/' RaS '/Checks/kpsmodes1.txt']);
   %real = kpsmodes(:,4); imag = kpsmodes(:,6);
   s = abs(kpsmodes(:,2));
   t =kpsmodes(:,1);
   xlower = round(0.9*length(t));
   %s = sqrt(real.^2+imag.^2);
   m = MyMeanEasy(s(xlower:end), t(xlower:end)); Ra = RaStoRa(RaS);
   Ra_list = [Ra Ra_list]; Amp_list = [m Amp_list]; 
end
