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

function conv = ra2convpar(RA)
conv.RA=RA; % Registro Acadêmico

conv.Vi = bitget(RA,3:-1:1)*[25; 50; 100]+50; % Tensão de entrada
conv.V0 = bitget(RA,6:-1:4)*[50; 75; 100]+50; % Tensão de saída
conv.P0 = bitget(RA,15:-1:13)*[500; 750; 250]+1000; % Potência do conversor
conv.fs = bitget(RA,12:-1:9)*[2.5e3; 5e3; 10e3;15e3]+10e3; % Frequência de comutação
conv.DiL0 = bitget(RA,8:-1:5)*[0.05; 0.1; 0.2;0.3]+0.1; % Ondulação percentual de corrente
conv.DvC0 = bitget(RA,4:-1:1)*[0.0005; 0.001; 0.002;0.003]+0.001; % Ondulação percentual de tensão

conv.R0=conv.V0^2/conv.P0; % Resistência de carga
conv.I0=conv.P0/conv.V0; % Corrente de carga
conv.G=conv.V0/conv.Vi; % Ganho do conversor

conv.VTm=0; % Tensão minima da portadora
conv.VTM=1; % Tensão máxima da portadora

conv.fa=2*conv.fs; % Amostragem no dobro da frequência de comutação;
conv.Ta=1/conv.fa; % Periodo de amostragem

conv.fci=2*pi*conv.fs/4; % Frequência de corte da malha de corrente
conv.fcv=4*pi*60/10; % Frequência de corte da malha de tensão

conv.Dcnd=0.8;
% Decide qual topologia utilizar
if(conv.G>1.75)
    conv.tipo = 'Boost';
    conv.D = (conv.V0-conv.Vi)/conv.V0; % Razão cíclica do Boost em MCC
    conv.VC=conv.D*(conv.VTM-conv.VTm)+conv.VTm; % Tensão de controle
    conv.IL0 = conv.I0/(1-conv.D);
    conv.L0 = (conv.V0-conv.Vi)*conv.Vi/(conv.DiL0*conv.IL0*conv.V0*conv.fs);
    conv.C0 = (conv.I0*conv.D)/(conv.fs*conv.DvC0*conv.V0);
    % Modelo dinâmico
    A=[0 (conv.D-1)/conv.L0;(1-conv.D)/conv.C0 -1/(conv.R0*conv.C0)];
    B=[1/conv.L0 conv.V0/conv.L0; 0 -conv.IL0/conv.C0];
    % Parâmetros em MCD
    
elseif(conv.G<0.75)
    conv.tipo = 'Buck';
    conv.D = conv.V0/conv.Vi; % Razão cíclica do Buck em MCC
    conv.VC=conv.D*(conv.VTM-conv.VTm)+conv.VTm; % Tensão de controle
    conv.IL0 = conv.I0;
    conv.L0 = (conv.Vi-conv.V0)*conv.V0/(conv.DiL0*conv.IL0*conv.Vi*conv.fs);
    conv.C0 = (conv.IL0*conv.DiL0)/(8*conv.fs*conv.DvC0*conv.V0);
    % Modelo dinâmico
    A=[0 -1/conv.L0;1/conv.C0 -1/(conv.R0*conv.C0)];
    B=[conv.D/conv.L0 conv.Vi/conv.L0;0 0];
     % Parâmetros em MCD
     
else
    conv.tipo = 'Buck-Boost';
    conv.D = conv.V0/(conv.V0+conv.Vi); % Razão cíclica do Buck-Boost em MCC
    conv.VC=conv.D*(conv.VTM-conv.VTm)+conv.VTm; % Tensão de controle
    conv.IL0 = conv.I0/(1-conv.D);
    conv.L0 = (conv.Vi*conv.V0)/(conv.DiL0*conv.IL0*(conv.Vi+conv.V0)*conv.fs);
    conv.C0 = (conv.I0*conv.D)/(conv.fs*conv.DvC0*conv.V0);
    % Modelo dinâmico
    A=[0 (conv.D-1)/conv.L0;(1-conv.D)/conv.C0 -1/(conv.R0*conv.C0)];
    B=[conv.D/conv.L0 (conv.V0+conv.Vi)/conv.L0; 0 -conv.IL0/conv.C0];
     % Parâmetros em MCD
%     conv.D2=conv.I0*conv.Dcnd/conv.IL0; % Razão cíclica do diodo
%     conv.D1=conv.Dcnd-conv.D2; % Razão cíclica em MCD
%     conv.DiL0d=2*conv.IL0/conv.Dcnd; % Ondulação de corrente em MCD
%     conv.L0d=conv.D1*conv.Vi/(conv.fs*conv.DiL0d); % Indutância em MCD
end

