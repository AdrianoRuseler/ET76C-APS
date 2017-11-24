function conv = ra2convpar(RA)
conv.RA=RA; % Registro Acad�mico

conv.Vi = bitget(RA,3:-1:1)*[25; 50; 100]+50; % Tens�o de entrada
conv.V0 = bitget(RA,6:-1:4)*[50; 75; 100]+50; % Tens�o de sa�da
conv.P0 = bitget(RA,15:-1:13)*[500; 750; 250]+1000; % Pot�ncia do conversor
conv.fs = bitget(RA,12:-1:9)*[2.5e3; 5e3; 10e3;15e3]+10e3; % Frequ�ncia de comuta��o
conv.DiL0 = bitget(RA,8:-1:5)*[0.05; 0.1; 0.2;0.3]+0.1; % Ondula��o percentual de corrente
conv.DvC0 = bitget(RA,4:-1:1)*[0.005; 0.01; 0.02;0.03]+0.01; % Ondula��o percentual de tens�o

conv.R0=conv.V0^2/conv.P0; % Resist�ncia de carga
conv.I0=conv.P0/conv.V0; % Corrente de carga
conv.G=conv.V0/conv.Vi; % Ganho do conversor

conv.VTm=0; % Tens�o minima da portadora
conv.VTM=1; % Tens�o m�xima da portadora

conv.fci=2*pi*conv.fs/4; % Frequ�ncia de corte da malha de corrente
conv.fcv=2*pi*60; % Frequ�ncia de corte da malha de tens�o

conv.Dcnd=0.8;
% Decide qual topologia utilizar
if(conv.G>1.75)
    conv.tipo = 'Boost';
    conv.D = (conv.V0-conv.Vi)/conv.V0; % Raz�o c�clica do Boost em MCC
    conv.VC=conv.D*(conv.VTM-conv.VTm)+conv.VTm; % Tens�o de controle
    conv.IL0 = conv.I0/(1-conv.D);
    conv.L0 = (conv.V0-conv.Vi)*conv.Vi/(conv.DiL0*conv.I0*conv.V0*conv.fs);
    conv.C0 = (conv.I0*conv.D)/(conv.fs*conv.DvC0*conv.V0);
    % Modelo din�mico
    A=[0 (conv.D-1)/conv.L0;(1-conv.D)/conv.C0 -1/(conv.R0*conv.C0)];
    B=[1/conv.L0 conv.V0/conv.L0; 0 -conv.IL0/conv.C0];
    % Par�metros em MCD
    
elseif(conv.G<0.75)
    conv.tipo = 'Buck';
    conv.D = conv.V0/conv.Vi; % Raz�o c�clica do Buck em MCC
    conv.VC=conv.D*(conv.VTM-conv.VTm)+conv.VTm; % Tens�o de controle
    conv.IL0 = conv.I0;
    conv.L0 = (conv.Vi-conv.V0)*conv.V0/(conv.DiL0*conv.IL0*conv.Vi*conv.fs);
    conv.C0 = (conv.IL0*conv.DiL0)/(8*conv.fs*conv.DvC0*conv.V0);
    % Modelo din�mico
    A=[0 -1/conv.L0;1/conv.C0 -1/(conv.R0*conv.C0)];
    B=[conv.D/conv.L0 conv.Vi/conv.L0;0 0];
     % Par�metros em MCD
     
else
    conv.tipo = 'Buck-Boost';
    conv.D = conv.V0/(conv.V0+conv.Vi); % Raz�o c�clica do Buck-Boost em MCC
    conv.VC=conv.D*(conv.VTM-conv.VTm)+conv.VTm; % Tens�o de controle
    conv.IL0 = conv.I0/(1-conv.D);
    conv.L0 = (conv.Vi*conv.V0)/(conv.DiL0*conv.IL0*(conv.Vi+conv.V0)*conv.fs);
    conv.C0 = (conv.I0*conv.D)/(conv.fs*conv.DvC0*conv.V0);
    % Modelo din�mico
    A=[0 (conv.D-1)/conv.L0;(1-conv.D)/conv.C0 -1/(conv.R0*conv.C0)];
    B=[conv.D/conv.L0 (conv.V0+conv.Vi)/conv.L0; 0 -conv.IL0/conv.C0];
     % Par�metros em MCD
