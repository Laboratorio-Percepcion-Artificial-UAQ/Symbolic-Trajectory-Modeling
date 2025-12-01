%% SequiturComplete_modified V1.
function [R,RE,reg] = OriSeqV1(sequences)
    [R,RE,reg] = RUtilEnf(sequences);
end

%% Rule utility
% R  -> Rules
% RE -> Initial rule (start rule)
% reg -> Most frequent rules
function [R,RE,reg] = RUtilEnf(sequences)

    [R,RE] = G_s(sequences);

    %% Find rules to be removed and their indices
    if ~isempty(R)
        rule_ids = R(:,1);
        freq = [];
        R = R(:,1:3);

        for i = 1:length(rule_ids)
            [f,~] = find(R == rule_ids(i));
            p = find(RE == rule_ids(i));
            freq(i) = length(p) + length(f) - 1;
        end

        % Rules with frequency < 2 are candidates to be removed
        freq_mask = freq < 2;
        rules_to_delete = freq_mask .* rule_ids';
        rules_to_delete(rules_to_delete == 0) = [];
        rules_idx = rules_to_delete - 100000;

        Rtemp = R(:,2:end); %#ok<NASGU>

        %% Check if a rule to be deleted is used by another deletable rule
        % (not strictly needed because recursion will clean them on the
        % next pass, but this part keeps the logic explicit)
        temp_matrix = zeros(size(R,1),17); %#ok<NASGU>
        temp_matrix = [R, temp_matrix];    %#ok<NASGU>
        to_remove_from_R = [];

        while ~isempty(rules_idx)
            [f,c] = find(R == R(rules_idx(1),1));
            for i = 1:length(f)
                if c(i) ~= 1
                    z = R(rules_idx(1),2:end);
                    new_rule = [R(f(i),1:c(i)-1), z, R(f(i),c(i)+1:end)];
                    new_rule(new_rule == 0) = [];

                    while size(R,2) > length(new_rule)
                        new_rule = [new_rule 0];
                    end

                    while size(R,2) < length(new_rule)
                        R = [R, zeros(size(R,1),1)];
                    end

                    R(f(i),:) = new_rule;
                else
                    to_remove_from_R = [to_remove_from_R, rules_idx(1)];
                end
            end
            rules_idx = rules_idx(2:end);
        end

        % Remove rules and references in RE
        while ~isempty(to_remove_from_R)
            [f,~] = find(R == to_remove_from_R(1) + 100000);
            R(f,:) = [];

            p = find(RE == to_remove_from_R(1) + 100000);
            while ~isempty(p)
                RE(p(1)) = [];
                p = p(2:end);
            end

            to_remove_from_R = to_remove_from_R(2:end);
        end

        %% Frequency of rules in RE (after cleaning)
        rule_ids = R(:,1);
        freq = [];
        for i = 1:length(rule_ids)
            [f,~] = find(R == rule_ids(i));
            p = find(RE == rule_ids(i));
            freq(i) = length(p) + length(f) - 1;
        end

        %% Rules with highest relative frequency
        max_freq = max(freq);
        norm_freq = double(freq) ./ max_freq;
        norm_freq = norm_freq > 0.3;
        sum(norm_freq); %#ok<VUNUS>

        reg = rule_ids' .* norm_freq;
        reg(reg == 0) = [];
        reg2 = freq .* norm_freq;
        reg2(reg2 == 0) = [];
        reg(2,:) = reg2;
    else
        reg = [];
    end
end

%% Sequitur code
%% Read symbols and feed them into SEQUITUR
function [R,RE] = G_s(sequence)
    superS = sequence;
    R  = [];
    RE = [];
    cont = 0;

    for i = 1:length(superS)
        [R,cont,RE] = SEQ5V2(superS(i), R, cont, RE);
    end

    if ~isempty(R)
        R = R(:,1:3);
    end
    % escritura(superS,R,RE,1);  % This writes rules to a file if needed
end

%% Sequitur: rule comparison and rule generation
function [R,cont,RE] = SEQ5V2(E, R, cont, RE)

    E = [RE, E];

    %%%%%%%%%%%%%%%%%%%%% BIAS %%%%%%%%%%%%%%%%%%%%%%%%%%%
    if length(E) < 4
        % Not enough symbols to form repeated digrams
        RE = E;
        return;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if length(E) > 3
        sim = 1;
        while sim == 1 && (length(E) > 3)
            E_prev = E;
            [RE,R,cont] = comR(E,cont,R,RE);
            E = RE;
            [RE,cont,R] = genR(E,cont,R);
            E = RE;

            if length(E_prev) == length(E)
                sim = 0;
            end
        end
    end
end

function [RE,R,cont] = comR(E, cont, R, RE)
    pattern = [E(length(E)-1), E(length(E))];

    for k = 1:cont
        test_pair = R(k,2:size(R,2)-1);

        if pattern(1) == test_pair(1) && pattern(2) == test_pair(2)
            R(k,4) = R(k,4) + 1;
            E(length(E)-1) = R(k,1);
            E(length(E))   = [];
            RE = E;
        else
            RE = E;
        end
    end

    if cont == 0
        RE = E;
    end
    RE(RE == 0) = [];
end

function [RE,cont,R] = genR(E, cont, R)

    if length(E) > 3
        pattern = [E(length(E)-1), E(length(E))];

        % Scan over all possible digrams
        for i = 1:length(E)-3
            test_pair = [E(i), E(i+1)];

            % Lock to avoid skip when there are -1 symbols
            if isempty(find(pattern == -1, 1)) && isempty(find(test_pair == -1, 1)) %#ok<EFIND>
                if pattern(1) == test_pair(1) && pattern(2) == test_pair(2) && E(i) ~= 0
                    cont = cont + 1;
                    R(cont,:) = [100000 + cont, pattern, 1];

                    % Replace pattern occurrences by new rule ID
                    E(length(E)-1) = 100000 + cont;
                    E(length(E))   = 0;
                    E(i)           = 100000 + cont;
                    E(i+1)         = 0;

                    RE = E;
                else
                    RE = E;
                end
            else
                RE = E;
            end
        end
    else
        RE = E;
    end

    RE(RE == 0) = [];
end
