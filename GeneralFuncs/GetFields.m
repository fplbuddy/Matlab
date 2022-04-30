function [Data,time] = GetFields(nx,ny,path,num,nmpi,fields,len)
% first get time
times = importdata([path 'field_times.txt']);
nums = times(:,1);
times = times(:,2);
I = find(nums == num);
time = times(I);
% now get data
num = num2str(num);
while length(num) < len
    num = ['0' num];
end
for field=fields
    field = convertStringsToChars(field);
    files = dir([path,'hd2D',field,'.*.',num,'.dat']);
    ff = zeros(nx*ny/nmpi,nmpi);
    for i=1:nmpi % Looping round mpi
        fid = fopen([path,files(i).name],'r');
        fread(fid,1,'real*4');
        ff(:,i) = fread(fid,inf,'real*8');
        fclose(fid);
    end
    ff = reshape(ff,nx,ny);
    ff = ff';
    Data.(field) = ff;
end
end

