%% Limpa area de trabalho
clear all 
clc

% Verifica se o diret�rio de trabalho est� OK!
if ~ exist('APS.m')
    disp('Arquivo APS.m n�o encontrado!')
    disp('O diret�rio de trabalho deve conter o arquivo APS.m!')
else
    disp('Arquivo APS.m encontrado!')
end

%% Identifica��o

RA=1234567; % Buck
%  RA=1019252; % Coloque aqui o seu RA (Boost)
% RA=1230067; % Buck-Boost

%% Obten��o dos par�metros do conversor
conv = ra2convpar(RA); % Converte o numero do RA em par�metros do conversor; 
conv2tex(conv) % Exporta tabela com par�metros do conversor
winopen(conv.basedir) % Abre pasta contendo arquivos de simula��o

%% Simula��o do ponto de opera��o 

% Simule o conversor para verificar o ponto de opera��o
psimdata(conv) % Atualiza arquivo com os par�metros do convesor
winopen([conv.basefilename '.psimsch']) % Abre arquivo de simula��o

% Simula��o via CMD
conv.prefixname='';  % Atualiza prefixo para nome do Arquivo de simula��o
conv.PSIMCMD.totaltime = 0.002;
conv.PSIMCMD.steptime = 1E-007;
conv.PSIMCMD.printtime = 0.001;
conv.PSIMCMD.printstep = 0;

conv = psimfromcmd(conv); % Simula via CMD e retorna dados obtidos

[status]=psim2plot(conv); % Plota resposta

%% Simule o arquivo ACSweep para verificar a modelagem do cenversor
conv.prefixname='ACSweep'; 
winopen([conv.basefilename conv.prefixname '.psimsch']) % Abre arquivo de simula��o

% Simula��o via CMD
conv = psimfromcmd(conv); % Simula via CMD

%% Verifica��o das plantas

 validarplanta(conv); % Compara modelos

%% Projeto do controlador

% Abra a feramenta de projeto do controlador
% controlSystemDesigner(conv.T1) 
% pidTuner(conv.vC0_d*conv.Hv,'pi') 

[C,info] = pidtune(conv.vC0_d*conv.Hv,'PI'); % Autom�tico

%% Exporte o controlador PI projetado
conv.C=C; % Associe a estrutura 

% Obtenha os ganhos
[CNum CzDen]=tfdata(C,'v'); 
conv.Kp = CNum(1); % Ganho proporcional
conv.Ki = CNum(2); % Ganho do integrador
 
conv = step2tex(conv); % Plota resposta ao degrau

psimdata(conv) % Atualiza arquivo txt com os par�metros do conversor

% Simule no PSIM para verificar a resposta
conv.prefixname='1malha'; 
winopen([conv.basefilename conv.prefixname '.psimsch']) % Abre arquivo de simula��o

%% Simula��o via CMD
conv.PSIMCMD.totaltime = 0.02;
conv.PSIMCMD.steptime = 1E-007;
conv.PSIMCMD.printtime = 0.005;
conv.PSIMCMD.printstep = 0;
conv.prefixname='1malha'; 

conv = psimfromcmd(conv); % Simula via CMD
[status]=psim2plot(conv); % Plota resposta


%% Implementa��o anal�gica com AmpOp
E12=[10 12 15 18 22 27 33 39 47 56 68 82];
x=1;
for e1=1:length(E12)
    for e2=1:length(E12)
        g(x)=E12(e2)/(E12(e1));
        indx{x}=[e1 e2];
        x=x+1;
    end      
end

Re= abs(conv.Kp*10000-g); % Ajustado manualmente
ind=find(Re==min(abs(Re))); % Menor erro 
e=indx{ind};
conv.R1pi=E12(e(1))*10000;
conv.R2pi=E12(e(2));

Kpf = conv.R2pi/conv.R1pi; % Ganho obtido

C1t=1/(conv.R1pi*conv.Ki);
C1base=10^(floor(log10(C1t)-1));

C1e= abs(C1t/C1base-E12);
ind=find(C1e==min(abs(C1e))); % Menor erro 
conv.C1pi=E12(ind)*C1base;

Kif=1/(conv.R1pi*conv.C1pi);

conv.CApmOp = pid(Kpf,Kif); % Verifica��o 

%% Resposta ao degrau e simula��o

conv = step2tex(conv);

psimdata(conv) % Atualiza arquivo txt com os par�metros do conversor
winopen([conv.fullfilename '.psimsch']) % Abre arquivo de simula��o
 
%% Discretiza��o do controlador
conv.fa=2*conv.fs; % Amostragem no dobro da frequ�ncia de comuta��o;
conv.Ta=1/conv.fa; 
 
% 'tustin' � Bilinear (Tustin) method.
conv.Cz=c2d(conv.C,conv.Ta,'tustin');


[CzNum, CzDen]=tfdata(conv.Cz,'v');

conv.a0z = CzDen(1); % 
conv.a1z = CzDen(2); %  
conv.b0z = CzNum(1); % 
conv.b1z = CzNum(2); % 
 
psimdata(conv) % Atualiza arquivo txt

% Simule no PSIM para verificar a resposta
winopen([conv.basefilename '1malhaDiscreto.psimsch']) % Abre arquivo de simula��o

%% Implementa��o em linguem C do controlador (DLL)

% Specify discrete transfer functions in DSP format
conv.CDLL=filt(CzNum,CzDen,conv.Ta);

% u(z)  5.303e-05 - 4.65e-05 z^-1
% ---- = -------------------------
% e(z)          1 - z^-1
          
% Simule no PSIM para verificar a resposta
winopen([conv.basefilename '1malhaDLL.psimsch']) % Abre arquivo de simula��o

 %% Projeto com duas malhas de controle
 
 % Abra a feramenta de projeto do controlador
controlSystemDesigner(conv.T6) 

%% Exporte os controladores PI projetados
conv.C1=C1; % Associe a estrutura 
conv.C2=C2; % Associe a estrutura 

% Obtenha os ganhos
 [PInum PIden]=tfdata(C1); 
 conv.Kp1 = PInum{1}(1); % Ganho proporcional
 conv.Ki1 = PInum{1}(2); % Ganho do integrador
 [PInum PIden]=tfdata(C2); 
 conv.Kp2 = PInum{1}(1); % Ganho proporcional
 conv.Ki2 = PInum{1}(2); % Ganho do integrador
 

% Simula��o do controle em malha fechada
 

 
 % Simule no PSIM para verificar a resposta
winopen([conv.basefilename '2malhas.psimsch']) % Abre arquivo de simula��o

 