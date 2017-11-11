%% Limpa area de trabalho
clear all 
clc

%% Identifica��o
RA=1234567; % Buck
% RA=1019252; % Coloque aqui o seu RA (Boost)
% RA=1230067; % Buck-Boost

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
hfig=validarplanta(PSIMdata,conv); % Compara modelos

% Salva figuras
print(hfig(1),[conv.tipo '\' get(hfig(1),'Name')],'-depsc')
print(hfig(2),[conv.tipo '\' get(hfig(2),'Name')],'-depsc')


%% Projeto do controlador

% Abra a feramenta de projeto do controlador
controlSystemDesigner(conv.T1) % pidTuner(conv.vC0_d,'pi') 

%% Exporte o controlador PI projetado
conv.C=C; % Associe a estrutura 

% Obtenha os ganhos
[CNum CzDen]=tfdata(C,'v'); 
conv.Kp = CNum(1); % Ganho proporcional
conv.Ki = CNum(2); % Ganho do integrador
 
% Optem resposta ao degrau
conv.FTMA1 = feedback(conv.C*conv.vC0_d,conv.Hv);

hsfig=figure;
step(conv.FTMA1) % Obt�m resposta ao degrau
conv.Step = stepinfo(conv.FTMA1,'SettlingTimeThreshold',0.05,'RiseTimeLimits',[0.05,0.95]);
print(hsfig,[conv.tipo '\StepResponse1malha' ],'-depsc') % Salva resposta ao degrau

psimdata(conv,[conv.tipo '\' conv.tipo '_data.txt']) % Atualiza arquivo txt com os par�metros do conversor
% Simule no PSIM para verificar a resposta
winopen([conv.tipo '\' conv.tipo '1malha.psimsch']) % Abre arquivo de simula��o

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

hbfig=figure;
bode(conv.C,conv.CApmOp)
grid on
print(hbfig,[conv.tipo '\Bode1malhaAmpOp' ],'-depsc') % Salva compara��o Bode

% Optem resposta ao degrau
conv.FTMA1AmpOp = feedback(conv.CApmOp*conv.vC0_d,conv.Hv);

hsfig=figure;
step(conv.FTMA1,conv.FTMA1AmpOp) % Obt�m resposta ao degrau
grid on
print(hsfig,[conv.tipo '\StepResponse1malhaAmpOp' ],'-depsc') % Salva resposta ao degrau

conv.StepAmpOp = stepinfo(conv.FTMA1AmpOp,'SettlingTimeThreshold',0.05,'RiseTimeLimits',[0.05,0.95]);

psimdata(conv,[conv.tipo '\' conv.tipo '_data.txt']) % Atualiza arquivo txt com os par�metros do conversor
winopen([conv.tipo '\' conv.tipo '1malhaAmpOp.psimsch']) % Abre arquivo de simula��o
 
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
 

% Simula��o do controle em malha fechada
 
 psimdata(conv,[conv.tipo '\' conv.tipo '_data.txt']) % Atualiza arquivo txt
 
 % Simule no PSIM para verificar a resposta
winopen([conv.tipo '\' conv.tipo '2malhas.psimsch']) % Abre arquivo de simula��o

 