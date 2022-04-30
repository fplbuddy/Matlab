path = '/Volumes/Samsung_T5/MatlabComp/Ra_1_25e4/';

% kpsmodes1
kpsmodes1 = importdata([path 'Checks/kthetamodes1.txt']);
num = 2;
s = kpsmodes1(:,num);
t = kpsmodes1(:,1);
figure('Renderer', 'painters', 'Position', [5 5 540 200])
semilogy(t,abs(s))
xlabel('$t$ $(s)$', 'FontSize', 14)
title('kpsmodes1, 2')

num = 4;
s = kpsmodes1(:,num);
figure('Renderer', 'painters', 'Position', [5 5 540 200])
semilogy(t,abs(s))
xlabel('$t$ $(s)$', 'FontSize', 14)
title('kpsmodes1, 4')

num = 6;
s = kpsmodes1(:,num);
figure('Renderer', 'painters', 'Position', [5 5 540 200])
semilogy(t,abs(s))
xlabel('$t$ $(s)$', 'FontSize', 14)
title('kpsmodes1, 6')

% kpsmodes 3
kpsmodes3 = importdata([path 'Checks/kthetamodes3.txt']);
num = 2;
s = kpsmodes3(:,num);
t = kpsmodes3(:,1);
figure('Renderer', 'painters', 'Position', [5 5 540 200])
semilogy(t,abs(s))
xlabel('$t$ $(s)$', 'FontSize', 14)
title('kpsmodes3, 2')

num = 4;
s = kpsmodes3(:,num);
figure('Renderer', 'painters', 'Position', [5 5 540 200])
semilogy(t,abs(s))
xlabel('$t$ $(s)$', 'FontSize', 14)
title('kpsmodes3, 4')

num = 6;
s = kpsmodes3(:,num);
figure('Renderer', 'painters', 'Position', [5 5 540 200])
semilogy(t,abs(s))
xlabel('$t$ $(s)$', 'FontSize', 14)
title('kpsmodes3, 6')

% kpsmodes 2
kpsmodes2 = importdata([path 'Checks/kthetamodes2.txt']);
num = 3;
s = kpsmodes2(:,num);
t = kpsmodes2(:,1);
figure('Renderer', 'painters', 'Position', [5 5 540 200])
semilogy(t,abs(s))
xlabel('$t$ $(s)$', 'FontSize', 14)
title('kpsmodes2, 3')

num = 5;
s = kpsmodes2(:,num);
figure('Renderer', 'painters', 'Position', [5 5 540 200])
semilogy(t,abs(s))
xlabel('$t$ $(s)$', 'FontSize', 14)
title('kpsmodes2, 5')

%% Extra
kpsmodesextra = importdata([path 'Checks/kpsmodesextra.txt']);
num = 2;
s = kpsmodesextra(:,num);
t = kpsmodesextra(:,1);
figure('Renderer', 'painters', 'Position', [5 5 540 200])
plot(t,s)
xlabel('$t$ $(s)$', 'FontSize', 14)
title('kpsmodesextra, 2')

num = 3;
s = kpsmodesextra(:,num);
figure('Renderer', 'painters', 'Position', [5 5 540 200])
plot(t,s)
xlabel('$t$ $(s)$', 'FontSize', 14)
title('kpsmodesextra, 3')

num = 4;
s = kpsmodesextra(:,num);
figure('Renderer', 'painters', 'Position', [5 5 540 200])
plot(t,s)
xlabel('$t$ $(s)$', 'FontSize', 14)
title('kpsmodesextra, 4')

num = 5;
s = kpsmodesextra(:,num);
figure('Renderer', 'painters', 'Position', [5 5 540 200])
plot(t,s)
xlabel('$t$ $(s)$', 'FontSize', 14)
title('kpsmodesextra, 5')

%ylabel('$\hat \psi_{0,1}$', 'FontSize', 14)
%title('$Pr = 30, Ra = 1 \times 10^6, \Gamma = 1$', 'FontSize', 15)

%%
path = '/Volumes/Samsung_T5/MATLAB_comp/Ra_3_8e4/';

% kpsmodes1
kpsmodes1 = importdata([path 'Checks/kthetamodes1.txt']);

num = 4;
t = kpsmodes1(:,1);
s = kpsmodes1(:,num);
figure('Renderer', 'painters', 'Position', [5 5 540 200])
plot(t,s)
xlabel('$t$ $(s)$', 'FontSize', 14)
title('kpsmodes1, 4')

%%
figure('Renderer', 'painters', 'Position', [5 5 540 200])
path = '/Volumes/Samsung_T5/Low_Dim/4x14_32/AR_1/Pr_30/Ra_1e6/';
kpsmodes1 = importdata([path 'Checks/kthetamodes1.txt']);

subplot(1,2,1)
plot(kpsmodes1(:,1), kpsmodes1(:,2))
ylabel('$\hat \psi_{0,1}$', 'FontSize', 14)
xlabel('$t$', 'FontSize', 14)
xlim([1e4 max(kpsmodes1(:,1))])
subplot(1,2,2)
plot(kpsmodes1(:,1), kpsmodes1(:,2))
xlabel('$t$', 'FontSize', 14)
xlim([1e4 1.1e4])
sgtitle('$Ra = 1 \times 10^6, Pr = 30, \Gamma =1 $')



