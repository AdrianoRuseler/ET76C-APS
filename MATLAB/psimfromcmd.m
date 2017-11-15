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


function  conv = psimfromcmd(conv)

% Copyright ® 2006-2017 Powersim Inc.  All Rights Reserved.
%
% Usage: PsimCmd.exe -i "[input file]" -o "[output file]" -v "VarName1=VarValue"  -v "VarName2=VarValue"  -g -K1 -L1 -t "TotalTime" -s "TimeStep" -pt "PrintTime" -ps "PrintStep" -Net "Netlist file name" -m "file name for errors"
%
%
% Except input file, all other parameters are optional.
% All file names should be enclosed by " or ' characters.
% Command-line parameters:
%   -i :  Followed by input schematic file.
%   -o :  Followed by output text (.txt) or binary (.smv) file.
%   -g :  Run Simview after the simulation is complete.
%   -t :  Followed by total time of the simulation.
%   -s :  Followed by time step of the simulation.
%   -pt : Followed by print time of the simulation.
%   -ps : Followed by print step of the simulation.
%   -v :  Followed by variable name and value. This parameter can be used multiple times.
%        example:  -v "R1=1.5"  -v "R2=5"
%   -m :  Followed by Text file for Error messages
%   -K  or -K1 :  Set 'Save flag' in Simulation control.
%   -K0 :  Remove 'Save flag' in Simulation control.
%   -L or -L1 :  Set 'Load flag' in Simulation control. Continue from previous simulation result.
%   -L0 :  Remove 'Load flag' in Simulation control. Starts simulation from beginning.
%   -Net : Generate netlist file. Simulation will not run. Followed by optional Netlist file name.
%   -c :  Followed by input netlist file.

[status,cmdout] = system('PsimCmd');

if status % Verifica se é possivel executar o PSIM pelo prompt do DOS
    disp(cmdout)
    [PSIMexeFile,PSIMPath] = uigetfile('PsimCmd.exe','Diretório de instalação do PSIM!');
    if isequal(PSIMexeFile,0)
        disp('User selected Cancel')
        return
    end
    %     PSIMdir=[PSIMPath PSIMexeFile]; % Diretório de instalação do PSIM
    setenv('PATH', [getenv('PATH') [';' PSIMPath]]); % Coloca nas variáveis de ambiente o local do PSIM
    %     [status,cmdout] = system('PsimCmd');
    %     disp(cmdout)
else
    %     [status,cmdout] = system('PsimCmd');
    %     disp(cmdout)
end

if nargin <1 % PsimCmdsrt not supplied  - Executa um exemplo
    [PSIMexeFile,PSIMPath] = uigetfile('PsimCmd.exe','Diretório de instalação do PSIM!');
    if isequal(PSIMexeFile,0)
        conv.PSIMCMD.status=1;
        conv.PSIMCMD.cmdout='Entre com os parâmetros do conversor!';
        return
    end
    conv.fullfilename = [PSIMPath 'examples\dc-dc\buck'];
    conv.PSIMCMD.totaltime = 0.02;
    conv.PSIMCMD.steptime = 1E-007;
    conv.PSIMCMD.printtime = 0;
    conv.PSIMCMD.printstep = 0;
    conv.PSIMCMD.extracmd = '-g';
else
    disp(conv.PSIMCMD) % Mostra parâmetros de simulação
end


% Cria string de comando
infile = ['"' conv.fullfilename '.psimsch"'];
outfile = ['"' conv.fullfilename '.txt"'];
msgfile = ['"' conv.fullfilename '_msg.txt"'];
totaltime = ['"' num2str(conv.PSIMCMD.totaltime) '"'];  %   -t :  Followed by total time of the simulation.
steptime = ['"' num2str(conv.PSIMCMD.steptime) '"']; %   -s :  Followed by time step of the simulation.
printtime = ['"' num2str(conv.PSIMCMD.printtime) '"']; %   -pt : Followed by print time of the simulation.
printstep = ['"' num2str(conv.PSIMCMD.printstep) '"']; %   -ps : Followed by print step of the simulation.

PsimCmdsrt= ['-i ' infile ' -o ' outfile ' -m ' msgfile ' -t ' totaltime ' -s ' steptime ' -pt ' printtime ' -ps ' printstep ' ' conv.PSIMCMD.extracmd];

tic
disp(PsimCmdsrt)
disp('Simulando conversor...')
[status,cmdout] = system(['PsimCmd ' PsimCmdsrt]); % Executa simulação
disp(cmdout)
conv.PSIMCMD.simtime=toc; % Tempo total de simulação
conv.PSIMCMD.status=status;
conv.PSIMCMD.cmdout=cmdout;

disp('Importando dados simulados do conversor...')
conv.PSIMCMD.data = psimread(conv.PSIMCMD.outfile);

conv.PSIMCMD.data = psimini2struct(conv.PSIMCMD.data,conv.PSIMCMD.inifile);


% conv.PSIMCMD.data.simview



disp(conv.PSIMCMD)





