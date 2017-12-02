
% =========================================================================
%
%  The MIT License (MIT)
%
%  Copyright (c) 2017 AdrianoRuseler
%
%  Permission is hereby granted, free of charge, to any person obtaining a copy
%  of this software and associated documentation files (the Software), to deal
%  in the Software without restriction, including without limitation the rights
%  to use, copy, modify, merge, publish, distribute, sublicense, andor sell
%  copies of the Software, and to permit persons to whom the Software is
%  furnished to do so, subject to the following conditions
%
%  The above copyright notice and this permission notice shall be included in all
%  copies or substantial portions of the Software.
%
%  THE SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
%  SOFTWARE.
%
% =========================================================================
% TODO: Ajustar limites xlime ylim

function [status]=psim2plot(conv)

status=0; % We have to return something

if nargin <1 % input file not supplied
    % Try to Load SCOPEdata structure
    status =1;
    return
end

%% All data must be available here:

if ~isfield(conv.PSIMCMD,'data')
    disp('Sem dados de simulação!')
    status=1;
    return
else
    PSIMdata=conv.PSIMCMD.data;
end

if isempty(conv.PSIMCMD.data)
    disp('Sem dados de simulação!')
    status=1;
    return
end

PSIMdata.simview.main.hfig=figure; % Create fig handle
% title(['RA: ' num2str(conv.RA)])

xdata=PSIMdata.simview.main.xdata*1e3;

for s=0:PSIMdata.simview.main.numscreen-1
    haxes = subplot(PSIMdata.simview.main.numscreen,1,s+1); % Gera subplot
    hold(haxes,'all')
    grid on
    eval(['PSIMdata.simview.screen' num2str(s) '.handle=haxes;']) % atribue handle
    legString={};
    for c=0:eval(['PSIMdata.simview.screen' num2str(s) '.curvecount'])-1 % Curves Loop
        %         disp('Plots!!')
        ydata = eval(['PSIMdata.simview.screen' num2str(s) '.curve' num2str(c) '.data']);
        legString{c+1} = eval(['PSIMdata.simview.screen' num2str(s) '.curve' num2str(c) '.label']);
        plot(haxes,xdata,ydata)
    end
    %     axis tight
    %     xlim(haxes,[conv.PSIMCMD.printtime conv.PSIMCMD.totaltime]*1e3); % Aqui está o problema
    xlim(haxes,[xdata(1) xdata(end)]);
    legend(haxes,legString,'Interpreter','latex');
    if ~s==PSIMdata.simview.main.numscreen-1
        set(haxes,'XTickLabel',[])
        title(['RA: ' num2str(conv.RA)],'Interpreter','latex')
    end
end

xlabel('Tempo (ms)','Interpreter','latex')



ylabel(PSIMdata.simview.screen0.handle,'Tens\~ao de sa\''ida (V)','Interpreter','latex')
ylabel(PSIMdata.simview.screen1.handle,'Corrente no indutor (A)','Interpreter','latex')

linkaxes([PSIMdata.simview.screen0.handle PSIMdata.simview.screen1.handle],'x') % Linka eixos x
% get(PSIMdata.simview.main.hfig,'Position')
% get(PSIMdata.simview.screen1.handle,'Position')

 set(PSIMdata.simview.screen0.handle,'Position',[0.15 0.55 0.75 0.4]);
 set(PSIMdata.simview.screen1.handle,'Position',[0.15 0.1 0.75 0.4]);
 
 
 print(PSIMdata.simview.main.hfig,[conv.latex.figsdir '\' conv.tipo conv.prefixname],'-depsc') % Exporta figura no formato .eps

 %% Exporta tabela com dados de simulação
 
 
 
 
 
 

