% Setting up all the Res we have
Ra64x64 = [];
Ra128x128 = [];
Ra256x128 = [];
Ra256x256 = [];
Ra512x256 = [];
Ra512x512 = [];
Ra512x1024 = [];
Ra1024x512 = [];
Ra1024x1024 = [];
Pr64x64 = [];
Pr128x128 = [];
Pr256x128 = [];
Pr256x256 = [];
Pr512x256 = [];
Pr512x512 = [];
Pr512x1024 = [];
Pr1024x1024 = [];
Pr1024x512 = [];

AR_list = "AR_2"; %string(fieldnames(AllData));
for i=1:length(AR_list)
    ARS = AR_list(i);
    Pr_list = string(fieldnames(AllData.(ARS)));
    for i=1:length(Pr_list)
        PrS = Pr_list(i);
        Ra_list = string(fieldnames(AllData.(ARS).(PrS)));
        for i=1:length(Ra_list)
            RaS = Ra_list(i);
            Pr = AllData.(ARS).(PrS).(RaS).Pr;
            Ra = AllData.(ARS).(PrS).(RaS).Ra;
            if AllData.(ARS).(PrS).(RaS).Res == "128x128"
                Ra128x128 = [Ra Ra128x128];
                Pr128x128 = [Pr Pr128x128]; 
            elseif AllData.(ARS).(PrS).(RaS).Res == "64x64"
                Ra64x64 = [Ra Ra64x64];
                Pr64x64 = [Pr Pr64x64];    
            elseif AllData.(ARS).(PrS).(RaS).Res == "256x128"
                Ra256x128 = [Ra Ra256x128];
                Pr256x128 = [Pr Pr256x128];    
            elseif AllData.(ARS).(PrS).(RaS).Res == "256x256"
                Ra256x256 = [Ra Ra256x256];
                Pr256x256 = [Pr Pr256x256];                  
            elseif AllData.(ARS).(PrS).(RaS).Res == "512x256"
                Ra512x256 = [Ra Ra512x256];
                Pr512x256 = [Pr Pr512x256];                 
            elseif AllData.(ARS).(PrS).(RaS).Res == "512x512"
                Ra512x512 = [Ra Ra512x512];
                Pr512x512 = [Pr Pr512x512];
            elseif AllData.(ARS).(PrS).(RaS).Res == "512x1024"
                Ra512x1024 = [Ra Ra512x1024];
                Pr512x1024 = [Pr Pr512x1024];
            elseif AllData.(ARS).(PrS).(RaS).Res == "1024x1024"
                Ra1024x1024 = [Ra Ra1024x1024];
                Pr1024x1024 = [Pr Pr1024x1024];    
            elseif AllData.(ARS).(PrS).(RaS).Res == "1024x512"
                Ra1024x512 = [Ra Ra1024x512];
                Pr1024x512 = [Pr Pr1024x512]; 
            end          
        end
    end
end
%% Making Plot
FS = 18;
set(groot,'DefaultLineMarkerSize',10)
figure()
%loglog(Ra64x64,Pr64x64, '*', 'DisplayName', '64x64'), hold on
loglog(Ra128x128,Pr128x128, '*', 'DisplayName', '128x128'), hold on
loglog(Ra256x128,Pr256x128, '*', 'DisplayName', '256x128')
loglog(Ra256x256,Pr256x256, '*', 'DisplayName', '256x256')
loglog(Ra512x256,Pr512x256, '*', 'DisplayName', '512x256')
loglog(Ra512x512,Pr512x512, '*', 'DisplayName', '512x512')
loglog(Ra512x1024,Pr512x1024, '*', 'DisplayName', '512x1024')
loglog(Ra1024x512,Pr1024x512, '*', 'DisplayName', '1024x512')
loglog(Ra1024x1024,Pr1024x1024, '*', 'DisplayName', '1024x1024'), hold off
xlabel('$Ra$','FontSize',FS)
ylabel('$Pr$','FontSize',FS)
legend('Location', 'bestoutside','FontSize',FS-2)
    ax = gca;
    ax.XAxis.FontSize = FS-2;
    ax.YAxis.FontSize = FS-2;
%clearvars -except AllData
