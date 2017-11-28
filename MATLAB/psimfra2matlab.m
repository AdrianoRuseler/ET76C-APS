
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


function PSIMdata = psimfra2matlab(PSIMfra)

if nargin <1 % PSIMfra not supplied
    [PSIMfraFile,PSIMfraPath] = uigetfile('*.fra','Select the PSIM fft file');
    if isequal(PSIMfraFile,0)
        disp('User selected Cancel')
        PSIMdata=[];
        return
    end    
    PSIMfra=[PSIMfraPath PSIMfraFile]; % Provide ini file      
end

if ~isequal(exist(PSIMfra,'file'),2) % If file NOT exists
    disp([PSIMfra ' Not found!'])
    PSIMdata = psimfra2matlab(); % Load again without file location
    return
end


[pathstr, name, ext] = fileparts(PSIMfra);
switch ext % Make a simple check of file extensions
    case '.fra'
        % Good to go!!
    otherwise
        disp('Not a *.fra file.')
        PSIMdata=[];
        return
end

dirstruct.psimdir=pathstr; % Update simulations dir
dirstruct.pwd=pwd;     
% Make name valid in MATLAB
if verLessThan('matlab', '8.2.0')
    name = genvarname(name);
else
    name = matlab.lang.makeValidName(name);
end
name = strrep(name, '_', ''); % Removes umderscore


%%  Load file .fft
disp('Reading fra file....     Wait!')
tic
cd(dirstruct.psimdir)
[fileID,errmsg] = fopen(PSIMfra);
% [filename,permission,machinefmt,encodingOut] = fopen(fileID); 
if fileID==-1
    disp('File error!!')
    return
end

tline = fgetl(fileID); % Frequency amp(VarName) phase(VarName) ...
[fraheader] = strread(tline,'%s','delimiter',' ');
PSIMdata.fra.header=fraheader;

fstr='%f';
for tt=2:length(fraheader)
    fstr=[fstr '%f'];
end

FRAdata = cell2mat(textscan(fileID,fstr));
fclose(fileID);

PSIMdata.fra.freq=FRAdata(:,1);

 % Verifies header name
 j=1;
 for i=2:2:length(fraheader)-1
     varstr=fraheader{i};
     [startIndex,endIndex] = regexp(varstr,'\(\w+\)');     
     PSIMdata.fra.signals(j).label=varstr(startIndex+1:endIndex-1);
     PSIMdata.fra.signals(j).amp=single(FRAdata(:,i));
     PSIMdata.fra.signals(j).phase=single(FRAdata(:,i+1));
     PSIMdata.fra.signals(j).dimensions=1;   
     j=j+1;
 end
 

freq=PSIMdata.fra.freq;

for s=1:length(PSIMdata.fra.signals)
   mag= PSIMdata.fra.signals(s).amp;
   phase= PSIMdata.fra.signals(s).phase;      
   response = mag.*exp(1j*phase*pi/180);
   PSIMdata.fra.idfrd(s) = idfrd(response,freq,0);
   assignin('base',PSIMdata.fra.signals(s).label,PSIMdata.fra.idfrd(s));
end
 
  
PSIMdata.fra.name=name;
 
disp('Done!!!!')
toc

cd(dirstruct.pwd)

