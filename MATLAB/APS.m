%% Limpa e verifica area de trabalho 
clear all % Limpa variáveis de comando
clc % Limpa Command Window
try
    verificaambiente(); % Verifica se esta tudo OK!
catch
    warning('Altere o diretório de trabalho para a pasta contendo o arquivo APS.m!');
    disp(['Pasta atual: ' pwd])
    disp('Arquivos encontrados: ')
    ls
end

%% Identificação
clear all % Limpa variáveis de comando
clc% Limpa Command Window
close all % 

% RA=1234567; % Buck
 RA=1019252; % Coloque aqui o seu RA (Boost)
% RA=1438336; % Buck-Boost
% RA=1693832;

%% Obtenção dos parâmetros do conversor
conv = ra2convpar(RA); % Converte o numero do RA em parâmetros do conversor; 
winopen(conv.basedir) % Abre pasta contendo arquivos de simulação

%% Simulação do ponto de operação (Manual)
conv.prefixname='';  % Atualiza prefixo para nome do Arquivo de simulação
% Simule o conversor para verificar o ponto de operação
winopen([conv.basefilename '.psimsch']) % Abre arquivo de simulação
disp(['Salve a simulação com o nome: ' conv.tipo conv.prefixname '.txt'])

%% Importação dos dados simulados (Manual)
% Simule e exporte no formato *.txt (SIMVIEW)
% Exporte também as configurações *.ini (Settings->Save Settings)

conv = sim2matlab(conv);  % Importa configurações do SIMVIEW
conv2tex(conv); % Exporta tabelas de comparação

%% Simulação via CMD
conv.prefixname='';  % Atualiza prefixo para nome do Arquivo de simulação
conv.PSIMCMD.totaltime = 0.45; % Ajuste o tempo para atingir o regime permanente
conv.PSIMCMD.steptime = 1E-006;
conv.PSIMCMD.printtime = 0.44;
conv.PSIMCMD.printstep = 1;

conv = psimfromcmd(conv); % Simula via CMD e retorna dados obtidos

% Salve o arquivo *.ini via simview
conv = psimini2struct(conv);  % Importa configurações do SIMVIEW
conv2tex(conv); % Exporta tabelas de comparação

%% Simule o arquivo ACSweep para verificar a modelagem do cenversor
conv.prefixname='ACSweep'; 
winopen([conv.basefilename conv.prefixname '.psimsch']) % Abre arquivo de simulação
% Se simulado manualmente, save no formato *fra na pasta Sims
disp(['Salve a simulação com o nome: ' conv.tipo conv.prefixname '.fra'])

%% Simulação via CMD
conv = psimfromcmd(conv); % Simula via CMD

%% Verificação das plantas
% Se simulado manualmente, save no formato *fra na pasta Sims
validarplanta(conv); % Compara modelos

%% Projeto do controlador

% Abra a feramenta de projeto do controlador
% Opção 01
% controlSystemDesigner(conv.T1) 

% Opção 02
% pidTuner(conv.vC0_d*conv.Hv,'pi') % Exporte com o nome Cv

% Opção 03
[Cv,info] = pidtune(conv.vC0_d*conv.Hv,'PI',conv.fcv); % Automático

%% Exporte o controlador PI projetado
conv.Cv=Cv; % Associe a estrutura 

% Obtenha os ganhos
[CNum CDen]=tfdata(Cv,'v'); 
conv.Kp = CNum(1); % Ganho proporcional
conv.Ki = CNum(2); % Ganho do integrador
 
conv = step2tex(conv); % Plota resposta ao degrau
conv.prefixname='1malha';
psimdata(conv) % Atualiza arquivo txt com os parâmetros do conversor

%% Simule no PSIM para verificar a resposta

winopen([conv.basefilename conv.prefixname '.psimsch']) % Abre arquivo de simulação
disp(['Salve a simulação com o nome: ' conv.tipo conv.prefixname '.txt'])

%% Importação dos dados simulados (Manual)
% Simule e exporte no formato *.txt (SIMVIEW)
% Exporte também as configurações *.ini (Settings->Save Settings)
% conv.prefixname='1malha';  % Atualiza prefixo para nome do Arquivo de simulação
conv = sim2matlab(conv);  % Importa configurações do SIMVIEW

%% Simulação via CMD

conv.PSIMCMD.totaltime = 3*conv.ST;
conv.PSIMCMD.steptime = 1E-006;
conv.PSIMCMD.printtime = conv.ST/2;
conv.PSIMCMD.printstep = 1;
conv.prefixname='1malha'; % Prefixo para nomear arquivos

conv = psimfromcmd(conv); % Simula via CMD
conv = psimini2struct(conv);  % Importa configurações do SIMVIEW

%% Implementação analógica com AmpOp 

conv = PI2AmpOp(conv); % Essa função retorna a implementação analógica do PI
conv = step2tex(conv); % Obtem resposta ao degrau

psimdata(conv) % Atualiza arquivo txt com os parâmetros do conversor
conv.prefixname='1malhaAmpOp'; % Prefixo para nomear arquivos

%% Resposta ao degrau e simulação (Manual)
winopen([conv.basefilename conv.prefixname '.psimsch']) % Abre arquivo de simulação
disp(['Salve a simulação com o nome: ' conv.tipo conv.prefixname '.txt'])

%% Importação dos dados simulados (Manual)
% Simule e exporte no formato *.txt (SIMVIEW)
% Exporte também as configurações *.ini (Settings->Save Settings)
conv = sim2matlab(conv);  % Importa configurações do SIMVIEW

