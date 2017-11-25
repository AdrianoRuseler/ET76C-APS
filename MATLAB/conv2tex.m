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
    disp('Sem par�metros de entrada!')
    return
end

%% Tabela com par�metros do conversor

% mkdir([conv.tipo '\Tables'])

filename=[conv.latex.tablesdir '\' conv.tipo '_parametros.tex'];

% call fprintf to print the updated text strings
fid = fopen(filename,'w','n','UTF-8');
if fid==-1
    disp('Erro ao abrir o arquivo para escrita dos par�metros!')
    return
end

% [filename,permission,machinefmt,encodingOut] =fopen(fid)

fprintf(fid, '%s%c%c', '% Tabela com par�metros do conversor',13,10);
fprintf(fid, '%s%c%c', '\begin{table}[!ht]',13,10);
fprintf(fid, '%s%c%c', '\centering',13,10);
fprintf(fid, '%s%c%c', ['\caption{Par�metros de projeto do conversor ' conv.tipo ' referente ao registro acad�mico de n�mero $' num2str(conv.RA) '$}'],13,10);
fprintf(fid, '%s%c%c', '\label{tab:parametros}',13,10);
fprintf(fid, '%s%c%c', '\begin{tabular}{@{}ccc@{}}',13,10);
fprintf(fid, '%s%c%c', '\toprule',13,10);
fprintf(fid, '%s%c%c', '\textbf{S�mbolo} & \textbf{Descri��o} & \textbf{Valor}\\ \midrule',13,10);
fprintf(fid, '%s%c%c', ['$f_s$ & Frequ�ncia de comuta��o & \SI{' num2str(conv.fs/1000) '}{\kilo\hertz}\\'],13,10);
fprintf(fid, '%s%c%c', ['$f_s$ & Frequ�ncia de amostragem & \SI{' num2str(conv.fa/1000) '}{\kilo\hertz}\\'],13,10);
fprintf(fid, '%s%c%c', ['$V_i$ & Tens�o m�dia de entrada  & \SI{' num2str(conv.Vi) '}{\V}\\'],13,10);
fprintf(fid, '%s%c%c', ['$V_0$ & Tens�o m�dia de sa�da  & \SI{' num2str(conv.V0) '}{\V} \\'],13,10);
fprintf(fid, '%s%c%c', ['$P_0$ & Pot�ncia processada  & \SI{' num2str(conv.P0) '}{\W} \\'],13,10);
fprintf(fid, '%s%c%c', ['$R_0$ & Resist�ncia de carga & \SI{' num2str(conv.R0) '}{\ohm} \\'],13,10);
fprintf(fid, '%s%c%c', ['$\Delta{i_{L_0}}$  & Ondula��o de corrente & \SI{' num2str(conv.DiL0*100) '}{\%}\\'],13,10);
fprintf(fid, '%s%c%c', ['$\Delta{v_{C_0}}$  & Ondula��o de tens�o & \SI{' num2str(conv.DvC0*100) '}{\%}\\'],13,10);
fprintf(fid, '%s%c%c', ['$L_0$ & Indut�ncia & \SI{' num2str(conv.L0*1e6) '}{\micro\henry}\\'],13,10);
fprintf(fid, '%s%c%c', ['$C_0$ & Capacit�ncia & \SI{' num2str(conv.C0*1e6) '}{\micro\farad}\\'],13,10);
fprintf(fid, '%s%c%c', '\bottomrule',13,10);
fprintf(fid, '%s%c%c', '\end{tabular}',13,10);
fprintf(fid, '%s%c%c', '\end{table}',13,10);
fprintf(fid, '%s%c%c', '',13,10);
fclose(fid);

%% Ponto de opera��o do conversor

filename=[conv.latex.tablesdir '\' conv.tipo '_steadystate.tex'];

% call fprintf to print the updated text strings
fid = fopen(filename,'w','n','UTF-8');
if fid==-1
    disp('Erro ao abrir o arquivo para escrita do ponto de opera��o!')
    return
end

fprintf(fid, '%s%c%c', '% Tabela com o ponto de opera��o do conversor',13,10);
fprintf(fid, '%s%c%c', '\begin{table}[!ht]',13,10);
fprintf(fid, '%s%c%c', '\centering',13,10);
fprintf(fid, '%s%c%c', ['\caption{Ponto de opera��o do conversor ' conv.tipo ' referente ao registro acad�mico de n�mero $' num2str(conv.RA) '$}'],13,10);
fprintf(fid, '%s%c%c', '\label{tab:steadystate}',13,10);
fprintf(fid, '%s%c%c', '\begin{tabular}{@{}ccc@{}}',13,10);
fprintf(fid, '%s%c%c', '\toprule',13,10);
fprintf(fid, '%s%c%c', '\textbf{S�mbolo} & \textbf{Descri��o} & \textbf{Valor}\\ \midrule',13,10);
fprintf(fid, '%s%c%c', ['$G$ & Ganho est�tico & \SI{' num2str(conv.G) '}{}\\'],13,10);
fprintf(fid, '%s%c%c', ['$D$ & Raz�o c�clida  & \SI{' num2str(conv.D*100) '}{\%}\\'],13,10);
fprintf(fid, '%s%c%c', ['$I_0$ & Corrente m�dia na carga  & \SI{' num2str(conv.I0) '}{\A} \\'],13,10);
fprintf(fid, '%s%c%c', ['$I_{L_0}$ & Corrente m�dia no indutor & \SI{' num2str(conv.IL0) '}{\A} \\'],13,10);
fprintf(fid, '%s%c%c', ['$R_a$ & Resist�ncia de medi��o & \SI{' num2str(conv.Ra/1000) '}{\kilo\ohm} \\'],13,10);
fprintf(fid, '%s%c%c', ['$R_b$ & Resist�ncia de medi��o & \SI{' num2str(conv.Rb/1000) '}{\kilo\ohm} \\'],13,10);
fprintf(fid, '%s%c%c', ['$H_v$ & Ganho de medi��o (tens�o) & \SI{' num2str(conv.Hv*1000) '}{\milli\V\per\V} \\'],13,10);
fprintf(fid, '%s%c%c', ['$R_s$ & Resist�ncia shunt & \SI{' num2str(conv.Rs) '}{\ohm} \\'],13,10);
fprintf(fid, '%s%c%c', ['$H_i$ & Ganho de medi��o (corrente) & \SI{' num2str(conv.Hi) '}{\A\per\A} \\'],13,10);
fprintf(fid, '%s%c%c', ['$V_C$ & Tens�o de controle  & \SI{' num2str(conv.VC) '}{\V} \\'],13,10);
fprintf(fid, '%s%c%c', ['$V_{CM}$ & Tens�o m�xima de controle  & \SI{' num2str(conv.VTM) '}{\V} \\'],13,10);
fprintf(fid, '%s%c%c', ['$V_{Cm}$ & Tens�o m�nima de controle  & \SI{' num2str(conv.VTm) '}{\V} \\'],13,10);
fprintf(fid, '%s%c%c', '\bottomrule',13,10);
fprintf(fid, '%s%c%c', '\end{tabular}',13,10);
fprintf(fid, '%s%c%c', '\end{table}',13,10);
fprintf(fid, '%s%c%c', '',13,10);
fclose(fid);

%% Modelo din�mico do conversor est�tico

%    [num,den] = tfdata(conv.vC0_d);
%    syms s
%    t_sym = poly2sym(cell2mat(num),s)/poly2sym(cell2mat(den),s)
% 
% l = latex(t_sym)

% PSIMCMD
if ~isfield(conv,'PSIMCMD')
    return
% if isfield(conv.PSIMCMD,'data')
    
end
%% Simula��o do Ponto de opera��o do conversor
if isfield(conv.PSIMCMD,'data.simview')
    filename=[conv.latex.tablesdir '\' conv.tipo '_steadystatesim.tex'];
    
    % call fprintf to print the updated text strings
    fid = fopen(filename,'w','n','UTF-8');
    if fid==-1
        disp('Erro ao abrir o arquivo para escrita do ponto de opera��o!')
        return
    end   
    fprintf(fid, '%s%c%c', '% Valores da simula��o do ponto de opera��o do conversor',13,10);
    fprintf(fid, '%s%c%c', '\begin{table}[!ht]',13,10);
    fprintf(fid, '%s%c%c', '\centering',13,10);
    fprintf(fid, '%s%c%c', ['\caption{Compara��o dos valores te�ricos e simulados para o ponto de opera��o do conversor ' conv.tipo ' referente ao registro acad�mico de n�mero $' num2str(conv.RA) '$}'],13,10);
    fprintf(fid, '%s%c%c', '\label{tab:steadystatesim}',13,10);
    fprintf(fid, '%s%c%c', '\begin{tabular}{@{}cccc@{}}',13,10);
    fprintf(fid, '%s%c%c', '\toprule',13,10);
    fprintf(fid, '%s%c%c', '\textbf{S�mbolo} & \textbf{Te�rico} & \textbf{Simulado} & \textbf{Descri��o}\\ \midrule',13,10);
    fprintf(fid, '%s%c%c', ['$I_{L_0}$ & \SI{' num2str(conv.IL0) '}{\A} & \SI{' num2str(conv.PSIMCMD.data.simview.screen1.curve0.ymean) '}{\A} & Corrente m�dia\\'],13,10);
    fprintf(fid, '%s%c%c', ['$\Delta{i_{L_0}}$  & \SI{' num2str(conv.DiL0*conv.IL0) '}{\A} & \SI{' num2str(conv.PSIMCMD.data.simview.screen1.curve0.ydelta) '}{\A}& Ondula��o de corrente\\'],13,10);
    fprintf(fid, '%s%c%c', ['$V_{C_0}$ & \SI{' num2str(conv.V0) '}{\V} & \SI{' num2str(conv.PSIMCMD.data.simview.screen0.curve0.ymean) '}{\V} & Tens�o m�dia\\'],13,10);
    fprintf(fid, '%s%c%c', ['$\Delta{v_{C_0}}$  & \SI{' num2str(conv.DvC0*conv.V0) '}{\V} & \SI{' num2str(conv.PSIMCMD.data.simview.screen0.curve0.ydelta) '}{\V}& Ondula��o de tens�o \\'],13,10);
    fprintf(fid, '%s%c%c', '\bottomrule',13,10);
    fprintf(fid, '%s%c%c', '\end{tabular}',13,10);
    fprintf(fid, '%s%c%c', '\end{table}',13,10);
    fprintf(fid, '%s%c%c', '',13,10);
    fclose(fid);    
end

