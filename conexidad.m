function [imet_clean, n_new] = conexidad(imet, n, conn)
% CONEXIDAD: Elimina etiquetas no conexas en una imagen etiquetada.
%
% Entradas:
%   imet - Imagen etiquetada (matriz de enteros >= 0)
%   n    - Número de etiquetas
%   conn - Opcional: conectividad (4 u 8). Default = 8.
%
% Salidas:
%   imet_clean - Imagen con solo componentes conectados válidos
%   n_new      - Número de etiquetas después de limpiar

    if nargin < 3
        conn = 8;  % default
    end

    % Tamaño de la imagen
    [rows, cols] = size(imet);

    % Crear imagen binaria por etiqueta
    etiquetas_validas = false(1, n);

    for label = 1:n
        mask = (imet == label);

        if ~any(mask(:))
            continue; % no existe esta etiqueta
        end

        % Encuentra componentes conectados dentro de esta etiqueta
        CC = bwconncomp(mask, conn);

        % Si tiene más de un píxel conectados, es válido
        if CC.NumObjects > 0
            % Mantener solo la región más grande
            sizes = cellfun(@numel, CC.PixelIdxList);
            [~, idx_max] = max(sizes);

            % Crear máscara final por etiqueta
            new_mask = false(rows, cols);
            new_mask(CC.PixelIdxList{idx_max}) = true;

            % Guardar máscara depurada en la imagen final
            if label == 1
                im_final = zeros(rows, cols);
            end

            im_final(new_mask) = label;
            etiquetas_validas(label) = true;
        end
    end

    % Re-etiquetar consecutivamente
    [imet_clean, ~, new_ids] = unique(im_final);
    imet_clean = reshape(new_ids, rows, cols) - 1;

    % Nuevo número de etiquetas
    n_new = max(imet_clean(:));
end

