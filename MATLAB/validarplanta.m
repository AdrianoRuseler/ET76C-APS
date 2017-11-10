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


function  validarplanta(PSIMdata,conv)

estados=conv.sys.statename;
e=length(estados);

P = bodeoptions; % Set phase visiblity to off and frequency units to Hz in options
P.FreqUnits = 'Hz'; % Create plot with the options specified by P
Freq= PSIMdata.fra.freq;

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
        disp('Estado n�o encontrado!')
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
    
    figure
    % subplot(2,3,j)
    subplot(2,1,1)
    semilogx(Freq,Mag,'*') % Plota pontos do ACsweep
    hold all
    semilogx(Freq,magdb)
    hx=gca;
    hx.XTickLabel={};
    grid on
    axis tight
    title([conv.tipo ' - ' PSIMdata.fra.signals(f).label ])
    xlabel('')
    ylabel('Magnitude (dB)')
    legend({'ACsweep','Model'})

    
    
    fase=radtodeg(unwrap(degtorad(Pha),3*pi/2));

    subplot(2,1,2)
    if flag
        semilogx(Freq,fase,'*')
    else
        semilogx(Freq,Pha,'*')
    end
    
    hold all
    fase2=phase(:);
    dif=fase2(1)-fase(1);
    fase2=fase2(:)-dif;
    semilogx(Freq,fase2)
    grid on
    axis tight
    title('')
    xlabel('Frequency (Hz)')
    ylabel('Phase (deg)')
    legend({'ACsweep','Model'})
end