%% Leitura de tensão via divisor resistivo
E12=[10 12 15 18 22 27 33 39 47 56 68 82];
x=1;
for e1=1:length(E12)
    for e2=1:length(E12)
        g(x)=E12(e2)/(100*E12(e1)+E12(e2));
        indx{x}=[e1 e2];
        x=x+1;
    end
end

% Escolha do divisor de tensão (Leitura)
Re= abs(conv.VC/conv.V0-g);
ind=find(Re==min(abs(Re))); % Menor erro
e=indx{ind};
conv.Ra=E12(e(1))*10000;
conv.Rb=E12(e(2))*100;
conv.Hv=conv.Rb/(conv.Ra+conv.Rb); % Ganho do condicionamento de tensão
conv.Rs=0.1; % Resistor shunt para medição da corrente
conv.Hi=conv.Rs; % Ganho do condicionamento de corrente

 conv.param={'Ra','Rb','Hv','Hi','D','VC','L0','IL0','C0','V0','Vi','fs','R0','VTm','VTM','Kp','Ki',...
    'ST','R1pi','R2pi','C1pi','fa','a0z','a1z','b1z','b0z','Kp1','Ki1','Kp2','Ki2'};

%% Funções de transferência
D=[0 0];
C=[0 1]; % vC0
conv.sys = ss(A,B,C,D,'StateName',{'iL0' 'vC0'},...
    'InputName',{'Vin' 'd'});
[bsys,asys] = ss2tf(A,B,C,[0 0],2);
conv.vC0_d=tf(bsys,asys);

C=[1 0]; % iL0
[bsys,asys] = ss2tf(A,B,C,[0 0],2);
conv.iL0_d=tf(bsys,asys);

conv.vC0_iL0=minreal(conv.vC0_d/conv.iL0_d); % Encontra realização minima

%% Estruturas para controle
conv.T1 = sisoinit(1);
conv.T1.G.Value = conv.vC0_d; % Planta da malha de tensão
conv.T1.H.Value = tf(conv.Hv); % Ganho da leitura de tensão

conv.T6 = sisoinit(6);

conv.T6.G1.Value = conv.iL0_d;  % Planta da malha de corrente
conv.T6.H1.Value = tf(conv.Hi); % Ganho da leitura de corrente
conv.T6.G2.Value = conv.vC0_iL0;  % Planta da malha de tensão
conv.T6.H2.Value = tf(conv.Hv); % Ganho da leitura de tensão

%% Verifica versão do MATLAB
conv.MATLAB.release=version('-release'); % Dependendo da versão, algumas funções podem não funcionar
conv.MATLAB.version=version;
% verLessThan('matlab','8.4')

%% PSIM from CMD
conv.basedir=[ pwd '\' conv.tipo '\'];
conv.basefilename = [ conv.basedir conv.tipo ];
conv.prefixname= '';
conv.fullfilename = [ conv.basefilename  conv.prefixname];
conv.simsdir=[ conv.basedir 'Sims'];
conv.PSIMCMD.infile = [ conv.basefilename '.psimsch'];
conv.PSIMCMD.outfile = [conv.simsdir  '\' conv.tipo  conv.prefixname '.txt'];
conv.PSIMCMD.paramfile = [conv.basefilename '_data.txt']; % Arquivo com os parâmetros de simulação
conv.PSIMCMD.msgfile = [conv.simsdir  '\' conv.tipo  conv.prefixname  '_msg.txt'];
conv.PSIMCMD.inifile = [conv.simsdir  '\' conv.tipo  conv.prefixname  '.ini']; % Arquivo ini simview
conv.PSIMCMD.totaltime = 0.01;
conv.PSIMCMD.steptime = 1E-006;
conv.PSIMCMD.printtime = 0;
conv.PSIMCMD.printstep = 0;
conv.PSIMCMD.extracmd = '-g'; % -g :  Run Simview after the simulation is complete.
conv.PSIMCMD.status = 0; % Indica probelmas na simulação 

%% Latex dir

conv.latex.tablesdir = [ conv.basedir 'Tables'];
if ~exist(conv.latex.tablesdir,'dir')
    mkdir(conv.latex.tablesdir)
end
conv.latex.figsdir = [ conv.basedir 'Figs'];
if ~exist(conv.latex.figsdir,'dir')
    mkdir(conv.latex.figsdir)
end


if ~exist(conv.simsdir,'dir')
    mkdir(conv.simsdir)
end

%% Exporta tabela com parâmetros do conversor

conv2tex(conv); % Exporta tabela com parâmetros do conversor

%% Salva arquivo txt de dados
psimdata(conv); % Atualiza arquivo com os parâmetros do convesor

%% Mostra parâmetros do conversor
disp(conv) % Mostra parâmetros do conversor

% conv.param






