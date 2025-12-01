function reglas_sin_repetidas = eliminar_reglas_repetidas(reglas_decodificadas)
    n = length(reglas_decodificadas);
    cadenas_str = cell(1, n);

    % Convertir cada cadena a string para comparar
    for i = 1:n
        cadenas_str{i} = sprintf('%d,', reglas_decodificadas(i).cadena);
    end

    % Usar un conjunto para detectar duplicados
    [~, idx_unicos] = unique(cadenas_str, 'stable');

    % Conservar solo los índices únicos
    reglas_sin_repetidas = reglas_decodificadas(idx_unicos);
end
