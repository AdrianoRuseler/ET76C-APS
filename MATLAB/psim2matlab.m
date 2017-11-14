% =========================================================================
% *** psim2matlab
% ***  
% *** This function converts PSIM simulated data to MATLAB data in struct
% *** format.
% *** Convert PSIM txt data to simulink struct data
% =========================================================================
% ***
% *** The MIT License (MIT)
% *** 
% *** Copyright (c) 2016 AdrianoRuseler
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

function PSIMdata = psim2matlab(PSIMtxt)

% Loads directory structure
try
    dirstruct = evalin('base', 'dirstruct'); % Load dirstruct from base workspace
catch
    [status, dirstruct]= checkdirstruct(); % Well, check this out
end

if nargin <1  % PSIMtxt not supplied
    if isfield(dirstruct,'simulatedir')
        if isequal(exist(dirstruct.simulatedir,'dir'),7)
            cd(dirstruct.simulatedir) % Change to directory with simutalad data
        end
    end
    [PSIMtxtFile, PSIMtxtPath] = uigetfile({'*.txt;*.fft;*.fra;*.csv;*.smv','PSIM Files (*.txt,*.fft,*.fra,*.csv,*.smv)'; ...
        '*.txt','PSIM - txt (*.txt)';'*.fft','FFT Data (*.fft)';'*.fra','AC-Sweed (*.fra)';'*.csv','PSIM Excel (*.csv)';...
        '*.*','All files'}, 'Pick an PSIM-file');
    if isequal(PSIMtxtFile,0)
        disp('User selected Cancel')
        PSIMdata =[]; % Return empty data
        return
    end
    PSIMtxt=[PSIMtxtPath PSIMtxtFile]; % Provide
else
    if ~isequal(exist(PSIMtxt,'file'),2) % If file NOT exists
        disp([PSIMtxt ' Not found!'])
        PSIMdata = psim2matlab(); % Load again
        return
    end
end

% PSIMtxt
[pathstr, name, ext] = fileparts(PSIMtxt);

switch ext % Make a simple check of file extensions
    case '.txt'
         % Good to go!!
    case '.csv' % Waiting for code implementation
        disp('Export PSIM data to a *.txt file.')
        cd(dirstruct.wdir)
        PSIMdata =[];
        return
    case '.fra' % Waiting for code implementation
        disp('Frequency analysis from PSIM.')        
        PSIMdata = psimfra2matlab(PSIMtxt);
        cd(dirstruct.wdir)
        return
    case '.fft' % Waiting for code implementation
        disp('fft analysis from PSIM. Really?')        
        disp('Please try: power_fftscope')
        PSIMdata = psimfft2matlab(PSIMtxt);
        cd(dirstruct.wdir)
        return
    case '.smv' % Waiting for code implementation
        disp('Wrong file extension. Convert the file to a *.txt file.')
        cd(dirstruct.wdir)
        PSIMdata =[];
        return
    otherwise
        disp('Save simview data as *.txt file.')
        cd(dirstruct.wdir)
        PSIMdata =[];
        return
end
    
dirstruct.simulatedir=pathstr; % Update simulations dir
    
%  Create folder under psimdir to store mat file
[s,mess,messid] = mkdir(dirstruct.psimdir, name); % Check here
dirstruct.psimstorage = [dirstruct.psimdir '\' name]; % Not sure


%%  Load file .txt
disp(['Reading ' name '.txt file....     Wait!'])
tic
cd(dirstruct.simulatedir)
[fileID,errmsg] = fopen(PSIMtxt);
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

 PSIMdata.time=M(:,1);
 PSIMdata.Ts=M(2,1)-M(1,1); % Time step
 
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
     PSIMdata.signals(i-1).label=U;
     PSIMdata.signals(i-1).values=M(:,i);
     PSIMdata.signals(i-1).dimensions=1;   
     PSIMdata.signals(i-1).title=U;
     PSIMdata.signals(i-1).plotStyle=[0,0];
 end
  
 PSIMdata.blockName=name;

 
PSIMdata.PSIMheader=header; % For non valid variables
disp('Done!!!!')
toc

disp('Saving data file....')
cd(dirstruct.psimstorage)
save([name '_data.mat'], 'PSIMdata') 

assignin('base','dirstruct',dirstruct);
cd(dirstruct.root)
save('dirstruct.mat','dirstruct')

cd(dirstruct.wdir)
disp('We are good to go!!!')

% winopen(dirstruct.psimstorage)

end

