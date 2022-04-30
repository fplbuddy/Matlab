ST_list = 0:0.1:100;

plot(ST_list,PutOption(40,10,ST_list)), hold on
plot(ST_list,PutOption(50,20,ST_list))
plot(ST_list,PutOption(70,30,ST_list))

a = 10;
c = 0;
b = -(a+c*4/3);
plot(ST_list, PutOption(40,10,ST_list)*a + PutOption(50,20,ST_list)*b + PutOption(70,30,ST_list)*c)


%% Functions
function V = PutOption(SP,Cost,ST_list)
    V = max((SP-ST_list),0) - Cost;
end