% Getting data
data0_1 = importdata('/Volumes/Samsung_T5/AR_2/512x256/Pr_0_1/Ra_2e6/Checks/kpsmodes1.txt');
data1 = importdata('/Volumes/Samsung_T5/AR_2/512x256/Pr_1/Ra_2e6/Checks/kpsmodes1.txt');
data1_5 = importdata('/Volumes/Samsung_T5/AR_2/512x256/Pr_1_5/Ra_2e6/Checks/kpsmodes1.txt');
data2 = importdata('/Volumes/Samsung_T5/AR_2/512x256/Pr_2/Ra_2e6/Checks/kpsmodes1.txt');
data3 = importdata('/Volumes/Samsung_T5/AR_2/512x256/Pr_3/Ra_2e6/Checks/kpsmodes1.txt');
data5 = importdata('/Volumes/Samsung_T5/AR_2/512x256/Pr_5/Ra_2e6/Checks/kpsmodes1.txt');
data10 = importdata('/Volumes/Samsung_T5/AR_2/512x256/Pr_10/Ra_2e6/Checks/kpsmodes1.txt');
%%
t0_1 = data0_1(:,1);
t1 = data1(:,1);
t1_5 = data1_5(:,1);
t2 = data2(:,1);
t3 = data3(:,1);
t5 = data5(:,1);
t10 = data10(:,1);

s0_1 = abs(data0_1(:,2)); % Taking absolute value before we calculate the mean
s1 = abs(data1(:,2));
s1_5 = abs(data1_5(:,2));
s2 = abs(data2(:,2));
s3 = abs(data3(:,2));
s5 = abs(data5(:,2));
s10 = abs(data10(:,2));
% Finding means
s0_1 = s0_1(152000:200200);
t0_1 = t0_1(152000:200200);
m(1) = MyMean(s0_1,t0_1);

s1 = s1(55000:end);
t1 = t1(55000:end);
m(2) = MyMean(s1,t1);

s1_5 = s1_5(150000:end);
t1_5 = t1_5(150000:end);
m(3) = MyMean(s1_5,t1_5);

s2 = s2(2000:end);
t2 = t2(2000:end);
m(4) = MyMean(s2,t2);

s3 = s3(4000:end);
t3 = t3(4000:end);
m(5) = MyMean(s3,t3);

s5 = s5(4000:end);
t5 = t5(4000:end);
m(6) = MyMean(s5,t5);

s10 = s10(8000:end);
t10 = t10(8000:end);
m(7) = MyMean(s10,t10);

Pr = [0.1 1 1.5 2 3 5 10];

figure('Renderer', 'painters', 'Position', [5 5 540 200])
p1 = semilogy(Pr(1:3), m(1:3), 'b*', 'DisplayName', 'Bursts'); 
hold on
p2 = plot(Pr(4:7), m(4:7), 'ro', 'DisplayName', 'No-Bursts'); 
xlabel("$Pr$",'Interpreter','latex', 'FontSize', 13)
ylabel("$m$",'Interpreter','latex', 'FontSize', 13)
plot([Pr(4) Pr(7)], [m(4) m(7)], 'black--' )
legend([p1 p2],'Location', 'northeast')
title("$Ra = 2 \times 10^6$",'Interpreter','latex', 'FontSize', 14)
gtext('$m \propto 0.92^{Pr}$','FontSize',13,'Interpreter','latex','color', 'black')
hold off
