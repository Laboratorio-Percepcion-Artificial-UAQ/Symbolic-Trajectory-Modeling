function decoded_rules = decode_rules(R)
    % Create a structure of raw rules
    n = size(R, 1);
    rules_raw = struct('ID', {}, 'symbols', {});

    % Read all symbols from each rule (remove padding zeros)
    for i = 1:n
        rules_raw(i).ID = R(i,1);
        rules_raw(i).symbols = R(i,2:end);
        rules_raw(i).symbols(rules_raw(i).symbols == 0) = []; % remove zeros
    end

    % Decode each rule recursively
    decoded_rules = struct('ID', {}, 'cadena', {});

    for i = 1:n
        decoded_rules(i).ID = rules_raw(i).ID;
        decoded_rules(i).cadena = expand(rules_raw(i).ID, rules_raw);
    end
end

% Auxiliary recursive function
function output = expand(id, rules_raw)

    idx = find([rules_raw.ID] == id, 1);

    % Terminal symbol
    if isempty(idx)
        output = id;
        return;
    end

    symbols = rules_raw(idx).symbols;
    output = [];

    % Expand each symbol recursively
    for i = 1:length(symbols)
        if any([rules_raw.ID] == symbols(i))  % It is a subrule
            output = [output, expand(symbols(i), rules_raw)];
        else
            output = [output, symbols(i)];     % Terminal symbol
        end
    end
end
