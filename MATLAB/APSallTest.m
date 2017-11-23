% APS-All
clear all
clc

RA=[1582208
1719238
1722697
1721526
1438336
849561
951404
1247387
1721577
1719297
1365509
1301470
1062468
1693832
1492640
1442520
1305506
946206
1719203
1722689
1044664
1168932
1721534
1587722
1559095
1300067
1719289
1367390
1719335
1016113];
RA = sort(RA); % Ordena RA

%% Gera parâmetros dos conversores
for r=1:length(RA)
    conv(r) = ra2convpar(RA(r));
    conv(r).PSIMCMD.totaltime = 0.01; % Ajuste o tempo para atingir o regime permanente
    conv(r).PSIMCMD.steptime = 1E-006;
    conv(r).PSIMCMD.printtime = 0.009;
    conv(r).PSIMCMD.printstep = 1;
end

param={'Ra','Rb','Hv','Hi','D','VC','L0','IL0','C0','V0','Vi','fs','R0','VTm','VTM','Kp','Ki',...
    'ST','R1pi','R2pi','C1pi','fa','Ta','a0z','a1z','b1z','b0z'};

%% Simulação em massa

for r=1:length(RA)
    conv(r).PSIMCMD.varcmd='';    
    for ind=1:length(param)
        if isfield(conv(r),param{ind}) % Apenas imprime o que for numerico
            strdata=[char(param(ind)) '=' num2str(getfield(conv(r),param{ind}),'%10.2e')];
            conv(r).PSIMCMD.varcmd=[conv(r).PSIMCMD.varcmd '-v "' strdata '" '];
        end
    end
    conv(r).prefixname='All';    
    conv(r).fullfilename = [ conv(r).basefilename  conv(r).prefixname]; % Atualiza nome do arquivo
    conv(r).PSIMCMD.infile = [ conv(r).fullfilename '.psimsch'];
    conv(r).PSIMCMD.outfile = [conv(r).fullfilename '.txt'];
    conv(r).PSIMCMD.msgfile = [conv(r).fullfilename '_msg.txt'];
    conv(r).PSIMCMD.inifile = [conv(r).fullfilename '.ini']; % Arquivo ini simview
    
    % Cria string de comando
    infile = ['"' conv(r).PSIMCMD.infile '"'];
    outfile = ['"' conv(r).PSIMCMD.outfile '"'];
    msgfile = ['"' conv(r).PSIMCMD.msgfile '"'];
    totaltime = ['"' num2str(conv(r).PSIMCMD.totaltime) '"'];  %   -t :  Followed by total time of the simulation.
    steptime = ['"' num2str(conv(r).PSIMCMD.steptime) '"']; %   -s :  Followed by time step of the simulation.
    printtime = ['"' num2str(conv(r).PSIMCMD.printtime) '"']; %   -pt : Followed by print time of the simulation.
    printstep = ['"' num2str(conv(r).PSIMCMD.printstep) '"']; %   -ps : Followed by print step of the simulation.
    
    PsimCmdsrt= ['-i ' infile ' -o ' outfile ' -m ' msgfile ' -t ' totaltime ' -s ' steptime ' -pt ' printtime ' -ps ' printstep ' ' conv(r).PSIMCMD.extracmd ' ' conv(r).PSIMCMD.varcmd];
   
    tic
    disp(PsimCmdsrt)
    disp('Simulando conversor...')
    [status,cmdout] = system(['PsimCmd ' PsimCmdsrt]); % Executa simulação
    disp(cmdout)    
    conv(r) = psimread(conv(r)); % Importa pontos simulados    
end


%% Imprime Resultado

for r=1:length(RA)
    conv(r) = psimini2struct(conv(r));  % Importa configurações do SIMVIEW
end



