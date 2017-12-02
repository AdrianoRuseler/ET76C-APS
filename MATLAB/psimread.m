% =========================================================================
% *** psimread
% ***  
% *** This function converts PSIM simulated data to MATLAB data in struct
% *** format.
% *** Convert PSIM txt data to simulink struct data
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

function conv = psimread(conv)

% conv.PSIMCMD.data = psimread(conv.PSIMCMD.outfile);  
conv.PSIMCMD.data=[]; % Limpa dados

if nargin <1  % conv not supplied
    conv.PSIMCMD.status=1;
    return
end

if ~isequal(exist(conv.PSIMCMD.outfile,'file'),2) % Verifica se existe o arquivo    
    conv.PSIMCMD.outfile = [conv.simsdir  '\' conv.tipo  conv.prefixname '.fra'];
elseif ~isequal(exist(conv.PSIMCMD.outfile,'file'),2) % Verifica se existe o arquivo
    disp([conv.PSIMCMD.outfile ' não encontrado!!!'])
    conv.PSIMCMD.status=1;
    return
end
        
% PSIMtxt
[pathstr, name, ext] = fileparts(conv.PSIMCMD.outfile);
dirstruct.wdir=pwd;

switch ext % Make a simple check of file extensions
    case '.txt'
        % Good to go!!
    case '.fra' % Waiting for code implementation
        disp('Frequency analysis from PSIM.')
        dataout = psimfra2matlab(conv.PSIMCMD.outfile);
        if isempty(dataout)
        else
            conv.PSIMCMD.fra=dataout.fra;
        end
        return
    otherwise
        disp('Save simview data as *.txt file.')
        conv.PSIMCMD.status=1;
        return
end

dirstruct.simulatedir=pathstr; % Update simulations dir
    
%  Create folder under psimdir to store mat file
% [s,mess,messid] = mkdir(dirstruct.psimdir, name); % Check here
% dirstruct.psimstorage = [dirstruct.psimdir '\' name]; % Not sure


%%  Load file .txt
disp(['Reading ' conv.PSIMCMD.outfile ' file....     Wait!'])
tic
cd(dirstruct.simulatedir)
[fileID,errmsg] = fopen(conv.PSIMCMD.outfile);
% [filename,permission,machinefmt,encodingOut] = fopen(fileID); 
if fileID==-1
    disp('File error!!')
    return
end

% BufSize -> Maximum string length in bytes -> 4095
tline = fgetl(fileID);
[header] = strread(tline,'%s','delimiter',' ');

fstr='%f';
for tt=2:length(header)
    fstr=[fstr '%f'];
end
 
M = cell2mat(textscan(fileID,fstr));            
fclose(fileID);

disp('Done!')

%% Convert data

 disp('Converting to simulink struct data ....')

 conv.PSIMCMD.data.time=M(:,1);
 conv.PSIMCMD.data.Ts=M(2,1)-M(1,1); % Time step
 
 % Verifies header name
 for i=2:length(header)
     if verLessThan('matlab', '8.2.0')
         U = genvarname(header{i});
         modified=1; % Just force update
     else
         [U, modified] = matlab.lang.makeValidName(header{i},'ReplacementStyle','delete');
     end
     if modified
         disp(['Name ' header{i} ' modified to ' U ' (MATLAB valid name for variables)!!'])
     end
     conv.PSIMCMD.data.signals(i-1).label=U;
     conv.PSIMCMD.data.signals(i-1).values=M(:,i);
     conv.PSIMCMD.data.signals(i-1).dimensions=1;   
     conv.PSIMCMD.data.signals(i-1).title=U;
     conv.PSIMCMD.data.signals(i-1).plotStyle=[0,0];
 end
  
 conv.PSIMCMD.data.blockName=name;

 
conv.PSIMCMD.data.PSIMheader=header; % For non valid variables

disp('Done!!!!')
toc


cd(dirstruct.wdir)
% disp('We are good to go!!!')


end

