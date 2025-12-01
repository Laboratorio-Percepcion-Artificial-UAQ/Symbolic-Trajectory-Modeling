function Tray_simbolos = convertirTrayectoriasAsimbolos(Tray, vec)
% =========================================================================
% CONVIERTE TRAYECTORIAS (i,j,frame) A SOLO CADENAS DE SIMBOLOS
%
% Entradas:
%       Tray(id) = [i j frame]
%       vec = matriz de estados segmentados
%
% Salida:
%       Tray_simbolos.Tray_id = [s1 s2 s3 ... sN]
%
% Solo símbolos. No devuelve frames.
%
% Compatible con MATLAB 2015
% =========================================================================

Tray_simbolos = struct();
keys_tray = keys(Tray);

for k = 1:length(keys_tray)

    id = keys_tray{k};
    datos = Tray(id);     % columnas: [i j frame]

    X = datos(:,1) + 1;   % corrección de indexación
    Y = datos(:,2) + 1;

    simbolos = [];

    for p = 1:length(X)
        
        if X(p) >= 1 && X(p) <= size(vec,1) && ...
           Y(p) >= 1 && Y(p) <= size(vec,2)

            estado = vec(X(p),Y(p));

            if estado ~= 0
                simbolos(end+1) = estado; %#ok<AGROW>
            end
        end
    end

    % Solo guardar trayectorias válidas
    if ~isempty(simbolos)
        Tray_simbolos.(sprintf('Tray_%d', id)) = simbolos;
    end
end

end
