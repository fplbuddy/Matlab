run SetUp.m
AR = 3.1;
ARS = ['AR_' strrep(num2str(AR),'.','_')];
Ra_list = [];
sigma_list = [];
type_list = string(fields(PrInfData.(ARS)));
for i=1:length(type_list)
    type = type_list(i);
    RaS_list = string(fields(PrInfData.(ARS).(type)));
    for k=1:length(RaS_list)
       try
       RaS =  RaS_list(k);
       Ra = RaStoRa(RaS);
       sigma = PrInfData.(ARS).(type).(RaS).sigmaodd;
       Ra_list = [Ra_list Ra];
       sigma_list = [sigma_list max(real(sigma))];
       catch
       end
    end
end
[Ra_list,I] = sort(Ra_list);
sigma_list = sigma_list(I);
figure()
semilogx(Ra_list,sigma_list,'-o')
title(['$\Gamma = $' num2str(AR)],'FontSize',LabelFS)