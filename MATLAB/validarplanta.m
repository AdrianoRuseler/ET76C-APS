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

function  [hfig haxes] = validarplanta(conv)

% conv.PSIMCMD.outfile = [conv.fullfilename '.fra'];
conv.PSIMCMD.outfile = [conv.simsdir  '\' conv.tipo  conv.prefixname '.fra'];

conv = psimread(conv); % Abra o arquivo .fra

if isfield(conv.PSIMCMD,'fra')
    PSIMdata.fra=conv.PSIMCMD.fra;
else
    return
end

estados=conv.sys.statename;
e=length(estados);

P = bodeoptions; % Set phase visiblity to off and frequency units to Hz in options
P.FreqUnits = 'Hz'; % Create plot with the options specified by P
Freq= PSIMdata.fra.freq;

%
hfig=figure;
% set(hfig,'Name',['Mag-' conv.tipo '-' PSIMdata.fra.signals(f).label ]) % Nome da figura
a=1;
for j=1:e
    k = strfind({PSIMdata.fra.signals.label},estados{j});
    for f=1:length({PSIMdata.fra.signals.label})
        if ~isempty(k{f})
            ind=f;
            break;
        end
        ind=0;
    end
    if ind==0
        disp('Estado não encontrado!')
        continue
    end
    
    Mag=PSIMdata.fra.signals(f).amp;
    Pha=PSIMdata.fra.signals(f).phase;
    
    sysC=zeros(1,e);
    sysC(j)=1;
    
    [bsys,asys] = ss2tf(conv.sys.A,conv.sys.B,sysC,conv.sys.D,2);
    sys_tf=tf(bsys,asys);
    
    
    [mag,phase] = bode(sys_tf,2*pi*Freq);
    magdb = 20*log10(mag(:)); % Pontos do modelo
    
    
    % subplot(2,3,j)

    subplot(2,2,j)
    title([conv.tipo '-' PSIMdata.fra.signals(f).label ])
    haxes(a)=gca;
    semilogx(Freq,Mag,'*') % Plota pontos do ACsweep
    hold all
    semilogx(Freq,magdb)
    hx=gca;
    hx.XTickLabel={};
    grid on
    axis tight
    title([conv.tipo ' - ' PSIMdata.fra.signals(f).label ' (RA:' num2str(conv.RA) ')'],'Interpreter','latex')   
    xlabel('')
    if j==1
        ylabel('Magnitude (dB)','Interpreter','latex')
    else
        ylabel('')
        legend({'ACsweep','Modelo'},'Interpreter','latex')
    end
%     legend({'ACsweep','Modelo'})
    
    fase=radtodeg(unwrap(degtorad(Pha),3*pi/2));
    a=a+1;
    subplot(2,2,j+2)
    haxes(a)=gca;
%     hfig(h)=figure;
%     set(hfig(h),'Name',['Fase-' conv.tipo '-' PSIMdata.fra.signals(f).label ]) % Nome da figura
    semilogx(Freq,Pha,'*')    
    
    hold all
    fase2=phase(:);
    dif=fase2(1)-fase(1);
    fase2=fase2(:)-dif;
    semilogx(Freq,fase2)
    grid on
    axis tight
    %     title([conv.tipo ' - ' PSIMdata.fra.signals(f).label ])
    title('')
    xlabel('Frequ\^encia (Hz)','Interpreter','latex')
    
    if j==1
        ylabel('Fase (deg)','Interpreter','latex')
    else
        ylabel('')        
    end
    
%     legend({'ACsweep','Modelo'})
    a=a+1;
end

% % Salva figura em formato .eps
% for i=1:h-1
     
% end

% get(haxes(4),'PlotBoxAspectRatio')
% get(haxes(1),'Position')
% 
% set(haxes(1),'OuterPosition',[0.0 0.5 0.5 0.5])
% set(haxes(2),'OuterPosition',[0.0 0.0 0.5 0.5])
% set(haxes(3),'OuterPosition',[0.5 0.5 0.5 0.5])
% set(haxes(4),'OuterPosition',[0.5 0.0 0.5 0.5])
% 
 set(haxes(1),'Position',[0.1 0.55 0.4 0.4])
 set(haxes(2),'Position',[0.1 0.15 0.4 0.4])
 set(haxes(3),'Position',[0.55 0.55 0.4 0.4])
 set(haxes(4),'Position',[0.55 0.15 0.4 0.4])
% 
% 
% set(haxes(1),'PlotBoxAspectRatio',[1 0.75 0.75])
% set(haxes(2),'PlotBoxAspectRatio',[1 0.75 0.75])
% set(haxes(3),'PlotBoxAspectRatio',[1 0.75 0.75])
% set(haxes(4),'PlotBoxAspectRatio',[1 0.75 0.75])

% get(haxes(1),'Position')
% get(haxes(1),'Position')
% get(haxes(2),'Position')
% get(haxes(3),'Position')
% get(haxes(4),'Position')

% get(hfig,'Position')

set(hfig,'Position',[1 1 850 500])
% get(hfig,'WindowStyle')
% set(hfig,'WindowStyle','normal')

% print(hfig,[conv.basefilename '-ValidacaoModelo' ],'-depsc')
       
print(hfig,[conv.latex.figsdir '\' conv.tipo conv.prefixname],'-depsc')    
    
%     set(haxes(1),'Title','Texto')
    



