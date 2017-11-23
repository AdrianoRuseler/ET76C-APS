% =========================================================================
% ***
% *** The MIT License (MIT)
% ***
% *** Copyright (c) 2017 AdrianoRuseler
% ***
% *** Permission is hereby granted, free of charge, to any person obtaining a copy
% *** of this software and associated documentation files (the "Software"), to deal
% *** in the Software without restriction, including without limitation the rights
% *** to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% *** copies of the Software, and to permit persons to whom the Software is
% *** furnished to do so, subject to the following conditions:
% ***
% *** The above copyright notice and this permission notice shall be included in all
% *** copies or substantial portions of the Software.
% ***
% *** THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% *** IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% *** FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% *** AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% *** LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% *** OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% *** SOFTWARE.
% ***
% =========================================================================

function hsfig = stepplot(t1,y1,t2,y2,InputOffset)

% FTMA=conv.FTMA1;
% InputOffset=conv.VC;
opt = stepDataOptions; % 
opt.InputOffset = InputOffset; %
opt.StepAmplitude =InputOffset/2; %
[y1,t1]=step(FTMA,opt); % Obtem resposta ao degrau
opt.StepAmplitude =-InputOffset/2; %
[y2,t2]=step(FTMA,opt); % Obtem resposta ao degrau

hsfig=figure;
haxes1=subplot(2,1,1);
t1=t1.*1e3;
plot(haxes1,t1,y1,'LineWidth',2)
grid on
xlim([t1(1) t1(end)])
title('')
xlabel('')
ylabel('Amplitude (V)','Interpreter','latex')
legend({'$v_0(s)$'},'Interpreter','latex')
set(haxes1,'XTickLabel',[])

% hsfig=figure;
haxes2=subplot(2,1,2);
t2=t2.*1e3;
plot(haxes2,t2,y2,'LineWidth',2)
grid on
xlim([t2(1) t2(end)])
title('')
xlabel('Tempo (ms)','Interpreter','latex')
ylabel('Amplitude (V)','Interpreter','latex')
legend({'$v_0(s)$'},'Interpreter','latex')

set(haxes1,'Position',[0.15 0.55 0.75 0.4]);
set(haxes2,'Position',[0.15 0.1 0.75 0.4]);

