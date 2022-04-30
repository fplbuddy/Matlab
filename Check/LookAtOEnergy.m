path = '/Volumes/Samsung_T5/EigComp/LargeAmp';
d = dir(path);
RaS_list = string({d.name}); RaS_list(1:2) = [];
addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/Functions/'); % Adding functions
Ra_list = []; Amp_list = [];

for i=1:length(RaS_list)
   RaS = convertStringsToChars(RaS_list(i));
   kenergy = importdata([path '/' RaS '/Checks/kenergy.txt']);
   s = kenergy(:,8);
   t = kenergy(:,1);
   xlower = round(0.9*length(t));
   m = MyMeanEasy(s(xlower:end), t(xlower:end)); Ra = RaStoRa(RaS);
   Ra_list = [Ra Ra_list]; Amp_list = [m Amp_list]; 
end