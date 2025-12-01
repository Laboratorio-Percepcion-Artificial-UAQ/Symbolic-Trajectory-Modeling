function Tray_symbols = convertPathsToSymbols(Tray, vec)
% =========================================================================
% CONVERT TRACKS (i,j,frame) INTO SYMBOL-ONLY SEQUENCES
%
% Inputs:
%       Tray(id) = [i j frame]
%       vec      = segmented state matrix
%
% Output:
%       Tray_symbols.Track_id = [s1 s2 s3 ... sN]
%
% The function outputs only symbolic sequences (no frame information).
%
% Compatible with MATLAB 2015
% =========================================================================

Tray_symbols = struct();
track_keys = keys(Tray);

for k = 1:length(track_keys)

    id = track_keys{k};
    data = Tray(id);       % columns: [i j frame]

    X = data(:,1) + 1;     % index correction
    Y = data(:,2) + 1;

    symbols = [];

    for p = 1:length(X)

        % Check boundaries
        if X(p) >= 1 && X(p) <= size(vec,1) && ...
           Y(p) >= 1 && Y(p) <= size(vec,2)

            state = vec(X(p), Y(p));

            % Keep only valid states
            if state ~= 0
                symbols(end+1) = state; %#ok<AGROW>
            end
        end
    end

    % Save only valid (non-empty) trajectories
    if ~isempty(symbols)
        Tray_symbols.(sprintf('Track_%d', id)) = symbols;
    end
end

end
