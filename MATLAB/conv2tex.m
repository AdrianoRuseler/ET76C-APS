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


function conv2tex(conv)

if nargin < 1
    disp('Sem parâmetros de entrada!')
    return;
end


filename=[conv.tipo '\' conv.tipo '_parametros.tex'];

% call fprintf to print the updated text strings
fid = fopen(filename,'w');
if fid==-1
    disp('Erro ao abrir o arquivo para escrita dos parâmetros!')
    return
end

fprintf(fid, '%s%c%c', '% Tabela com parâmetros do conversor',13,10);
fprintf(fid, '%s%c%c', '\begin{table}[!ht]',13,10);
fprintf(fid, '%s%c%c', '\centering',13,10);
fprintf(fid, '%s%c%c', ['\caption{Parâmetros de projeto do conversor ' conv.tipo ' referente ao registro acadêmico de número $' num2str(conv.RA) '$}'],13,10);
fprintf(fid, '%s%c%c', '\label{tab:parametros}',13,10);
fprintf(fid, '%s%c%c', '\begin{tabular}{@{}ccc@{}}',13,10);
fprintf(fid, '%s%c%c', '\toprule',13,10);
fprintf(fid, '%s%c%c', '\textbf{Símbolo} & \textbf{Descrição} & \textbf{Valor}\\ \midrule',13,10);
fprintf(fid, '%s%c%c', ['$f_s$ & Frequência de comutação & \SI{' num2str(conv.fs/1000) '}{\kilo\hertz}\\'],13,10);
fprintf(fid, '%s%c%c', ['$V_i$ & Tensão média de entrada  & \SI{' num2str(conv.Vi) '}{\V}\\'],13,10);
fprintf(fid, '%s%c%c', ['$V_0$ & Tensão média de saída  & \SI{' num2str(conv.V0) '}{\V} \\'],13,10);
fprintf(fid, '%s%c%c', ['$P_0$ & Potência processada  & \SI{' num2str(conv.P0) '}{\W} \\'],13,10);
fprintf(fid, '%s%c%c', ['$R_0$ & Resistência de carga & \SI{' num2str(conv.R0) '}{\ohm} \\'],13,10);
fprintf(fid, '%s%c%c', ['$\Delta{i_{L_0}}$  & Ondulação de corrente & \SI{' num2str(conv.DiL0*100) '}{\%}\\'],13,10);
fprintf(fid, '%s%c%c', ['$\Delta{v_{C_0}}$  & Ondulação de tensão & \SI{' num2str(conv.DvC0*100) '}{\%}\\'],13,10);
fprintf(fid, '%s%c%c', ['$L_0$ & Indutância & \SI{' num2str(conv.L0*1e6) '}{\micro\henry}\\'],13,10);
fprintf(fid, '%s%c%c', ['$C_0$ & Capacitância & \SI{' num2str(conv.C0*1e6) '}{\micro\farad}\\'],13,10);
fprintf(fid, '%s%c%c', '\bottomrule',13,10);
fprintf(fid, '%s%c%c', '\end{tabular}',13,10);
fprintf(fid, '%s%c%c', '\end{table}',13,10);
fprintf(fid, '%s%c%c', '',13,10);
fclose(fid);


filename=[conv.tipo '\' conv.tipo '_steadystate.tex'];

% call fprintf to print the updated text strings
fid = fopen(filename,'w');
if fid==-1
    disp('Erro ao abrir o arquivo para escrita do ponto de operação!')
    return
end

fprintf(fid, '%s%c%c', '% Tabela com o ponto de operação do conversor',13,10);
fprintf(fid, '%s%c%c', '\begin{table}[!ht]',13,10);
fprintf(fid, '%s%c%c', '\centering',13,10);
fprintf(fid, '%s%c%c', ['\caption{Ponto de operação do conversor ' conv.tipo ' referente ao registro acadêmico de número $' num2str(conv.RA) '$}'],13,10);
fprintf(fid, '%s%c%c', '\label{tab:steadystate}',13,10);
fprintf(fid, '%s%c%c', '\begin{tabular}{@{}ccc@{}}',13,10);
fprintf(fid, '%s%c%c', '\toprule',13,10);
fprintf(fid, '%s%c%c', '\textbf{Símbolo} & \textbf{Descrição} & \textbf{Valor}\\ \midrule',13,10);
fprintf(fid, '%s%c%c', ['$G$ & Ganho estático & \SI{' num2str(conv.G) '}{}\\'],13,10);
fprintf(fid, '%s%c%c', ['$D$ & Razão cíclida  & \SI{' num2str(conv.D*100) '}{\%}\\'],13,10);
fprintf(fid, '%s%c%c', ['$I_0$ & Corrente média na carga  & \SI{' num2str(conv.I0) '}{\A} \\'],13,10);
fprintf(fid, '%s%c%c', ['$I_{L_0}$ & Corrente média no indutor & \SI{' num2str(conv.IL0) '}{\A} \\'],13,10);
fprintf(fid, '%s%c%c', ['$V_C$ & Tensão de controle  & \SI{' num2str(conv.VC) '}{\V} \\'],13,10);
fprintf(fid, '%s%c%c', ['$V_{CM}$ & Tensão máxima de controle  & \SI{' num2str(conv.VTM) '}{\V} \\'],13,10);
fprintf(fid, '%s%c%c', ['$V_{Cm}$ & Tensão mínima de controle  & \SI{' num2str(conv.VTm) '}{\V} \\'],13,10);
fprintf(fid, '%s%c%c', ['$R_a$ & Resistência de medição & \SI{' num2str(conv.Ra/1000) '}{\kilo\ohm} \\'],13,10);
fprintf(fid, '%s%c%c', ['$R_b$ & Resistência de medição & \SI{' num2str(conv.Rb/1000) '}{\kilo\ohm} \\'],13,10);
fprintf(fid, '%s%c%c', ['$H_v$ & Ganho de medição (tensão) & \SI{' num2str(conv.Hv*1000) '}{\milli\V\per\V} \\'],13,10);
fprintf(fid, '%s%c%c', ['$R_s$ & Resistência shunt & \SI{' num2str(conv.Rs) '}{\ohm} \\'],13,10);
fprintf(fid, '%s%c%c', ['$H_i$ & Ganho de medição (corrente) & \SI{' num2str(conv.Hi) '}{\A\per\A} \\'],13,10);
fprintf(fid, '%s%c%c', '\bottomrule',13,10);
fprintf(fid, '%s%c%c', '\end{tabular}',13,10);
fprintf(fid, '%s%c%c', '\end{table}',13,10);
fprintf(fid, '%s%c%c', '',13,10);
fclose(fid);

