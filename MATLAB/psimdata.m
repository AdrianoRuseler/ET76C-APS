function psimdata(data,filename)
% % Rotina para exportar dados gerados no MATLAB
% % para serem lidos no Simulador PSIM
%
% % Exemplo:
% % Cria-se uma estrutura com as variáveis a serem exportadas:
% data.Vo=200;
% data.Vl=345;
% data.Ro=34;
% data.Lm=0.345e-3;
% % Basta agora passar a estrutura e o nome do arquivo para a funçao
% % psimdata
% psimdata(data,'filename.txt')
% 

if nargin < 1
    disp('')
    return;
end
if nargin < 2    
    [filename, pathname] = uiputfile({'*.txt;','PSIM Files (*.txt)'; ...
     '*.*','All files'}, 'Put an PSIM-file');
    if isequal(filename,0)
        disp('User selected Cancel')
            return
    end
    cd(pathname)
end

names = fieldnames(data);
% call fprintf to print the updated text strings
fid = fopen(filename,'w');
if fid==-1
    disp('Erro ao abrir o arquivo para escrita!')
    return
end

for ind=1:length(names)
    temp = getfield(data,names{ind});
    if isnumeric(temp) % Apenas imprime o que for numerico
        strdata=[char(names(ind)) ' = ' num2str(temp,'%10.8e')];
        fprintf(fid, '%s%c%c', strdata,13,10);
    end
end

fclose(fid);
winopen(filename) % Abre arquivo criado

