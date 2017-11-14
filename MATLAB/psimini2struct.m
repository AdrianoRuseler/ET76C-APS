% =========================================================================
% *** psimini2struct 
% *** Converts PSIM ini generated in Simview Settings to Struct data
% ***  
% ***  Returns PSIMdata with ini file struct

% *** PSIMdata = psimini2struct();
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

function PSIMdata = psimini2struct(PSIMini)

PSIMdata=[];
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
    [PSIMiniFile,PSIMiniPath] = uigetfile('*.ini','Select the PSIM ini file','MultiSelect', 'on');
    if isequal(PSIMiniFile,0)
        disp('User selected Cancel')
        return
    end
    % Check multi file selection
    if iscell(PSIMiniFile)
        for files=1:length(PSIMiniFile)
            PSIMini=[PSIMiniPath PSIMiniFile{files}]; % Provide ini file
            PSIMdata = psimini2struct(PSIMini);
        end
        return        
    else
        PSIMini=[PSIMiniPath PSIMiniFile]; % Provide ini file
    end
    
end

if ~isequal(exist(PSIMini,'file'),2) % If file NOT exists
    disp([PSIMini ' Not found!'])
    PSIMdata = psimini2struct(); % Load again
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

[pathstr, name, ext] = fileparts(PSIMini);
switch ext % Make a simple check of file extensions
    case '.ini'
        % Good to go!!
    otherwise
        disp('Save simview Settings and load the *.ini file.')
        cd(dirstruct.wdir)
        return
end

% Make name valid in MATLAB
name = matlab.lang.makeValidName(name);
name = strrep(name, '_', ''); % Removes umderscore





%% Read ini file

inistruct = ini2struct(PSIMini);  

% Creates the simview structure
simview.main.xaxis=inistruct.main.xaxis;
simview.main.numscreen=str2double(inistruct.main.numscreen);
simview.main.xfrom= str2double(inistruct.main.xfrom); % x limit
simview.main.xto= str2double(inistruct.main.xto);
simview.main.scale= str2double(inistruct.main.scale);
simview.main.xinc= str2double(inistruct.main.xinc);
simview.main.fft= logical(str2double(inistruct.main.fft));
simview.main.default= logical(str2double(inistruct.main.default));

simview.view.fontheight=str2double(inistruct.view.fontheight);
simview.view.bkcolor=str2double(inistruct.view.bkcolor);
simview.view.fontweight=str2double(inistruct.view.fontweight);
simview.view.grid=logical(str2double(inistruct.view.grid));
simview.view.fgcolor=str2double(inistruct.view.fgcolor);
simview.view.fontitalic=str2double(inistruct.view.fontitalic);
simview.view.gridcolor=str2double(inistruct.view.gridcolor);
simview.view.hideaxistext=logical(str2double(inistruct.view.hideaxistext));


for s=0:str2double(inistruct.main.numscreen)-1 % Screens Loop 
    eval(['simview.screen' num2str(s) '.scale=str2double(inistruct.screen' num2str(s) '.scale);'])
    eval(['simview.screen' num2str(s) '.yinc=str2double(inistruct.screen' num2str(s) '.yinc);'])
    eval(['simview.screen' num2str(s) '.default=logical(str2double(inistruct.screen' num2str(s) '.default));'])
    eval(['simview.screen' num2str(s) '.yfrom=str2double(inistruct.screen' num2str(s) '.yfrom);'])
    eval(['simview.screen' num2str(s) '.curvecount=str2double(inistruct.screen' num2str(s) '.curvecount);'])
    eval(['simview.screen' num2str(s) '.db=logical(str2double(inistruct.screen' num2str(s) '.db));'])
    eval(['simview.screen' num2str(s) '.auto=logical(str2double(inistruct.screen' num2str(s) '.auto));'])
    eval(['simview.screen' num2str(s) '.yto=str2double(inistruct.screen' num2str(s) '.yto);'])
    
    % Curves Loop
    for c=0:str2double(eval(['inistruct.screen' num2str(s) '.curvecount']))-1
        eval(['simview.screen' num2str(s) '.curve' num2str(c) '.formula=inistruct.screen' num2str(s) '.curve_'  num2str(c) '_formula;'])
        eval(['simview.screen' num2str(s) '.curve' num2str(c) '.label=inistruct.screen' num2str(s) '.curve_'  num2str(c) '_label;'])
        eval(['simview.screen' num2str(s) '.curve' num2str(c) '.symbol=str2double(inistruct.screen' num2str(s) '.curve_'  num2str(c) '_symbol);'])
        eval(['simview.screen' num2str(s) '.curve' num2str(c) '.source=str2double(inistruct.screen' num2str(s) '.curve_'  num2str(c) '_source);'])
        eval(['simview.screen' num2str(s) '.curve' num2str(c) '.connect=str2double(inistruct.screen' num2str(s) '.curve_'  num2str(c) '_connect);'])
        eval(['simview.screen' num2str(s) '.curve' num2str(c) '.thickness=str2double(inistruct.screen' num2str(s) '.curve_'  num2str(c) '_thickness);'])
        eval(['simview.screen' num2str(s) '.curve' num2str(c) '.color=str2double(inistruct.screen' num2str(s) '.curve_'  num2str(c) '_color);'])
    end     
end


%% Verifies PSIM variables to be compatible with MATLAB
xfrom = simview.main.xfrom;
xto = simview.main.xto;

xdata=PSIMdata.time(PSIMdata.time>=xfrom&PSIMdata.time<=xto);


for i=1:length(PSIMdata.signals)
   ydata = PSIMdata.signals(:,i).values(PSIMdata.time>=xfrom&PSIMdata.time<=xto);    
    assignin('base',PSIMdata.signals(i).label,ydata); % Not sure if this is the best way to do so;
end

% plot(xdata,ydata)
% Evaluate screen formula
for s=0:simview.main.numscreen-1 % Screens Loop
    for c=0:eval(['simview.screen' num2str(s) '.curvecount'])-1 % Curves Loop
        formula{s+1,c+1}= eval(['simview.screen' num2str(s) '.curve' num2str(c) '.formula']);
        [form, modified] = matlab.lang.makeValidName(formula{s+1,c+1},'ReplacementStyle','delete'); % Problem here for minus signal
        formuladata=evalin('base',form);
        
        eval(['simview.screen' num2str(s) '.curve' num2str(c) '.data=formuladata;'])
    end
end

% Clear variables from workspace
% disp('Clear variables from workspace:')
for i=1:length(PSIMdata.signals)
    evalin('base', ['clear ' PSIMdata.signals(i).label])     
%      disp([var{i} ' Clear!!'])
end

simview.main.xdata=xdata; % save time data (x axis data)

%% Save data struct
eval(['PSIMdata.simview.' name '=simview'])

disp('Saving data file....')
if isequal(exist(dirstruct.psimstorage,'dir'),7)
    cd(dirstruct.psimstorage)
else
    % Creates the directory
   folderOK = mkdir(dirstruct.psimstorage);
   if folderOK
       cd(dirstruct.psimstorage)
   else
       dirstruct.psimstorage=pwd;
   end
end

save([PSIMdata.blockName '_data.mat'], 'PSIMdata') 

assignin('base','PSIMdata',PSIMdata); % Updates base PSIMdata
assignin('base','dirstruct',dirstruct);% Updates dirstruct PSIMdata

cd(dirstruct.root)
save('dirstruct.mat','dirstruct')
cd(dirstruct.wdir)

disp('Done!!!!')