%     conv.D2=conv.I0*conv.Dcnd/conv.IL0; % Raz�o c�clica do diodo
%     conv.D1=conv.Dcnd-conv.D2; % Raz�o c�clica em MCD
%     conv.DiL0d=2*conv.IL0/conv.Dcnd; % Ondula��o de corrente em MCD
%     conv.L0d=conv.D1*conv.Vi/(conv.fs*conv.DiL0d); % Indut�ncia em MCD
end

%% Leitura de tens�o via divisor resistivo
E12=[10 12 15 18 22 27 33 39 47 56 68 82];
x=1;
for e1=1:length(E12)
    for e2=1:length(E12)
        g(x)=E12(e2)/(100*E12(e1)+E12(e2));
        indx{x}=[e1 e2];
        x=x+1;
    end
end

% Escolha do divisor de tens�o (Leitura)
Re= abs(conv.VC/conv.V0-g);
ind=find(Re==min(abs(Re))); % Menor erro
e=indx{ind};
conv.Ra=E12(e(1))*10000;
conv.Rb=E12(e(2))*100;
conv.Hv=conv.Rb/(conv.Ra+conv.Rb); % Ganho do condicionamento de tens�o
conv.Rs=0.1; % Resistor shunt para medi��o da corrente
conv.Hi=conv.Rs; % Ganho do condicionamento de corrente

 conv.param={'Ra','Rb','Hv','Hi','D','VC','L0','IL0','C0','V0','Vi','fs','R0','VTm','VTM','Kp','Ki',...
    'ST','R1pi','R2pi','C1pi','fa','a0z','a1z','b1z','b0z','Kp1','Ki1','Kp2','Ki2'};

%% Fun��es de transfer�ncia
D=[0 0];
C=[0 1]; % vC0
conv.sys = ss(A,B,C,D,'StateName',{'iL0' 'vC0'},...
    'InputName',{'Vin' 'd'});
[bsys,asys] = ss2tf(A,B,C,[0 0],2);
conv.vC0_d=tf(bsys,asys);

C=[1 0]; % iL0
[bsys,asys] = ss2tf(A,B,C,[0 0],2);
conv.iL0_d=tf(bsys,asys);

conv.vC0_iL0=minreal(conv.vC0_d/conv.iL0_d); % Encontra realiza��o minima

%% Estruturas para controle
conv.T1 = sisoinit(1);
conv.T1.G.Value = conv.vC0_d; % Planta da malha de tens�o
conv.T1.H.Value = tf(conv.Hv); % Ganho da leitura de tens�o

conv.T6 = sisoinit(6);

conv.T6.G1.Value = conv.iL0_d;  % Planta da malha de corrente
conv.T6.H1.Value = tf(conv.Hi); % Ganho da leitura de corrente
conv.T6.G2.Value = conv.vC0_iL0;  % Planta da malha de tens�o
conv.T6.H2.Value = tf(conv.Hv); % Ganho da leitura de tens�o

%% Verifica vers�o do MATLAB
conv.MATLAB.release=version('-release'); % Dependendo da vers�o, algumas fun��es podem n�o funcionar
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
conv.PSIMCMD.paramfile = [conv.basefilename '_data.txt']; % Arquivo com os par�metros de simula��o
conv.PSIMCMD.msgfile = [conv.simsdir  '\' conv.tipo  conv.prefixname  '_msg.txt'];
conv.PSIMCMD.inifile = [conv.simsdir  '\' conv.tipo  conv.prefixname  '.ini']; % Arquivo ini simview
conv.PSIMCMD.totaltime = 0.01;
conv.PSIMCMD.steptime = 1E-006;
conv.PSIMCMD.printtime = 0;
conv.PSIMCMD.printstep = 0;
conv.PSIMCMD.extracmd = '-g'; % -g :  Run Simview after the simulation is complete.
conv.PSIMCMD.status = 0; % Indica probelmas na simula��o 

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

%% Exporta tabela com par�metros do conversor

conv2tex(conv); % Exporta tabela com par�metros do conversor

%% Mostra par�metros do conversor
disp(conv) % Mostra par�metros do conversor

% conv.param






