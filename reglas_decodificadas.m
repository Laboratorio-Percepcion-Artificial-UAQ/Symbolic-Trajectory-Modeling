function reglas_deco = reglas_decodificadas(R)
    % Crear una estructura de reglas
    n = size(R, 1);
    reglas = struct('ID', {}, 'simbolos', {});

    % Leer todos los símbolos de cada regla (más de 2 si es necesario)
    for i = 1:n
        reglas(i).ID = R(i,1);
        % Quitar ceros (relleno)
        reglas(i).simbolos = R(i,2:end);
        reglas(i).simbolos(reglas(i).simbolos == 0) = [];
    end

    % Decodificar cada regla recursivamente
    reglas_deco = struct('ID', {}, 'cadena', {});

    for i = 1:n
        reglas_deco(i).ID = reglas(i).ID;
        reglas_deco(i).cadena = expandir(reglas(i).ID, reglas);
    end
end

% Función auxiliar recursiva
function salida = expandir(id, reglas)
    idx = find([reglas.ID] == id, 1);

    if isempty(idx)
        salida = id; % Es símbolo terminal
        return;
    end

    simbolos = reglas(idx).simbolos;
    salida = [];

    for i = 1:length(simbolos)
        if any([reglas.ID] == simbolos(i)) % Es una subregla
            salida = [salida, expandir(simbolos(i), reglas)];
        else
            salida = [salida, simbolos(i)]; % Es terminal
        end
    end
end
