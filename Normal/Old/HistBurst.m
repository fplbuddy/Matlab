%% Nu we are looking at
clear
%path = "/scratch/winchester/512_128_RB_Convection_VCode2/";
%path = "/scratch/winchester/512_256_RBC_NoBug/";
%path = "/scratch/winchester/1024_256_RBC_NoBug/";
path = "/scratch/winchester/512x256_RBC_AR2_NN/";
%path = "/scratch/winchester/512x256_RBC_AR2/";
%path = "/scratch/winchester/Check/";
AllFolders = dir(path);
AllFolders = extractfield(AllFolders,'name');
j = 0;
for i = 1:length(AllFolders)
    if strncmp("nu",AllFolders(i),2)   
        j = j + 1;
        nu_list(j) = AllFolders(i); % Making nu_list
    end
end
nu_list = string(nu_list);
nu_names = nu_list;
nu_values = zeros(length(nu_list),1);
Ra_values = zeros(length(nu_list),1);

for i=1:length(nu_list)
    nu_values(i) = str2num(erase(nu_list(i),"nu_"));
    Ra_values(i) = pi^3/nu_values(i)^2;
    Ra_name = num2str(Ra_values(i),'%.1e');
    Ra_name = convertCharsToStrings(Ra_name);
    nu_names(i) = join(["\nu = " erase(nu_list(i),"nu_") ", Ra = " Ra_name],"");
end

% Sorting things
[B,I] = sort(nu_values);
nu_values = nu_values(I);
nu_list = nu_list(I);
nu_names = nu_names(I);
Ra_values = Ra_values(I);

% Extracting data 
for i=1:length(nu_list)
    Table = strcat('nu',num2str(i))
    kenergy.(Table) = importdata(join([path nu_list(i) "/Checks/kenergy.txt"],""));
end
%% Prints
MHist("nu_1e-3", nu_list, kenergy, nu_names)

%% Functions

function MHist(nu,nu_list, kenergy, nu_names)
    WN = find(nu_list == nu);
    tit = nu_names(WN);
    Table = kenergy.(strcat('nu',num2str(WN)));
    t = Table(:,1);
    Ek = Table(:,2);
    epsk = Table(:,3);
    plot(t,Ek)
    Start = input('Where do we start? t= ');
    close all
    Start = find(t > Start);
    Start = Start(1);
    Ek = Ek(Start:end);
    t = t(Start:end);
    epsk = epsk(Start:end);
    figure
    plot(t, Ek)
    xlabel('t')
    ylabel('E_k')
    title(tit)
    figure
    [yi,xi] = hist(Ek,1000);
    semilogy(xi,yi/length(t))
    xlabel('E_k')
    title(tit)
    figure
    plot(t, epsk)
    title(tit)
    xlabel('t')
    ylabel('\epsilon_k')
    figure
    [yi,xi] = hist(epsk,1000);
    semilogy(xi,yi/length(t))
    title(tit)
    xlabel('\epsilon_k')
end

