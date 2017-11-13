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
    disp('Sem par�metros de entrada!')
    return;
end

%% Optem resposta ao degrau 1 malha
conv.FTMA1 = feedback(conv.C*conv.vC0_d,conv.Hv);

hsfig=figure;
step(conv.FTMA1) % Obt�m resposta ao degrau
grid on
title('')
xlabel('Tempo','Interpreter','latex')
ylabel('Amplitude (V)','Interpreter','latex')
legend({'$v_0(s)$'},'Interpreter','latex')
print(hsfig,[conv.tipo '\StepResponse1malha' ],'-depsc') % Salva resposta ao degrau

conv.Step = stepinfo(conv.FTMA1,'SettlingTimeThreshold',0.05,'RiseTimeLimits',[0.05,0.95]);
conv.ST=(15*conv.Step.SettlingTime); % Tempo de acomoda��o
disp(['Recomenda-se um tempo m�nimo de simula��o igual a: ' num2str(3*conv.ST) ' segundos!'])

%% Optem resposta ao degrau 1 malha AmpOp
% Optem resposta ao degrau
if isfield(conv, 'FTMA1AmpOp')
    
    conv.FTMA1AmpOp = feedback(conv.CApmOp*conv.vC0_d,conv.Hv);
    hsfig=figure;
    step(conv.FTMA1,conv.FTMA1AmpOp) % Obt�m resposta ao degrau
    grid on
    title('')
    xlabel('Tempo','Interpreter','latex')
    ylabel('Amplitude (V)','Interpreter','latex')
    legend({'Original','AmpOp'},'Interpreter','latex')
    
    print(hsfig,[conv.tipo '\StepResponse1malhaAmpOp' ],'-depsc') % Salva resposta ao degrau
    
    conv.StepAmpOp = stepinfo(conv.FTMA1AmpOp,'SettlingTimeThreshold',0.05,'RiseTimeLimits',[0.05,0.95]);
    
end


%% Tabela com par�metros do conversor
filename=[conv.tipo '\' conv.tipo '_step1malha.tex'];

% call fprintf to print the updated text strings
fid = fopen(filename,'w','n','UTF-8');
if fid==-1
    disp('Erro ao abrir o arquivo para escrita dos par�metros!')
    return
end

fprintf(fid, '%s%c%c', '% Tabela com resposta ao degrau de refer�ncia',13,10);
fprintf(fid, '%s%c%c', '\begin{table}[!ht]',13,10);
fprintf(fid, '%s%c%c', '\centering',13,10);
fprintf(fid, '%s%c%c', ['\caption{Resposta ao degrau de refer�ncia de tens�o $v_{C0}$ do conversor ' conv.tipo ', registro acad�mico de n�mero $' num2str(conv.RA) '$}'],13,10);
fprintf(fid, '%s%c%c', '\label{tab:parametros}',13,10);
fprintf(fid, '%s%c%c', '\begin{tabular}{@{}cc@{}}',13,10);
fprintf(fid, '%s%c%c', '\toprule',13,10);
fprintf(fid, '%s%c%c', '\textbf{Descri��o} & \textbf{Valor}\\ \midrule',13,10);
fprintf(fid, '%s%c%c', ['Tempo de subida & \SI{' num2str(conv.Step.RiseTime*1000) '}{\milli\s}\\'],13,10);
fprintf(fid, '%s%c%c', ['Tempo de acomoda��o & \SI{' num2str(conv.Step.SettlingTime*1000) '}{\milli\s}\\'],13,10);
fprintf(fid, '%s%c%c', ['Tens�o m�xima de acomoda��o & \SI{' num2str(conv.Step.SettlingMax) '}{\V}\\'],13,10);
fprintf(fid, '%s%c%c', ['Tens�o m�nima de acomoda��o & \SI{' num2str(conv.Step.SettlingMin) '}{\V}\\'],13,10);
fprintf(fid, '%s%c%c', ['Sobresinal & \SI{' num2str(conv.Step.Overshoot) '}{\V}\\'],13,10);
fprintf(fid, '%s%c%c', ['Tens�o de pico & \SI{' num2str(conv.Step.Peak) '}{\V}\\'],13,10);
fprintf(fid, '%s%c%c', ['Tempo da tens�o de pico & \SI{' num2str(conv.Step.PeakTime*1000) '}{\milli\s}\\'],13,10);
fprintf(fid, '%s%c%c', '\bottomrule',13,10);
fprintf(fid, '%s%c%c', '\end{tabular}',13,10);
fprintf(fid, '%s%c%c', '\end{table}',13,10);
fprintf(fid, '%s%c%c', '',13,10);

fclose(fid);

if isfield(conv, 'FTMA1AmpOp')
    filename=[conv.tipo '\' conv.tipo '_step1malhaAmpOp.tex'];
    
    % call fprintf to print the updated text strings
    fid = fopen(filename,'w','n','UTF-8');
    if fid==-1
        disp('Erro ao abrir o arquivo para escrita dos par�metros!')
        return
    end
    
    fprintf(fid, '%s%c%c', '% Tabela com resposta ao degrau de refer�ncia',13,10);
    fprintf(fid, '%s%c%c', '\begin{table}[!ht]',13,10);
    fprintf(fid, '%s%c%c', '\centering',13,10);
    fprintf(fid, '%s%c%c', ['\caption{Resposta ao degrau de refer�ncia de tens�o $v_{C0}$ do conversor ' conv.tipo ', implementado com Amplificador Operacional.}'],13,10);
    fprintf(fid, '%s%c%c', '\label{tab:parametros}',13,10);
    fprintf(fid, '%s%c%c', '\begin{tabular}{@{}cc@{}}',13,10);
    fprintf(fid, '%s%c%c', '\toprule',13,10);
    fprintf(fid, '%s%c%c', '\textbf{Descri��o} & \textbf{Valor}\\ \midrule',13,10);
    fprintf(fid, '%s%c%c', ['Tempo de subida & \SI{' num2str(conv.StepAmpOp.RiseTime*1000) '}{\milli\s}\\'],13,10);
    fprintf(fid, '%s%c%c', ['Tempo de acomoda��o & \SI{' num2str(conv.StepAmpOp.SettlingTime*1000) '}{\milli\s}\\'],13,10);
    fprintf(fid, '%s%c%c', ['Tens�o m�xima de acomoda��o & \SI{' num2str(conv.StepAmpOp.SettlingMax) '}{\V}\\'],13,10);
    fprintf(fid, '%s%c%c', ['Tens�o m�nima de acomoda��o & \SI{' num2str(conv.StepAmpOp.SettlingMin) '}{\V}\\'],13,10);
    fprintf(fid, '%s%c%c', ['Sobresinal & \SI{' num2str(conv.StepAmpOp.Overshoot) '}{\V}\\'],13,10);
    fprintf(fid, '%s%c%c', ['Tens�o de pico & \SI{' num2str(conv.StepAmpOp.Peak) '}{\V}\\'],13,10);
    fprintf(fid, '%s%c%c', ['Tempo da tens�o de pico & \SI{' num2str(conv.StepAmpOp.PeakTime*1000) '}{\milli\s}\\'],13,10);
    fprintf(fid, '%s%c%c', '\bottomrule',13,10);
    fprintf(fid, '%s%c%c', '\end{tabular}',13,10);
    fprintf(fid, '%s%c%c', '\end{table}',13,10);
    fprintf(fid, '%s%c%c', '',13,10);
    
    fclose(fid);
end
