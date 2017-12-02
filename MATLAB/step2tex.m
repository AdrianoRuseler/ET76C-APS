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

function conv = step2tex(conv)
if nargin < 1
    disp('Sem parâmetros de entrada!')
    return;
end

%% Optem resposta ao degrau 1 malha
conv.FTMA1 = feedback(conv.Cv*conv.vC0_d,conv.Hv);
FTMA=conv.FTMA1;
opt = stepDataOptions; % 
opt.InputOffset = conv.VC; %
opt.StepAmplitude =opt.InputOffset/2; %
[y1,t1]=step(FTMA,opt); % Obtem resposta ao degrau
t1=t1.*1e3;
opt.StepAmplitude =-opt.InputOffset/2; %
[y2,t2]=step(FTMA,opt); % Obtem resposta ao degrau
t2=t2.*1e3;

hsfig=figure;
haxes1=subplot(2,1,1);
plot(haxes1,t1,y1,'LineWidth',2)
grid on
xlim([t1(1) t1(end)])
title('')
xlabel('')
ylabel('Amplitude (V)','Interpreter','latex')
legend({'Cont\''inuo'},'Interpreter','latex')
set(haxes1,'XTickLabel',[])
title(['RA: ' num2str(conv.RA)],'Interpreter','latex')

% hsfig=figure;
haxes2=subplot(2,1,2);
plot(haxes2,t2,y2,'LineWidth',2)
grid on
xlim([t2(1) t2(end)])
title('')
xlabel('Tempo (ms)','Interpreter','latex')
ylabel('Amplitude (V)','Interpreter','latex')
legend({'Cont\''inuo'},'Interpreter','latex')

set(haxes1,'Position',[0.15 0.55 0.75 0.4]);
set(haxes2,'Position',[0.15 0.1 0.75 0.4]);

linkaxes([haxes1 haxes2],'x') % Linka eixos x

conv.StepData.t1=t1;
conv.StepData.y1=y1;
conv.StepData.t2=t2;
conv.StepData.y2=y2;

print(hsfig,[conv.latex.figsdir  '\' conv.tipo 'StepResponse1malha' ],'-depsc') % Salva resposta ao degrau

conv.Step = stepinfo(conv.FTMA1,'SettlingTimeThreshold',0.05,'RiseTimeLimits',[0.05,0.95]);
conv.ST=(15*conv.Step.SettlingTime); % Tempo de acomodação
disp(['Recomenda-se um tempo mínimo de simulação igual a: ' num2str(3*conv.ST) ' segundos!'])


%% Optem resposta ao degrau 1 malha AmpOp
% Optem resposta ao degrau
if isfield(conv, 'CApmOp')
    conv.FTMA1AmpOp = feedback(conv.CApmOp*conv.vC0_d,conv.Hv);
    
    FTMA=conv.FTMA1AmpOp;
    opt = stepDataOptions; %
    opt.InputOffset = conv.VC; %
    opt.StepAmplitude =opt.InputOffset/2; %
    [y1,t1]=step(FTMA,opt,conv.StepData.t1(:,1)*1e-3); % Obtem resposta ao degrau
    t1=t1.*1e3;
    opt.StepAmplitude =-opt.InputOffset/2; %
    [y2,t2]=step(FTMA,opt,conv.StepData.t1(:,1)*1e-3); % Obtem resposta ao degrau
    t2=t2.*1e3;
     
    hsfig=figure;
    haxes1=subplot(2,1,1);
    plot(haxes1,t1,y1,'LineWidth',2)
    grid on
    xlim([t1(1) t1(end)])
    title('')
    xlabel('')
    ylabel('Amplitude (V)','Interpreter','latex')
    legend({'Anal\''ogico'},'Interpreter','latex')
    set(haxes1,'XTickLabel',[])
    title(['RA: ' num2str(conv.RA)],'Interpreter','latex')
    
    % hsfig=figure;
    haxes2=subplot(2,1,2);

    plot(haxes2,t2,y2,'LineWidth',2)
    grid on
    xlim([t2(1) t2(end)])
    title('')
    xlabel('Tempo (ms)','Interpreter','latex')
    ylabel('Amplitude (V)','Interpreter','latex')
    legend({'Anal\''ogico'},'Interpreter','latex')
    
    set(haxes1,'Position',[0.15 0.55 0.75 0.4]);
    set(haxes2,'Position',[0.15 0.1 0.75 0.4]); 
    
    linkaxes([haxes1 haxes2],'x') % Linka eixos x
    
    conv.StepData.t1=[conv.StepData.t1 t1];    
    conv.StepData.y1=[conv.StepData.y1 y1];
    conv.StepData.t2=[conv.StepData.t2 t2];
    conv.StepData.y2=[conv.StepData.y2 y2];
    
    
    print(hsfig,[conv.latex.figsdir '\' conv.tipo 'StepResponse1malhaAmpOp' ],'-depsc') % Salva resposta ao degrau
    
    conv.StepAmpOp = stepinfo(conv.FTMA1AmpOp,'SettlingTimeThreshold',0.05,'RiseTimeLimits',[0.05,0.95]);
    
end


%% Controle discreto

if isfield(conv, 'Cz')
    conv.FTMA1z = feedback(conv.Cz*c2d(conv.vC0_d,conv.Ta),c2d(tf(conv.Hv),conv.Ta)); % Resposta digital
    
    FTMA=conv.FTMA1z;
    opt = stepDataOptions; %
    opt.InputOffset = conv.VC; %
    opt.StepAmplitude =opt.InputOffset/2; %
    [y1,t1]=step(FTMA,opt); % Obtem resposta ao degrau
    opt.StepAmplitude =-opt.InputOffset/2; %
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
    legend({'Discreto'},'Interpreter','latex')
    set(haxes1,'XTickLabel',[])
    title(['RA: ' num2str(conv.RA)],'Interpreter','latex')
    
    % hsfig=figure;
    haxes2=subplot(2,1,2);
    t2=t2.*1e3;
    plot(haxes2,t2,y2,'LineWidth',2)
    grid on
    xlim([t2(1) t2(end)])
    title('')
    xlabel('Tempo (ms)','Interpreter','latex')
    ylabel('Amplitude (V)','Interpreter','latex')
    legend({'Discreto'},'Interpreter','latex')
    
    set(haxes1,'Position',[0.15 0.55 0.75 0.4]);
    set(haxes2,'Position',[0.15 0.1 0.75 0.4]); 
    
    linkaxes([haxes1 haxes2],'x') % Linka eixos x
    
    print(hsfig,[conv.latex.figsdir '\' conv.tipo 'StepResponse1malhaDiscreto' ],'-depsc') % Salva resposta ao degrau    
    conv.StepDiscreto = stepinfo(conv.FTMA1z,'SettlingTimeThreshold',0.05,'RiseTimeLimits',[0.05,0.95]);  
end

%% Plota todos juntos 
if isfield(conv, 'Cz') && isfield(conv, 'CApmOp') && isfield(conv, 'Cv')       
    hsfig=figure;
    haxes1=subplot(2,1,1);
%     t1=t1.*1e3;
    plot(haxes1,conv.StepData.t1,conv.StepData.y1,'LineWidth',2)
    hold all
    plot(haxes1,t1,y1,'LineWidth',2)
    grid on
    xlim([t1(1) t1(end)])
    title('')
    xlabel('')
    ylabel('Amplitude (V)','Interpreter','latex')
    legend({'Cont\''inuo','Anal\''ogico','Discreto'},'Interpreter','latex')
    set(haxes1,'XTickLabel',[])
    title(['RA: ' num2str(conv.RA)],'Interpreter','latex')
    
    % hsfig=figure;
    haxes2=subplot(2,1,2);
%     t2=t2.*1e3;
    plot(haxes2,conv.StepData.t2,conv.StepData.y2,'LineWidth',2)
    hold all
    plot(haxes2,t2,y2,'LineWidth',2)
    grid on
    xlim([t2(1) t2(end)])
    title('')
    xlabel('Tempo (ms)','Interpreter','latex')
    ylabel('Amplitude (V)','Interpreter','latex')
     legend({'Cont\''inuo','Anal\''ogico','Discreto'},'Interpreter','latex')
    
    set(haxes1,'Position',[0.15 0.55 0.75 0.4]);
    set(haxes2,'Position',[0.15 0.1 0.75 0.4]); 
    
    linkaxes([haxes1 haxes2],'x') % Linka eixos x    
    print(hsfig,[conv.latex.figsdir '\' conv.tipo 'StepResponse1malhaTodos' ],'-depsc') % Salva resposta ao degrau  
    
end
    

%% Optem resposta ao degrau para duas malhas
if isfield(conv,'C2i')
    conv.FTMA2i = feedback(conv.C2i*conv.iL0_d,conv.Hi);
    conv.FTMA2 = feedback(conv.C2v*conv.FTMA2i,conv.Hv);
    opt = stepDataOptions; %
    opt.InputOffset = conv.VC; %
    opt.StepAmplitude = opt.InputOffset/2; %
    
    FTMA=conv.FTMA2;
    opt = stepDataOptions; %
    opt.InputOffset = conv.VC; %
    opt.StepAmplitude =opt.InputOffset/2; %
    [y1,t1]=step(FTMA,opt); % Obtem resposta ao degrau
    opt.StepAmplitude =-opt.InputOffset/2; %
    [y2,t2]=step(FTMA,opt); % Obtem resposta ao degrau
    
    FTMA=conv.FTMA1;
    opt.StepAmplitude =opt.InputOffset/2; %
    [y11,t11]=step(FTMA,opt,t1); % Obtem resposta ao degrau
    opt.StepAmplitude =-opt.InputOffset/2; %
    [y21,t21]=step(FTMA,opt,t1); % Obtem resposta ao degrau
    
    hsfig=figure;
    haxes1=subplot(2,1,1);
    t1=t1.*1e3;
    plot(haxes1,t1,y1,'LineWidth',2)
    hold all
    plot(haxes1,t1,y11,'LineWidth',2)
    grid on
    xlim([t1(1) t1(end)])
    title('')
    xlabel('')
    ylabel('Amplitude (V)','Interpreter','latex')
    legend({'2 Malhas','1 Malha'},'Interpreter','latex')
    set(haxes1,'XTickLabel',[])
    title(['RA: ' num2str(conv.RA)],'Interpreter','latex')
    
    % hsfig=figure;
    haxes2=subplot(2,1,2);
    t2=t2.*1e3;
    plot(haxes2,t2,y2,'LineWidth',2)
    hold all
    plot(haxes2,t2,y21,'LineWidth',2)
    grid on
    xlim([t2(1) t2(end)])
    title('')
    xlabel('Tempo (ms)','Interpreter','latex')
    ylabel('Amplitude (V)','Interpreter','latex')
    legend({'2 Malhas','1 Malha'},'Interpreter','latex')
    
    set(haxes1,'Position',[0.15 0.55 0.75 0.4]);
    set(haxes2,'Position',[0.15 0.1 0.75 0.4]);
    linkaxes([haxes1 haxes2],'x') % Linka eixos x
    
    print(hsfig,[conv.latex.figsdir '\' conv.tipo 'StepResponse2malhas' ],'-depsc') % Salva resposta ao degrau
    conv.Step2malhas = stepinfo(conv.FTMA2,'SettlingTimeThreshold',0.05,'RiseTimeLimits',[0.05,0.95]);    
%     conv.ST=(15*conv.Step2malhas.SettlingTime); % Tempo de acomodação    
end
%% Tabela com parâmetros do conversor
filename=[conv.latex.tablesdir '\' conv.tipo '_step1malha.tex'];

[Gm,Pm,Wgm,Wpm] = margin(conv.Cv*conv.vC0_d*conv.Hv);
Gm_dB = 20*log10(Gm); % Margem de ganho

% call fprintf to print the updated text strings
fid = fopen(filename,'w','n','UTF-8');
if fid==-1
    disp('Erro ao abrir o arquivo para escrita dos parâmetros!')
    return
end

fprintf(fid, '%s%c%c', '% Tabela com resposta ao degrau de referência',13,10);
fprintf(fid, '%s%c%c', '\begin{table}[!ht]',13,10);
fprintf(fid, '%s%c%c', '\centering',13,10);
fprintf(fid, '%s%c%c', ['\caption{Resposta ao degrau de referência de tensão $v_{C0}$ do conversor ' conv.tipo ', registro acadêmico de número $' num2str(conv.RA) '$}'],13,10);
fprintf(fid, '%s%c%c', '\label{tab:resposta1malha}',13,10);
fprintf(fid, '%s%c%c', '\begin{tabular}{@{}cc@{}}',13,10);
fprintf(fid, '%s%c%c', '\toprule',13,10);
fprintf(fid, '%s%c%c', '\textbf{Descrição} & \textbf{Valor}\\ \midrule',13,10);
fprintf(fid, '%s%c%c', ['Ganho proporcional & \SI{' num2str(conv.Kp) '}{}\\'],13,10);
fprintf(fid, '%s%c%c', ['Ganho integral & \SI{' num2str(conv.Ki) '}{}\\'],13,10);
fprintf(fid, '%s%c%c', ['Margem de ganho & \SI{' num2str(Gm_dB) '}{\deci\bel}\\'],13,10);
fprintf(fid, '%s%c%c', ['Margem de fase & \SI{' num2str(Pm) '}{\degree}\\'],13,10);
fprintf(fid, '%s%c%c', ['Frequência de cruzamento & \SI{' num2str(Wpm) '}{\radian\per\s}\\'],13,10);
fprintf(fid, '%s%c%c', ['Tempo de subida & \SI{' num2str(conv.Step.RiseTime*1000) '}{\milli\s}\\'],13,10);
fprintf(fid, '%s%c%c', ['Tempo de acomodação & \SI{' num2str(conv.Step.SettlingTime*1000) '}{\milli\s}\\'],13,10);
fprintf(fid, '%s%c%c', ['Tensão máxima de acomodação & \SI{' num2str(conv.Step.SettlingMax) '}{\V}\\'],13,10);
fprintf(fid, '%s%c%c', ['Tensão mínima de acomodação & \SI{' num2str(conv.Step.SettlingMin) '}{\V}\\'],13,10);
fprintf(fid, '%s%c%c', ['Sobresinal & \SI{' num2str(conv.Step.Overshoot) '}{\V}\\'],13,10);
fprintf(fid, '%s%c%c', ['Tensão de pico & \SI{' num2str(conv.Step.Peak) '}{\V}\\'],13,10);
fprintf(fid, '%s%c%c', ['Tempo da tensão de pico & \SI{' num2str(conv.Step.PeakTime*1000) '}{\milli\s}\\'],13,10);
fprintf(fid, '%s%c%c', '\bottomrule',13,10);
fprintf(fid, '%s%c%c', '\end{tabular}',13,10);
fprintf(fid, '%s%c%c', '\end{table}',13,10);
fprintf(fid, '%s%c%c', '',13,10);

fclose(fid);

if isfield(conv, 'FTMA1AmpOp')
    filename=[conv.latex.tablesdir '\' conv.tipo '_step1malhaAmpOp.tex']; 
    % call fprintf to print the updated text strings
    
    [Gm,Pm,Wgm,Wpm] = margin(conv.CApmOp*conv.vC0_d*conv.Hv);
    Gm_dB = 20*log10(Gm); % Margem de ganho
    fid = fopen(filename,'w','n','UTF-8');
    if fid==-1
        disp('Erro ao abrir o arquivo para escrita dos parâmetros!')
        return
    end
    
    fprintf(fid, '%s%c%c', '% Tabela com resposta ao degrau de referência',13,10);
    fprintf(fid, '%s%c%c', '\begin{table}[!ht]',13,10);
    fprintf(fid, '%s%c%c', '\centering',13,10);
    fprintf(fid, '%s%c%c', ['\caption{Resposta ao degrau de referência de tensão $v_{C0}$ do conversor ' conv.tipo ', registro acadêmico de número $' num2str(conv.RA) '$, implementado com Amplificador Operacional.}'],13,10);
    fprintf(fid, '%s%c%c', '\label{tab:resposta1malhaAmpOp}',13,10);
    fprintf(fid, '%s%c%c', '\begin{tabular}{@{}cc@{}}',13,10);
    fprintf(fid, '%s%c%c', '\toprule',13,10);
    fprintf(fid, '%s%c%c', '\textbf{Descrição} & \textbf{Valor}\\ \midrule',13,10);
    fprintf(fid, '%s%c%c', ['Ganho proporcional & \SI{' num2str(conv.Kpf) '}{}\\'],13,10);
    fprintf(fid, '%s%c%c', ['Ganho integral & \SI{' num2str(conv.Kif) '}{}\\'],13,10);
    fprintf(fid, '%s%c%c', ['Margem de ganho & \SI{' num2str(Gm_dB) '}{\deci\bel}\\'],13,10);
    fprintf(fid, '%s%c%c', ['Margem de fase & \SI{' num2str(Pm) '}{\degree}\\'],13,10);
    fprintf(fid, '%s%c%c', ['Frequência de cruzamento & \SI{' num2str(Wpm) '}{\radian\per\s}\\'],13,10);
    fprintf(fid, '%s%c%c', ['Resistor do controlador PI $R_{1_{PI}}$ & \SI{' num2str(conv.R1pi/1000) '}{\kilo\ohm}\\'],13,10);
    fprintf(fid, '%s%c%c', ['Resistor do controlador PI $R_{2_{PI}}$ & \SI{' num2str(conv.R2pi) '}{\ohm}\\'],13,10);
    fprintf(fid, '%s%c%c', ['Resistor do controlador PI $C_{1_{PI}}$ & \SI{' num2str(conv.C1pi*1e9) '}{\nano\F}\\'],13,10);
    fprintf(fid, '%s%c%c', ['Tempo de subida & \SI{' num2str(conv.StepAmpOp.RiseTime*1000) '}{\milli\s}\\'],13,10);
    fprintf(fid, '%s%c%c', ['Tempo de acomodação & \SI{' num2str(conv.StepAmpOp.SettlingTime*1000) '}{\milli\s}\\'],13,10);
    fprintf(fid, '%s%c%c', ['Tensão máxima de acomodação & \SI{' num2str(conv.StepAmpOp.SettlingMax) '}{\V}\\'],13,10);
    fprintf(fid, '%s%c%c', ['Tensão mínima de acomodação & \SI{' num2str(conv.StepAmpOp.SettlingMin) '}{\V}\\'],13,10);
    fprintf(fid, '%s%c%c', ['Sobresinal & \SI{' num2str(conv.StepAmpOp.Overshoot) '}{\V}\\'],13,10);
    fprintf(fid, '%s%c%c', ['Tensão de pico & \SI{' num2str(conv.StepAmpOp.Peak) '}{\V}\\'],13,10);
    fprintf(fid, '%s%c%c', ['Tempo para a tensão de pico & \SI{' num2str(conv.StepAmpOp.PeakTime*1000) '}{\milli\s}\\'],13,10);
    fprintf(fid, '%s%c%c', '\bottomrule',13,10);
    fprintf(fid, '%s%c%c', '\end{tabular}',13,10);
    fprintf(fid, '%s%c%c', '\end{table}',13,10);
    fprintf(fid, '%s%c%c', '',13,10);
    
    fclose(fid);
end


if isfield(conv, 'FTMA2')
    filename=[conv.latex.tablesdir '\' conv.tipo '_step2malhas.tex'];
    
%     [Gmi,Pmi,Wgmi,Wpmi] = margin(conv.C2i*conv.iL0_d*conv.Hi);
%     Gmi_dB = 20*log10(Gmi); % Margem de ganho 
%     [Gmv,Pmv,Wgmv,Wpmv] = margin(conv.vC0_iL0*feedback(conv.C2i*conv.iL0_d,conv.Hi)*conv.Hv);
%     Gmv_dB = 20*log10(Gmv); % Margem de ganho 
    
    % call fprintf to print the updated text strings
    fid = fopen(filename,'w','n','UTF-8');
    if fid==-1
        disp('Erro ao abrir o arquivo para escrita dos parâmetros!')
        return
    end
    
    fprintf(fid, '%s%c%c', '% Tabela com resposta ao degrau de referência',13,10);
    fprintf(fid, '%s%c%c', '\begin{table}[!ht]',13,10);
    fprintf(fid, '%s%c%c', '\centering',13,10);
    fprintf(fid, '%s%c%c', ['\caption{Resposta ao degrau de referência de tensão $v_{C0}$ do conversor ' conv.tipo ', registro acadêmico de número $' num2str(conv.RA) '$, com controle de duas malhas.}'],13,10);
    fprintf(fid, '%s%c%c', '\label{tab:resposta2malhas}',13,10);
    fprintf(fid, '%s%c%c', '\begin{tabular}{@{}cc@{}}',13,10);
    fprintf(fid, '%s%c%c', '\toprule',13,10);
    fprintf(fid, '%s%c%c', '\textbf{Descrição} & \textbf{Valor}\\ \midrule',13,10);
    fprintf(fid, '%s%c%c', ['Ganho proporcional (controle de corrente) & \SI{' num2str(conv.Kp1) '}{}\\'],13,10);
    fprintf(fid, '%s%c%c', ['Ganho integral (controle de corrente) & \SI{' num2str(conv.Ki1) '}{}\\'],13,10);
%     fprintf(fid, '%s%c%c', ['Margem de ganho $Ci$ & \SI{' num2str(Gmi_dB) '}{\deci\bel}\\'],13,10);
%     fprintf(fid, '%s%c%c', ['Margem de fase $Ci$ & \SI{' num2str(Pmi) '}{\degree}\\'],13,10);
%     fprintf(fid, '%s%c%c', ['Frequência de cruzamento $Ci$ & \SI{' num2str(Wpmi) '}{\radian\per\s}\\'],13,10);
    fprintf(fid, '%s%c%c', ['Ganho proporcional (controle de tensão) & \SI{' num2str(conv.Kp2) '}{}\\'],13,10);
    fprintf(fid, '%s%c%c', ['Ganho integral (controle de tensão) & \SI{' num2str(conv.Ki2) '}{}\\'],13,10);
%     fprintf(fid, '%s%c%c', ['Margem de ganho $Cv$ & \SI{' num2str(Gmv_dB) '}{\deci\bel}\\'],13,10);
%     fprintf(fid, '%s%c%c', ['Margem de fase $Cv$ & \SI{' num2str(Pmv) '}{\degree}\\'],13,10);
%     fprintf(fid, '%s%c%c', ['Frequência de cruzamento $Cv$ & \SI{' num2str(Wpmv) '}{\radian\per\s}\\'],13,10);
    fprintf(fid, '%s%c%c', ['Tempo de subida & \SI{' num2str(conv.Step2malhas.RiseTime*1000) '}{\milli\s}\\'],13,10);
    fprintf(fid, '%s%c%c', ['Tempo de acomodação & \SI{' num2str(conv.Step2malhas.SettlingTime*1000) '}{\milli\s}\\'],13,10);
    fprintf(fid, '%s%c%c', ['Tensão máxima de acomodação & \SI{' num2str(conv.Step2malhas.SettlingMax) '}{\V}\\'],13,10);
    fprintf(fid, '%s%c%c', ['Tensão mínima de acomodação & \SI{' num2str(conv.Step2malhas.SettlingMin) '}{\V}\\'],13,10);
    fprintf(fid, '%s%c%c', ['Sobresinal & \SI{' num2str(conv.Step2malhas.Overshoot) '}{\V}\\'],13,10);
    fprintf(fid, '%s%c%c', ['Tensão de pico & \SI{' num2str(conv.Step2malhas.Peak) '}{\V}\\'],13,10);
    fprintf(fid, '%s%c%c', ['Tempo para a tensão de pico & \SI{' num2str(conv.Step2malhas.PeakTime*1000) '}{\milli\s}\\'],13,10);
    fprintf(fid, '%s%c%c', '\bottomrule',13,10);
    fprintf(fid, '%s%c%c', '\end{tabular}',13,10);
    fprintf(fid, '%s%c%c', '\end{table}',13,10);
    fprintf(fid, '%s%c%c', '',13,10);    
    fclose(fid);
end


