%% Limpa e verifica area de trabalho 
clear all % Limpa vari�veis de comando
clc % Limpa Command Window
try
    verificaambiente(); % Verifica se esta tudo OK!
catch
    warning('Altere o diret�rio de trabalho para a pasta contendo o arquivo APS.m!');
    disp(['Pasta atual: ' pwd])
    disp('Arquivos encontrados: ')
    ls
end

%% Identifica��o
clc
% RA=1234567; % Buck
% RA=1019252; % Coloque aqui o seu RA (Boost)
RA=1230067; % Buck-Boost

%% Obten��o dos par�metros do conversor
conv = ra2convpar(RA); % Converte o numero do RA em par�metros do conversor; 
winopen(conv.basedir) % Abre pasta contendo arquivos de simula��o

%% Simula��o do ponto de opera��o 

% Simule o conversor para verificar o ponto de opera��o
psimdata(conv) % Atualiza arquivo com os par�metros do convesor
winopen([conv.basefilename '.psimsch']) % Abre arquivo de simula��o

% Simule e exporte no formato .txt
% conv = psimread(conv); 
% conv = psimini2struct(conv);  % Importa configura��es do SIMVIEW

%% Simula��o via CMD
conv.prefixname='';  % Atualiza prefixo para nome do Arquivo de simula��o
conv.PSIMCMD.totaltime = 0.01; % Ajuste o tempo para atingir o regime permanente
conv.PSIMCMD.steptime = 1E-006;
conv.PSIMCMD.printtime = 0.008;
conv.PSIMCMD.printstep = 1;

conv = psimfromcmd(conv); % Simula via CMD e retorna dados obtidos

% Salve o arquivo *.ini via simview
conv = psimini2struct(conv);  % Importa configura��es do SIMVIEW

%% Simule o arquivo ACSweep para verificar a modelagem do cenversor
conv.prefixname='ACSweep'; 
winopen([conv.basefilename conv.prefixname '.psimsch']) % Abre arquivo de simula��o

% Simula��o via CMD
conv = psimfromcmd(conv); % Simula via CMD

%% Verifica��o das plantas

validarplanta(conv); % Compara modelos

%% Projeto do controlador

% Abra a feramenta de projeto do controlador
% Op��o 01
% controlSystemDesigner(conv.T1) 

% Op��o 02
% pidTuner(conv.vC0_d*conv.Hv,'pi') % Exporte com o nome Cv

% Op��o 03
[Cv,info] = pidtune(conv.vC0_d*conv.Hv,'PI',conv.fcv); % Autom�tico

%% Exporte o controlador PI projetado
conv.Cv=Cv; % Associe a estrutura 

% Obtenha os ganhos
[CNum CDen]=tfdata(Cv,'v'); 
conv.Kp = CNum(1); % Ganho proporcional
conv.Ki = CNum(2); % Ganho do integrador
 
conv = step2tex(conv); % Plota resposta ao degrau
conv.prefixname='1malha';
psimdata(conv) % Atualiza arquivo txt com os par�metros do conversor

%% Simule no PSIM para verificar a resposta

winopen([conv.basefilename conv.prefixname '.psimsch']) % Abre arquivo de simula��o

%% Simula��o via CMD

conv.PSIMCMD.totaltime = 3*conv.ST;
conv.PSIMCMD.steptime = 1E-006;
conv.PSIMCMD.printtime = conv.ST/2;
conv.PSIMCMD.printstep = 1;
conv.prefixname='1malha'; % Prefixo para nomear arquivos

conv = psimfromcmd(conv); % Simula via CMD

conv = psimini2struct(conv);  % Importa configura��es do SIMVIEW


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
conv.prefixname='1malhaAmpOp'; % Prefixo para nomear arquivos
winopen([conv.basefilename conv.prefixname '.psimsch']) % Abre arquivo de simula��o

conv.PSIMCMD.totaltime = 3*conv.ST;
conv.PSIMCMD.printtime = conv.ST/2;

conv = psimfromcmd(conv); % Simula via CMD e importa dados
conv = psimini2struct(conv);  % Importa configura��es do SIMVIEW


 
%% Discretiza��o do controlador
conv.fa=2*conv.fs; % Amostragem no dobro da frequ�ncia de comuta��o;
conv.Ta=1/conv.fa; 
 
% 'tustin' � Bilinear (Tustin) method.
conv.Cz=c2d(conv.Cv,conv.Ta,'tustin');


[CzNum, CzDen]=tfdata(conv.Cz,'v');

conv.a0z = CzDen(1); % 
conv.a1z = CzDen(2); %  
conv.b0z = CzNum(1); % 
conv.b1z = CzNum(2); % 

psimdata(conv) % Atualiza arquivo txt com os par�metros do conversor
conv.prefixname='1malhaDiscreto'; % Prefixo para nomear arquivos
winopen([conv.basefilename conv.prefixname '.psimsch']) % Abre arquivo de simula��o

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

 