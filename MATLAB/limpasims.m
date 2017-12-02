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

function limpasims(conv)
wdir=pwd;

cd(conv.basedir) % Diretório base
simfiles=dir('*.txt');
for f=1:length(simfiles)
    if ~isempty(simfiles)
        delete(simfiles(f).name)
        disp(['Arquivo: ' simfiles(f).name ' (' num2str(simfiles(f).bytes) ' Bytes) deletado!'])
    end
end

simfiles=dir('*.smv');
for f=1:length(simfiles)
    if ~isempty(simfiles)
        delete(simfiles(f).name)
        disp(['Arquivo: ' simfiles(f).name ' (' num2str(simfiles(f).bytes) ' Bytes) deletado!'])
    end
end

simfiles=dir('*.fra');
for f=1:length(simfiles)
    if ~isempty(simfiles)
        delete(simfiles(f).name)
        disp(['Arquivo: ' simfiles(f).name ' (' num2str(simfiles(f).bytes) ' Bytes) deletado!'])
    end
end

cd(conv.simsdir)
simfiles=dir('*.txt');
for f=1:length(simfiles)
    if ~isempty(simfiles)
        delete(simfiles(f).name)
        disp(['Arquivo: ' simfiles(f).name ' (' num2str(simfiles(f).bytes) ' Bytes) deletado!'])
    end
end

simfiles=dir('*.smv');
for f=1:length(simfiles)
    if ~isempty(simfiles)
        delete(simfiles(f).name)
        disp(['Arquivo: ' simfiles(f).name ' (' num2str(simfiles(f).bytes) ' Bytes) deletado!'])
    end
end

simfiles=dir('*.fra');
for f=1:length(simfiles)
    if ~isempty(simfiles)
        delete(simfiles(f).name)
        disp(['Arquivo: ' simfiles(f).name ' (' num2str(simfiles(f).bytes) ' Bytes) deletado!'])
    end
end

cd(wdir) % Diretório base