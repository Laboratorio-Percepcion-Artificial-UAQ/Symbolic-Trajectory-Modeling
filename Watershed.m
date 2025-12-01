function [vec,vid_a1]=Watershed(tac,Im)

    %tac=data2.Tray1_27;
    [Im_fil,Im_col]=size(tac);
    nueva=tac;
    nueva(nueva(:,:)>0)=1;
  
    %Crea un filtro alternado realizando una apertura y luego una cerradura
    alternado=nueva;
    se=strel('disk',2);
    for i=1:3
    apertura=imopen(alternado,se);
    alternado=imclose(apertura,se);
    end
  
    %Ajusta las regiones filtradas en la superficie de movimiento
    for j=1:Im_fil
    for i=1:Im_col
        if alternado(j,i) && tac(j,i)~=0
        n1(j,i)=tac(j,i);
        else
            n1(j,i)=0;
        end
        if alternado(j,i)~=0 && tac(j,i)==0
            n1(j,i)=0.5;
        end
    end
    end

     f=fspecial('gaussian',15,2.2);
     s=std(tac(:));
     nr=conv2(n1,f,'same');
     nr(nr<0.01*max(nr(:)))=inf;
 
     %nrr(nrr(:,:)<0.01*max(nrr(:)))=inf;
     %figure
     %imagesc(nr)
     nr=-nr;
     %normalizado de la imagen
    
     %im_norm=(nrr./mi)*255;
     n2=watershed(nr);
     w1=(n2>0);
     w1(nr==-inf)=0;
     se=strel('disk',1);
     w1op=imopen(w1,se);
   
     [MD,d]=bwlabel(w1op);

    %%criterio de vecindad >2
    vec=conexidad(MD,d);
   
    %vid_a1=vid;
    %%
    vid_a1=Im;
    for j=1:Im_fil
    for i=1:Im_col
        if vec(j,i,1)~=0
        vid_a1(j,i,1)=0;
        vid_a1(j,i,2)=255;
        %vid_a1(j,i)=255;
        vid_a1(j,i,3)=0;
        end
    end
    end
  
end