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

%% Optem resposta ao degrau
conv.FTMA1 = feedback(conv.C*conv.vC0_d,conv.Hv);

hsfig=figure;
step(conv.FTMA1) % Obtêm resposta ao degrau
grid on
title('')
xlabel('Tempo','Interpreter','latex')
ylabel('Amplitude (V)','Interpreter','latex')

print(hsfig,[conv.tipo '\StepResponse1malha' ],'-depsc') % Salva resposta ao degrau

conv.Step = stepinfo(conv.FTMA1,'SettlingTimeThreshold',0.05,'RiseTimeLimits',[0.05,0.95]);
conv.ST=(1.5*conv.Step.SettlingTime); % Tempo de acomodação
disp(['Recomenda-se um tempo mínimo de simulação igual a: ' num2str(3*conv.ST) ' segundos!'])

%% Tabela com parâmetros do conversor
filename=[conv.tipo '\' conv.tipo '_step1malha.tex'];

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
fprintf(fid, '%s%c%c', '\label{tab:parametros}',13,10);
fprintf(fid, '%s%c%c', '\begin{tabular}{@{}cc@{}}',13,10);
fprintf(fid, '%s%c%c', '\toprule',13,10);
fprintf(fid, '%s%c%c', '\textbf{Descrição} & \textbf{Valor}\\ \midrule',13,10);
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



