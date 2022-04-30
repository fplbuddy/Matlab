run Params.m
run SomeInputStuff.m
% Set up
GifT = 45;
F = 10;
SizeOfMean = 12;
SizeOfParicle = 15;
% Inputs
Mode1 = 'psRe(0,1)';
Mode2 = 'psRe(1,1)';
% Get data
[Signal1, t1, tit1] = TimeSer(Mode1, AllData, ARS, PrS, RaS,0);
[Signal2, t2, tit2] = TimeSer(Mode2, AllData, ARS, PrS, RaS,1);
% Getting averge points
% PosShear
xPS = MyMean(Signal1, t1, AllData.(ARS).(PrS).(RaS).calcs.pos);
yPS = MyMean(Signal2, t2, AllData.(ARS).(PrS).(RaS).calcs.pos);
% NegShear
xNS = MyMean(Signal1, t1, AllData.(ARS).(PrS).(RaS).calcs.neg);
yNS = MyMean(Signal2, t2, AllData.(ARS).(PrS).(RaS).calcs.neg);
% Zero 
xZ = MyMean(Signal1, t1, AllData.(ARS).(PrS).(RaS).calcs.zero);
yZ = MyMean(Signal2, t2, AllData.(ARS).(PrS).(RaS).calcs.zero);

% Section we want
Section = [1.38e5:1.42e5 3.6e5:3.65e5];
DelayTime = GifT/(length(Section)/F);

%% Make gif
set(0,'DefaultFigureVisible','off')
h = figure;
axis tight manual % this ensures that getframe() returns a consistent size
filename = 'testAnimated.gif';
for i = 1:F:length(Section)
    disp(i)
    j = Section(i);
    % Draw instant
    plot1 = plot(Signal1(1:j), Signal2(1:j), 'LineWidth', 0.5); hold on
    plot1.Color(4) = 0.1;
    plot(xPS, yPS, 'red.', 'MarkerSize', SizeOfMean);
    plot(xNS, yNS, 'red.', 'MarkerSize', SizeOfMean);
    plot(xZ, yZ, 'red.', 'MarkerSize', SizeOfMean);
    plot(Signal1(j), Signal2(j), 'black.', 'MarkerSize', SizeOfParicle);
    xlabel(['$' tit1 '$'], 'Fontsize',14)
    ylabel(['$' tit2 '$'], 'Fontsize',14)
    title({['$' AllData.(ARS).(PrS).(RaS).title '$']; ['$t = ' num2str(t1(j), ceil(log10(t1(j)))) '$']}, 'FontSize', 15)
    ylim([0 0.14])
    hold off
    %drawnow 
      % Capture the plot as an image 
      frame = getframe(h); 
      im = frame2im(frame); 
      [imind,cm] = rgb2ind(im,256); 
      % Write to the GIF File 
      if i == 1 
          imwrite(imind,cm,filename,'gif', 'DelayTime',DelayTime, 'Loopcount',inf); 
      else 
          imwrite(imind,cm,filename,'gif','DelayTime',DelayTime,'WriteMode','append'); 
      end 
end
set(0,'DefaultFigureVisible','on')
close all
clearvars -except AllData