%% Simulação via CMD
conv.PSIMCMD.totaltime = 3*conv.ST;
conv.PSIMCMD.printtime = conv.ST/2;

conv = psimfromcmd(conv); % Simula via CMD e importa dados
conv = psimini2struct(conv);  % Importa configurações do SIMVIEW
 
%% Discretização do controlador

% 'tustin' — Bilinear (Tustin) method.
conv.Cz=c2d(conv.Cv,conv.Ta,'tustin');
[CzNum, CzDen]=tfdata(conv.Cz,'v');

conv.a0z = CzDen(1); % 
conv.a1z = CzDen(2); %  
conv.b0z = CzNum(1); % 
conv.b1z = CzNum(2); % 

conv = step2tex(conv); % Obtem resposta ao degrau
psimdata(conv) % Atualiza arquivo txt com os parâmetros do conversor

%% Simulação do controlador Digital (Manual)

conv.prefixname='1malhaDiscreto'; % Prefixo para nomear arquivos
winopen([conv.basefilename conv.prefixname '.psimsch']) % Abre arquivo de simulação
disp(['Salve a simulação com o nome: ' conv.tipo conv.prefixname '.txt'])

%% Importação dos dados simulados (Manual)
% Simule e exporte no formato *.txt (SIMVIEW)
% Exporte também as configurações *.ini (Settings->Save Settings)
conv = sim2matlab(conv);  % Importa configurações do SIMVIEW

%% Simulação via CMD
conv.prefixname='1malhaDiscreto';
conv.PSIMCMD.totaltime = 3*conv.ST;
conv.PSIMCMD.printtime = conv.ST/2;

conv = psimfromcmd(conv); % Simula via CMD e importa dados
%% Plota dados simulados
conv = psimini2struct(conv);  % Importa configurações do SIMVIEW

%% Implementação em linguem C do controlador (DLL)

% Specify discrete transfer functions in DSP format
conv.CDLL=filt(CzNum,CzDen,conv.Ta);

% u(z)  0.003797 + 0.003797 z^-1
% ---- = -------------------------
% e(z)          1 - z^-1

% Simule no PSIM para verificar a resposta
conv.prefixname='1malhaDLL'; % Prefixo para nomear arquivos
winopen([conv.basefilename conv.prefixname '.psimsch']) % Abre arquivo de simulação
disp(['Salve a simulação com o nome: ' conv.tipo conv.prefixname '.txt'])

%% Importação dos dados simulados (Manual)
% Simule e exporte no formato *.txt (SIMVIEW)
% Exporte também as configurações *.ini (Settings->Save Settings)
conv = sim2matlab(conv);  % Importa configurações do SIMVIEW

%% Simulação via CMD
conv.prefixname='1malhaDLL';
conv.PSIMCMD.totaltime = 3*conv.ST;
conv.PSIMCMD.printtime = conv.ST/2;

conv = psimfromcmd(conv); % Simula via CMD e importa dados
%% Plota dados simulados
conv = psimini2struct(conv);  % Importa configurações do SIMVIEW

 %% Projeto com duas malhas de controle
 
 % Abra a feramenta de projeto do controlador
% controlSystemDesigner(conv.T6) 
% Ci=C1; % Associe a estrutura 
% Cv=C2; % Associe a estrutura 

% Opção 02
% pidTuner(conv.iL0_d*conv.Hi,'PI') % Exporte com o nome Ci
% pidTuner(conv.vC0_iL0*conv.Hv,'PI') % Exporte com o nome Cv
    
% Opção 03
[Ci,C2iinfo] = pidtune(conv.iL0_d*conv.Hi,'PI',conv.fci); % Automático
[Cv,C2vinfo] = pidtune(conv.vC0_iL0*feedback(Ci*conv.iL0_d,conv.Hi)*conv.Hv,'PI',conv.fcv); % Automático

%% Exporte os controladores PI projetados
conv.C2i=Ci; % Associe a estrutura 
conv.C2v=Cv; % Associe a estrutura 

% Obtenha os ganhos
 [PInum PIden]=tfdata(Ci); 
 conv.Kp1 = PInum{1}(1); % Ganho proporcional
 conv.Ki1 = PInum{1}(2); % Ganho integral (contole corrente)
 [PInum PIden]=tfdata(Cv); 
 conv.Kp2 = PInum{1}(1); % Ganho proporcional
 conv.Ki2 = PInum{1}(2); % Ganho do integrador

conv = step2tex(conv); % Plota resposta ao degrau
conv.prefixname='2malhas';
psimdata(conv) % Atualiza arquivo txt com os parâmetros do conversor

%% Simulação do controle em malha fechada
winopen([conv.basefilename conv.prefixname '.psimsch']) % Abre arquivo de simulação
disp(['Salve a simulação com o nome: ' conv.tipo conv.prefixname '.txt'])

%% Importação dos dados simulados (Manual)
% Simule e exporte no formato *.txt (SIMVIEW)
% Exporte também as configurações *.ini (Settings->Save Settings)
conv = sim2matlab(conv);  % Importa configurações do SIMVIEW

%% Simulação via CMD
conv.prefixname='2malhas'; % Prefixo para nomear arquivos
conv.PSIMCMD.totaltime = 3*conv.ST;
conv.PSIMCMD.steptime = 1E-006;
conv.PSIMCMD.printtime = conv.ST/2;

conv = psimfromcmd(conv); % Simula via CMD e importa dados

%% Plota dados simulados
conv = psimini2struct(conv);  % Importa configurações do SIMVIEW

%% Limpa arquivos de simulação

limpasims(conv);  % Deleta arquivos de simulação (*.txt, *.smv e *.fra)

 