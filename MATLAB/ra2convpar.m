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

conv.T1 = sisoinit(1);
conv.T1.G.Value = conv.vC0_d; % Planta da malha de tens�o
conv.T1.H.Value = tf(conv.Hv); % Ganho da leitura de tens�o

conv.T6 = sisoinit(6);

conv.T6.G1.Value = conv.iL0_d;  % Planta da malha de corrente
conv.T6.H1.Value = tf(conv.Hi); % Ganho da leitura de corrente
conv.T6.G2.Value = conv.vC0_iL0;  % Planta da malha de tens�o
conv.T6.H2.Value = tf(conv.Hv); % Ganho da leitura de tens�o

%% PSIM from CMD
conv.basedir=[ pwd '\' conv.tipo '\'];
conv.basefilename = [ conv.basedir conv.tipo ];
conv.fullfilename = [ conv.basedir conv.tipo ];
conv.PSIMCMD.infile = [ conv.basefilename '.psimsch'];
conv.PSIMCMD.outfile = [conv.basefilename '.txt'];
conv.PSIMCMD.msgfile = [conv.basefilename '_msg.txt'];
conv.PSIMCMD.inifile = [conv.basefilename '.ini']; % Arquivo ini simview
conv.PSIMCMD.totaltime = 0.01;
conv.PSIMCMD.steptime = 1E-006;
conv.PSIMCMD.printtime = 0;
conv.PSIMCMD.printstep = 0;
conv.PSIMCMD.extracmd = '-g'; % -g :  Run Simview after the simulation is complete.





