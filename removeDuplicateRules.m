function rules_no_repeated = removeDuplicateRules(decoded_rules)
% ELIMINAR_REGLAS_REPETIDAS: Removes duplicated grammar production rules.
%
% Input:
%   decoded_rules - struct array where each element contains a field "cadena"
%                   representing a decoded production rule as a numeric vector.
%
% Output:
%   rules_no_repeated - struct array containing only unique rules 
%                       (duplicate sequences removed, order preserved)

    n = length(decoded_rules);
    rules_str = cell(1, n);

    % Convert each rule sequence into a comparable string
    for i = 1:n
        rules_str{i} = sprintf('%d,', decoded_rules(i).cadena);
    end

    % Detect unique sequences (preserves first occurrence)
    [~, unique_idx] = unique(rules_str, 'stable');

    % Keep only unique rules
    rules_no_repeated = decoded_rules(unique_idx);
end
