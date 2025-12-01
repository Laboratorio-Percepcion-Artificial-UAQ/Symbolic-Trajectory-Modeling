%% %SequiturCopleto_modificado V1.
function [R,RE,reg]=OriSeqV1(cadenas)
[R,RE,reg]=RUtilEnf(cadenas);
end

%% Utilidad de regla 
%R-> Reglas
%RE-> Regla inicial
%reg->reglas mas frecuentes
function [R,RE,reg]=RUtilEnf(cadenas)
[R,RE]=G_s(cadenas);
%% encontrar los que se van a borrar y sus indices
if ~isempty(R)
reglas=R(:,1);
freq=[];
R=R(:,1:3);

for i=1:length(reglas)
    [f,c]=find(R==reglas(i));
    p=find(RE==reglas(i));
    freq(i)=length(p)+length(f)-1;
end
    freq=freq<2;
    Rdel=freq.*reglas';
    Rdel(Rdel==0)=[];
    indexR=Rdel-100000;
    Rtemp=R(:,2:end);
    
 %% Ver si uno de los q se van a borrar no usa a otro que se va a borrar y eliminar eso  
    
  % no es necesario porq lo hare recursivo entonces en la sigiuente vuelta
  % lo puede eliminar
  temporal=zeros(size(R,1),17);
  temporal=[R,temporal];
  eliminar1=[];
  
  while(~isempty(indexR))
      [f,c]=find(R==R(indexR(1),1));
      for i=1:length(f)
          if(c(i)~=1)
              z=[R(indexR(1),2:end)];
              nuevo=[R(f(i),1:c(i)-1),z,R(f(i),c(i)+1:end)];
              nuevo(nuevo==0)=[];
              
              while size(R,2)>length(nuevo)
                  nuevo=[nuevo 0];
              end
              
              while size(R,2)<length(nuevo)
                  R=[R,zeros(size(R,1),1)];
              end
              R(f(i),:)=nuevo;
          else
              eliminar1=[eliminar1,indexR(1)];
          end
      end
      indexR=indexR(2:end);
  end
  
while ~isempty(eliminar1)
    [f,c]=find(R==eliminar1(1)+100000);
    R(f,:)=[];
    
    p=find(RE==eliminar1(1)+100000);
    while(~isempty(p))
    RE(p(1))=[];
    p=p(2:end);
    end
    
    eliminar1=eliminar1(2:end);
end

%% frecuencia de las reglas en RE
reglas=R(:,1);
freq=[];
for i=1:length(reglas)
    [f,c]=find(R==reglas(i));
    p=find(RE==reglas(i));
    freq(i)=length(p)+length(f)-1;
end

%% maximas frecuencias
maximo=max(freq);
nfreq=double(freq)./maximo;
nfreq=nfreq>0.3;
sum(nfreq);

reg=reglas'.*nfreq;
reg(reg==0)=[];
reg2=freq.*nfreq;
reg2(reg2==0)=[];
reg(2,:)=reg2;
else
    reg=[];
end
end
 %100005          20          19          15
 
 %100007      100006           6
 %100006          14           9  
 
 %100014          45          43          41
 
 %100037      100036      100014  
 %100036      100035          46  
 %100035      100034          47           
 %100034          51          48           
      
 %100048      100015           9  
 %100015      100005          14 
 %100005          20          19          15
 
 %100050          31      100001
 %100001          29          26  
 
 %100055      100050          22 
 %100050          31      100001
 %100001          29          26

 %% mostrador de reglas aprendidas Falta esto!!!
 

 %% Codigo de sequitur 
 
 %% Leer simbolos y meter a SEQUITUR
function [R,RE]=G_s(trayectoria)
superS=trayectoria;
% for k=2:size(trayectoria,2)
%     superS=[superS,-1,trayectoria(k).s(:)'];  
% end
%for j=1:size(trayectoria,2)
    R=[];
    RE=[];
    cont=0;
    %s=trayectoria(j).s(:);
    for i=1:length(superS)
        [R,cont,RE]=SEQ5V2(superS(i),R,cont,RE);
    end
    if ~isempty(R)
    R=R(:,1:3);
    end
    %escritura(superS,R,RE,1); Con esta linea se escribe 

%end
end

%% Sequitur.>comparacion de regla y .>generacion de regla 

function [R,cont,RE]=SEQ5V2(E,R,cont,RE)

E=[RE,E];
%%%%%%%%%%%%%%%%%%%%% BIAS %%%%%%%%%%%%%%%%%%%%%%%%%%%
if length(E)<4
    R=R;
    E=E;
    RE=[E];
    cont=cont;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if length(E)>3
    sim=1;
        while sim == 1 && (length(E)>3)
            Ep=E;
            [ RE,R,cont ] = comR(E,cont,R,RE );
            E=RE;
            [ RE,cont,R ] = genR(E,cont,R);
            E=RE;
            if length(Ep)==length(E)
                sim=0;
            end
        end        

end
end

function [ RE,R,cont ] = comR( E,cont,R,RE )
    patron=[E(length(E)-1),E(length(E))];
    for k=1:cont
        prueba=R(k,2:size(R,2)-1);
        if patron(1)==prueba(1) && patron(2)== prueba(2)
            R(k,4)=R(k,4)+1;
            E(length(E)-1)=R(k,1);
            E(length(E))=[];
            RE=E;
            
        else
            RE=E;
        end
    end
if cont==0
RE=E;
end
RE(RE(:,:)==0)=[];

end

function [ RE,cont,R ]=genR( E,cont,R)
    if length(E)>3
        patron=[E(length(E)-1),E(length(E))];
        for i=1:1:length(E)-3   %cambie este indice de 2 por uno
            prueba=[E(i),E(i+1)];
            %%Candado para el skip
            if(isempty(find(patron==-1))&&isempty(find(prueba==-1))) %#ok<EFIND>
                if patron(1)==prueba(1) && patron(2)== prueba(2)&& E(i)~=0
                    cont=cont+1;
                    R(cont,:)=[100000+cont,patron,1];
                    E(length(E)-1)=100000+cont; %patron
                    E(length(E))=0;
                    E(i)=100000+cont;         %prueba
                    E(i+1)=0;
                    RE=E;
                    activacion=1;
                else
                    RE=E;
                end
            else
                RE=E;
            end
        end
    else
        RE=E;
    end
    RE(RE(:,:)==0)=[];
end

%% Escritura de informacion de reglas en .txt

function escritura(s,R,RE,cont)
name=sprintf('G%d.txt',cont);
fileID = fopen(name,'w');  %% NOMBRE DEL ARCHIVO Y PERMISO DE ESCRITURA 
fprintf(fileID,'%s\n','Cadena Original:');
fprintf(fileID,'%u ', s);
fprintf(fileID,'%s\n\n', '');
fprintf(fileID,'%s\n\n','Reglas de producción:');
fprintf(fileID,'%s ', 'Regla inicial-> ');
fprintf(fileID,'%d ', RE(:));
fprintf(fileID,'%s\n\n', '');
fprintf(fileID,'%s', 'Reglas: ');
fprintf(fileID,'%s\n\n', '');

    for i=1:size(R,1)    
        fprintf(fileID,'%u ', R(i,:));
        fprintf(fileID,'%u\n', '');

    end
fclose(fileID);
end
 
 
 