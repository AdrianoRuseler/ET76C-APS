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

% Verifica se o diretório de trabalho está OK!
if ~ exist('APS.m')
    disp('Arquivo APS.m não encontrado!')
    disp('O diretório de trabalho deve conter o arquivo APS.m!')
else
    disp('Arquivo APS.m encontrado!')
end

% Verifica se é possivel executar o PSIM via CMD
[status,cmdout] = system('PsimCmd');
disp(cmdout)

if status % Verifica se é possivel executar o PSIM pelo prompt do DOS
    [PSIMexeFile,PSIMPath] = uigetfile('PsimCmd.exe','Diretório de instalação do PSIM!');
    if isequal(PSIMexeFile,0)
        disp('User selected Cancel')
        return
    end
    %     PSIMdir=[PSIMPath PSIMexeFile]; % Diretório de instalação do PSIM
    setenv('PATH', [getenv('PATH') [';' PSIMPath]]); % Coloca nas variáveis de ambiente o local do PSIM
    [status,cmdout] = system('PsimCmd');
    if status
       disp(cmdout)
    else
        disp('Arquivos PsimCmd.exe não encontrado!')
    end
end

% verificar se exixte a função contains
