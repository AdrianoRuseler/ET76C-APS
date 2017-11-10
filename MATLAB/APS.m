%% Limpa area de trabalho
clear all 
clc

%% Identifica��o
RA=1019252; % Coloque aqui o seu RA (Boost)
RA=1234567; % Buck
RA=1230067; % Buck-Boost

%% Obten��o dos par�metros do conversor
conv = ra2convpar(RA); % Converte o numero do RA em par�metros do conversor; 

psimdata(conv,[conv.tipo '\' conv.tipo '_data.txt']) % Exporta os par�metros do conversor
winopen(conv.tipo) % Abre pasta contendo arquivos de simula��o

%% Simula��o do ponto de opera��o 

% Simule o conversor para verificar o ponto de opera��o
winopen([conv.tipo '\' conv.tipo '.psimsch']) % Abre arquivo de simula��o

% Simule o arquivo ACSweep para verificar a modelagem do cenversor
winopen([conv.tipo '\' conv.tipo 'ACSweep.psimsch']) % Abre arquivo de simula��o

%% Verifica��o das plantas

PSIMdata = psimfra2matlab([conv.tipo '\' conv.tipo 'ACSweep.fra']); % Abra o arquivo .fra
validarplanta(PSIMdata,conv) % Compara modelos


%% Projeto do controlador

% Abra a feramenta de projeto do controlador
controlSystemDesigner(conv.T1) % pidTuner(conv.vC0_d,'pi') 

%% Exporte o controlador PI projetado
conv.C=C; % Associe a estrutura 

% Obtenha os ganhos
 [CNum CzDen]=tfdata(C,'v'); 
 conv.Kp = CNum(1); % Ganho proporcional
 conv.Ki = CNum(2); % Ganho do integrador
 
 psimdata(conv,[conv.tipo '\' conv.tipo '_data.txt']) % Atualiza arquivo txt com os par�metros do conversor
 
% Optem resposta ao degrau
conv.FTMA1 = feedback(conv.C*conv.vC0_d,1);

figure
step(conv.FTMA1) % Obt�m resposta ao degrau
conv.Step = stepinfo(conv.FTMA1,'SettlingTimeThreshold',0.05,'RiseTimeLimits',[0.05,0.95]);

% Simule no PSIM para verificar a resposta
winopen([conv.tipo '\' conv.tipo '1malha.psimsch']) % Abre arquivo de simula��o
 
%% Discretiza��o do controlador
conv.fa=2*conv.fs; % Amostragem no dobro da frequ�ncia de comuta��o;
conv.Ta=1/conv.fa; 
 
% 'tustin' � Bilinear (Tustin) method.
conv.Cz=c2d(conv.C,conv.Ta,'tustin');

% Compara controladores
figure
bode(conv.C,conv.Cz)

[CzNum, CzDen]=tfdata(conv.Cz,'v');

conv.a0z = CzDen(1); % 
conv.a1z = CzDen(2); %  
conv.b0z = CzNum(1); % 
conv.b1z = CzNum(2); % 
 
psimdata(conv,[conv.tipo '\' conv.tipo '_data.txt']) % Atualiza arquivo txt

% Simule no PSIM para verificar a resposta
winopen([conv.tipo '\' conv.tipo '1malhaDiscreto.psimsch']) % Abre arquivo de simula��o

%% Implementa��o em linguem C do controlador (DLL)

% Specify discrete transfer functions in DSP format
conv.CDLL=filt(CzNum,CzDen,conv.Ta);

% u(z)  5.303e-05 - 4.65e-05 z^-1
% ---- = -------------------------
% e(z)          1 - z^-1
          
% Simule no PSIM para verificar a resposta
winopen([conv.tipo '\' conv.tipo '1malhaDLL.psimsch']) % Abre arquivo de simula��o

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
 

 %% Simula��o do controle em malha fechada
 
 psimdata(conv,[conv.tipo '_data.txt']) % Atualiza arquivo txt com os par�metros do conversor
 
 % Simule no PSIM para verificar a resposta
winopen([conv.tipo '\' conv.tipo '2malhas.psimsch']) % Abre arquivo de simula��o

 