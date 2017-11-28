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

function psimdata(conv)

if nargin < 1
    disp('Dados do conversor não foram fornecidos!')
    return
end

% names = fieldnames(conv);
% call fprintf to print the updated text strings
fid = fopen(conv.PSIMCMD.paramfile,'w');
if fid==-1
    disp('Erro ao abrir o arquivo para escrita!')
    return
end

for ind=1:length(conv.param)    
    if isfield(conv,conv.param{ind}) % Apenas imprime o que for numerico
        strdata=[char(conv.param(ind)) ' = ' num2str(getfield(conv,conv.param{ind}),'%10.8e')];
        fprintf(fid, '%s%c%c', strdata,13,10);
    end
end
fclose(fid);

disp('Exporte os dados simulados no diretório:')
disp(conv.PSIMCMD.outfile)

% winopen(conv.PSIMCMD.paramfile ) % Abre arquivo criado

