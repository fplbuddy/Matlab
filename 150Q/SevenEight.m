n = 100;
d_list = [];
left_list = [100];


for i=1:17
   d(i) = sqrt(left_list(i)); % caluclated the maximum d height
   left_list(i+1) = left_list(i) - d(i);
end