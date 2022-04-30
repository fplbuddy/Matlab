%% Get Data
addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/WaitingTimeGamma1/Functions')
run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
G = 1;
ARS = ['AR_' num2str(G)];
Pr = 30;
PrS = ['Pr_' num2str(Pr)];
Ra = 5e5; RaS = normaltoS(Ra,'Ra',1); RaT = RatoRaT(Ra);
kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
s = kpsmodes1(:,2);
t = kpsmodes1(:,1);
xlower = AllData.(ARS).(PrS).(RaS).ICT;
t = kpsmodes1(:,1); t = t(xlower:end);
s = kpsmodes1(:,2); s = s(xlower:end);
%%
thresh = mean(abs(s)); % point where we have a reversal
m = max(abs(s));
% range of psi values that we take into our model is form m to -thresh I
% guess

% now extract the sections that we have
Status = sign(s(1));
instswitch = [1];
for j=2:length(s)
    if Status == 1 % we are positive and going negative
        if s(j) < -thresh % we have switched!
            Status = -1;
            instswitch = [instswitch j];
        end
    else % we are negative and going posiive
        if s(j) > thresh % we have switched!
            Status = 1;
            instswitch = [instswitch j];
        end
    end
end
partitions = [instswitch length(t)]; % this is w

%% Now make our bins
bins = 20;
total = m + thresh;
binlengt = total/bins; % should probably make bin length proportial to the average step size in psi_{0,1} or something
binedges = [m m-(1:bins-1)*binlengt -thresh];

%% now make distributions
for i=1:bins
   field = ['dist_' num2str(i)];
   distsamples.(field).sample = []; 
   distsamples.(field).middle = (binedges(i)+binedges(i+1))/2;
end
% define a step as s_{i+1}-s_{i} where s_{i} is the reference point
% loops round samples of reversals and populate distributions
for i=1:length(partitions)-1
   sint = s(partitions(i):partitions(i+1));
   if sign(sint(1)) == -1 % flip the sample if needed
       sint = -sint;
   end
   for j=1:length(sint)-1
       ref = sint(j);
       I = BinEdgeLower(binedges,ref,1,bins+1); % i is the bin that we're in
       %sample = log(sint(j+1)/ref); % get sample 
       sample = sint(j+1)-ref;
       % add to distsamples
       field = ['dist_' num2str(I)];
       distsamples.(field).sample = [distsamples.(field).sample sample];       
   end
end
%% make gif of PDFs
bigRaxwid = 0.01;
part =2;

DelayTime = 0.5;
filename = [RaS '.gif'];
h = figure('Renderer', 'painters', 'Position', [10 10 800 400]);
axis tight manual % this ensures that getframe() returns a consistent size

for i=1:bins
    i

    %% Plot on figure 
    sgtitle(['$Ra  =' RaT '$'])
    subplot(1,2,1)
    field = ['dist_' num2str(i)];
    histogram(distsamples.(field).sample, 'Normalization', 'pdf');
    xlim([-bigRaxwid bigRaxwid])
    ylabel('PDF')
    xlabel('$\widehat\psi_{0,1}(t+dt)-\widehat\psi_{0,1}(t)$')
    
    
    subplot(1,2,2)
    m = distsamples.(field).middle;
    plot(sign(s(partitions(part)))*s(partitions(part):partitions(part+1))),hold on
    plot(1e3,m,'.r')
    hold off
    ylabel('$\widehat\psi_{0,1}$')
    set(gca,'xtick',[])
    set(gca,'xticklabel',[])
    
    
    
    frame = getframe(h);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);

% Think this makes it nice, but is much slower
     %f = export_fig('-nocrop',['-r','300']);
     %[imind,cm] = rgb2ind(f,256,'dither'); 
    drawnow
    % Write to the GIF File
    if i == 1
        imwrite(imind,cm,filename,'gif', 'DelayTime',DelayTime, 'Loopcount',inf);
    else
        imwrite(imind,cm,filename,'gif','DelayTime',DelayTime,'WriteMode','append');
    end
    
    
end






