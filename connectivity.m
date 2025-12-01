function [imet_clean, n_new] = connectivity(imet, n, conn)
% CONEXIDAD: Removes non-connected label regions from a labeled image.
%
% Inputs:
%   imet - Labeled image (integer matrix >= 0)
%   n    - Number of labels
%   conn - Optional: pixel connectivity (4 or 8). Default = 8.
%
% Outputs:
%   imet_clean - Image containing only valid connected components
%   n_new      - Number of labels after cleaning

    if nargin < 3
        conn = 8;  % default connectivity
    end

    % Image size
    [rows, cols] = size(imet);

    % Track valid labels
    valid_labels = false(1, n);

    for label = 1:n
        mask = (imet == label);

        % Skip if this label does not appear
        if ~any(mask(:))
            continue;
        end

        % Find connected components belonging to this label
        CC = bwconncomp(mask, conn);

        % If the label contains connected pixels, it is valid
        if CC.NumObjects > 0
            % Keep only the largest connected component
            sizes = cellfun(@numel, CC.PixelIdxList);
            [~, idx_max] = max(sizes);

            % Create the final mask for this label
            final_mask = false(rows, cols);
            final_mask(CC.PixelIdxList{idx_max}) = true;

            % Initialize final image on the first iteration
            if label == 1
                im_final = zeros(rows, cols);
            end

            % Save the cleaned region into the final image
            im_final(final_mask) = label;
            valid_labels(label) = true;
        end
    end

    % Relabel consecutively
    [imet_clean, ~, new_ids] = unique(im_final);
    imet_clean = reshape(new_ids, rows, cols) - 1;

    % Updated number of labels
    n_new = max(imet_clean(:));
end
