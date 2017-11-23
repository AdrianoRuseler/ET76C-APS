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

function verificaambiente()

%% Verifica o diret�rio de trabalho
if ~ exist('APS.m','file')
    warning('Arquivo APS.m n�o encontrado!')
    warning('O diret�rio de trabalho deve conter o arquivo APS.m!')
    return
else
    disp('Arquivo APS.m encontrado!')
end

%% Verifica se � possivel executar o PSIM via CMD
[status,cmdout] = system('PsimCmd');
disp(cmdout)

if status % Verifica se � possivel executar o PSIM pelo prompt do DOS
    warning('Arquivos PsimCmd.exe n�o encontrado!')
    [PSIMexeFile,PSIMPath] = uigetfile('PsimCmd.exe','Diret�rio de instala��o do PSIM!');
    if isequal(PSIMexeFile,0)
        disp('User selected Cancel')
        return
    end
    %     PSIMdir=[PSIMPath PSIMexeFile]; % Diret�rio de instala��o do PSIM
    setenv('PATH', [getenv('PATH') [';' PSIMPath]]); % Coloca nas vari�veis de ambiente o local do PSIM
    [status,cmdout] = system('PsimCmd');
    if status
       disp(cmdout)
       return
    else
        disp('Arquivos PsimCmd.exe encontrado!')
        disp(cmdout)
    end
end

%% verificar depend�ncias dos m file

disp('Verificando arquivos e vers�o do MATLAB....')
[fList,pList] = matlab.codetools.requiredFilesAndProducts(which('APS'));
nf=0; % Number of not found m files
for e=1:length(fList)
    if exist(fList{e},'file')
        disp(['Encontrado: ' fList{e}])
    else
        warning(['N�o encontrado: ' fList{e}])
        nf=nf+1;
    end
end

if ~nf
    disp('Todos os arquivos est�o presentes!')
end

Nome={pList.Name};
Versao={pList.Version};
% ProductNumber={pList.ProductNumber};
% Utilizado={pList.Certain};

ver('MATLAB')
if verLessThan('MATLAB',Versao{1}) %
    warning(['Vers�o ' Versao{1} ' ou superior do pacote ' Nome{1} ' requerida!'])
else
    disp(['Vers�o ' Versao{1} ' ou superior do pacote ' Nome{1} ' encontrada!'])
end

ver('Control')
if verLessThan('Control',Versao{2}) %
    warning(['Vers�o ' Versao{2} ' ou superior do pacote ' Nome{2} ' requerida!'])
else
    disp(['Vers�o ' Versao{2} ' ou superior do pacote ' Nome{2} ' encontrada!'])
end


%% Verifica plataforma
if ismac
    % Code to run on Mac plaform
elseif isunix
    % Code to run on Linux plaform
elseif ispc
    % Code to run on Windows platform
%     [str,maxsize,endian] = computer
else
    disp('Plataforma n�o suportada!')
end



