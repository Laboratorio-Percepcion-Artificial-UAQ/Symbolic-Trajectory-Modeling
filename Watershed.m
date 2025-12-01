function [vec, vid_a1] = Watershed(tac, Im)
% WATERSHED: Generates region segmentation from an accumulated motion surface.
%
% Inputs:
%   tac - Accumulated motion surface (matrix)
%   Im  - Original RGB frame
%
% Outputs:
%   vec     - Labeled connected regions after watershed + connectivity filter
%   vid_a1  - RGB visualization with detected regions highlighted (green)

    % Image dimensions
    [rows, cols] = size(tac);

    % Binary mask of motion regions
    motion_bin = tac;
    motion_bin(motion_bin(:,:) > 0) = 1;

    % Alternate filter: opening followed by closing (applied three times)
    alt_filt = motion_bin;
    se = strel('disk', 2);

    for k = 1:3
        open_f = imopen(alt_filt, se);
        alt_filt = imclose(open_f, se);
    end

    % Adjust filtered regions based on the accumulated motion surface
    n1 = zeros(rows, cols);

    for r = 1:rows
        for c = 1:cols

            % Case 1: filtered region AND original motion > 0
            if alt_filt(r,c) && tac(r,c) ~= 0
                n1(r,c) = tac(r,c);

            % Case 2: filtered region but no motion ? mid-level marker
            elseif alt_filt(r,c) ~= 0 && tac(r,c) == 0
                n1(r,c) = 0.5;

            else
                n1(r,c) = 0;
            end
        end
    end

    % Gaussian smoothing
    f = fspecial('gaussian', 15, 2.2);
    nr = conv2(n1, f, 'same');

    % Remove weak responses
    nr(nr < 0.01 * max(nr(:))) = inf;

    % Negative for watershed (basins)
    nr = -nr;

    % Watershed segmentation
    ws = watershed(nr);
    ws_binary = (ws > 0);
    ws_binary(nr == -inf) = 0;

    se = strel('disk', 1);
    ws_clean = imopen(ws_binary, se);

    % Label connected components
    [L, num_regions] = bwlabel(ws_clean);

    % Connectivity filtering (>2)
    vec = connectivity(L, num_regions);

    % Visualization (highlight regions in green)
    vid_a1 = Im;

    for r = 1:rows
        for c = 1:cols
            if vec(r,c,1) ~= 0
                vid_a1(r,c,1) = 0;     % Red   ? 0
                vid_a1(r,c,2) = 255;   % Green ? 255
                vid_a1(r,c,3) = 0;     % Blue  ? 0
            end
        end
    end

end
