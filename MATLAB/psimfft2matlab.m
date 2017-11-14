
% =========================================================================
% *** psim2matlab
% ***  
% *** This function converts fft PSIM simulated data to MATLAB data 
% *** format.
% *** Convert PSIM txt data to simulink struct data
% =========================================================================
% ***
% *** The MIT License (MIT)
% *** 
% *** Copyright (c) 2015 AdrianoRuseler
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


function PSIMdata = psimfft2matlab(PSIMfft)

% Loads directory structure
try
    dirstruct = evalin('base', 'dirstruct'); % Load dirstruct from base workspace
catch
    [status, dirstruct]= checkdirstruct(); % Well, check this out
end

if nargin <1 % PSIMini not supplied
    if isfield(dirstruct,'simulatedir')
        if isequal(exist(dirstruct.simulatedir,'dir'),7)
            cd(dirstruct.simulatedir) % Change to directory with simutalad data
        end
    end
    [PSIMfftFile,PSIMfftPath] = uigetfile('*.fft','Select the PSIM fft file');
    if isequal(PSIMfftFile,0)
        disp('User selected Cancel')
        return
    end
 
        PSIMfft=[PSIMfftPath PSIMfftFile]; % Provide ini file
  
end

if ~isequal(exist(PSIMfft,'file'),2) % If file NOT exists
    disp([PSIMfft ' Not found!'])
    PSIMdata = psimfft2matlab(); % Load again without file location
    return
end


try
    disp('Load PSIMdata from base workspace!!')
    PSIMdata = evalin('base', 'PSIMdata'); % Load PSIMdata from base workspace    
catch
    disp('Load all mat files in this folder!!')
    % Load .mat file
    if isfield(dirstruct,'psimstorage')
        if isequal(exist(dirstruct.psimstorage,'dir'),7)
            cd(dirstruct.psimstorage) % Change to directory with PSIM data           
            infolder = what; %look in current directory
            matfiles=infolder.mat; % Get all mat files in this folder            
            for a=1:numel(matfiles) % Just loads all mfiles
                load(char(matfiles(a)));
            end                   
        end
    else        
        PSIMdata = psim2matlab();  % Ask for PSIM data file
        if isempty(PSIMdata) % If there is no data, just return
            return
        end
    end
end

if isempty(PSIMdata) % If there is no data, just return
    PSIMdata = psim2matlab();  % Ask for PSIM data file
    return
end

[pathstr, name, ext] = fileparts(PSIMfft);
switch ext % Make a simple check of file extensions
    case '.fft'
        % Good to go!!
    otherwise
        disp('Save simview Settings and load the *.fft file.')
        cd(dirstruct.wdir)
        return
end

% Make name valid in MATLAB
name = matlab.lang.makeValidName(name);
name = strrep(name, '_', ''); % Removes umderscore


%%  Load file .fft
disp('Reading fft file....     Wait!')
tic
cd(dirstruct.simulatedir)
[fileID,errmsg] = fopen(PSIMfft);
% [filename,permission,machinefmt,encodingOut] = fopen(fileID); 
if fileID==-1
    disp('File error!!')
    return
end

tline = fgetl(fileID); % ;; FFT Data from 5.005e-006 (s)	 to   0.167002 (s)
[fftinfo] = strread(tline,'%s','delimiter',' ');

PSIMdata.fft.StartTime=str2double(fftinfo{5});
PSIMdata.fft.EndTime=str2double(fftinfo{8});

theader = fgetl(fileID);
[header] = strread(theader,'%s','delimiter',' ');

fstr='%f';
 for tt=2:length(header)
    fstr=[fstr '%f']; 
 end

FFTdata = cell2mat(textscan(fileID,fstr));            
fclose(fileID);

% PSIMdata.fft.data=FFTdata;

PSIMdata.fft.Order=single(FFTdata(:,1));
PSIMdata.fft.freq=single(FFTdata(:,2));
 
 % Verifies header name
 for i=3:length(header)
     [U, modified] = matlab.lang.makeValidName(header{i});     
     if modified
         disp(['Name ' header{i} ' modified to ' U ' (MATLAB valid name for variables)!!'])
     end
     PSIMdata.fft.signals(i-2).label=U;
     PSIMdata.fft.signals(i-2).values=single(FFTdata(:,i));
     PSIMdata.fft.signals(i-2).dimensions=1;
     PSIMdata.fft.signals(i-2).title=strrep(U, '_', '');
 end
  
 
  
PSIMdata.fft.header=header; % For non valid variables
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

 
 
