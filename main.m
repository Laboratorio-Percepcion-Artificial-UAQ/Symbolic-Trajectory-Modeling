clc; clear all; close all;

%% === Load Video ===
video_path = pwd;  % carpeta actual
vid = VideoReader(fullfile(video_path, 'Rawvideo.avi'));

fps          = vid.FrameRate;
total_frames = floor(vid.Duration * fps);
duration_min = (total_frames / fps) / 60;

fprintf('FPS: %.2f   Frames: %d   Duration: %.2f min\n', ...
    fps, total_frames, duration_min);

%% === First Frame Initialization ===
Im_prev       = readFrame(vid);
Im_color      = Im_prev;
state_mask    = zeros(size(Im_prev,1), size(Im_prev,2));

Im_prev_gray  = rgb2gray(Im_prev);
Im_prev_filt  = imgaussfilt(Im_prev_gray, 1);

Sx = fspecial('sobel');
Sy = Sx';

Im_prev_x   = imfilter(double(Im_prev_filt), Sx, 'replicate');
Im_prev_y   = imfilter(double(Im_prev_filt), Sy, 'replicate');
Im_prev_norm = uint8(sqrt(Im_prev_x.^2 + Im_prev_y.^2));

%% === Processing Parameters ===
step_frames      = 8;
min_area         = 12;
cost_threshold   = min_area;
dead_frame_limit = 10 * step_frames;

Tracks_temp   = containers.Map('KeyType','double','ValueType','any');
Tracks_final  = containers.Map('KeyType','double','ValueType','any');
last_update   = containers.Map('KeyType','double','ValueType','any');

temp_id   = 1;
track_id  = 0;
frame_idx = 0;
vec            = zeros(size(Im_prev_gray));
decay_acc      = zeros(size(Im_prev_gray));
decay_prev     = zeros(size(Im_prev_gray));
alpha_decay    = 0.9;

accumulator = 0;

%% === Grammar extraction variables ===
Rules_aux      = [];
rules_index    = 0;
ProductionRules = [];
rho            = 100;

%% === Figure for rule growth ===
figRules = figure('Name','Production Rule Growth','NumberTitle','off');
axRules  = axes('Parent', figRules);
hold(axRules,'on');
xlabel(axRules,'Time (min)');
ylabel(axRules,'Number of Production Rules');
title(axRules,'Grammar Growth Over Time');
grid(axRules,'on');
hRules = [];

%% === Debugging Figures ===
figure; set(gcf,'Name','DEBUG - Video','NumberTitle','off');

subplot(2,2,1); hVideo = imshow(Im_prev);    title('Video');
subplot(2,2,2); hMotion = imshow(decay_acc); title('Acc Motion Temporability');
subplot(2,2,3); hPaths  = imshow(vec);   title('States discovered');
subplot(2,2,4); hStates = imshow(state_mask); title('Motion States');

drawnow;

%% === PROCESS VIDEO ===
while hasFrame(vid)

    Im = readFrame(vid);
    accumulator = accumulator + 1;

    if accumulator == step_frames
        frame_idx = frame_idx + step_frames;

        %% === Preprocess Current Frame ===
        Im_gray = rgb2gray(Im);
        Im_gray_filt = imgaussfilt(Im_gray, 1);

        Im_x = imfilter(double(Im_gray_filt), Sx, 'replicate');
        Im_y = imfilter(double(Im_gray_filt), Sy, 'replicate');
        Im_norm = uint8(sqrt(Im_x.^2 + Im_y.^2));

        Im_diff = imabsdiff(Im_prev_norm, Im_norm);
        motion_sum = sum(Im_diff(:));
        Im_prev_norm = Im_norm;

        motion_mask = false(size(Im_diff));

        %% === MOTION DETECTION ===
        if motion_sum > 85000

            Im_filt = medfilt2(Im_diff, [5 5]);
            Im_bin  = Im_filt > 35;

            se = strel('square',7);
            motion_mask = imclose(Im_bin, se);

            [L, num] = bwlabel(motion_mask);
            stats = regionprops(L,'Area','BoundingBox');

            Positions = [];

            if num > 0
                decay = alpha_decay * decay_prev + (1 - alpha_decay) * double(motion_mask);
                decay_acc  = decay_acc + decay;
                decay_prev = decay;

                %% Extract blob centroids
                for k = 1:num
                    area = stats(k).Area;
                    bb   = stats(k).BoundingBox;

                    if area > min_area
                        j = bb(1); i = bb(2); 
                        w = bb(3); h = bb(4);

                        pos_i = round(i + h/2);
                        pos_j = round(j + w/2);

                        Positions = [Positions; pos_i pos_j frame_idx];
                    end
                end

                %% === TRACK GENERATION ===
                for p = 1:size(Positions,1)
                    pos = Positions(p,:);

                    if isempty(keys(Tracks_temp))
                        Tracks_temp(temp_id) = pos;
                        last_update(temp_id) = frame_idx;
                        temp_id = temp_id + 1;

                    else
                        temp_keys = keys(Tracks_temp);
                        costs = zeros(length(temp_keys),1);

                        for kk = 1:length(temp_keys)
                            key = temp_keys{kk};
                            last_pos = Tracks_temp(key);
                            last_xy  = last_pos(end,1:2);
                            costs(kk) = norm(double(pos(1:2)) - double(last_xy));
                        end

                        [min_cost, idx_min] = min(costs);

                        if min_cost < 1.5 * cost_threshold
                            key_use = temp_keys{idx_min};
                            last_pos = Tracks_temp(key_use);
                            last_xy  = last_pos(end,1:2);
                            avg_xy   = round((last_xy + pos(1:2)) / 2);

                            Tracks_temp(key_use) = [Tracks_temp(key_use); avg_xy pos(3)];
                            last_update(key_use) = frame_idx;

                        else
                            Tracks_temp(temp_id) = pos;
                            last_update(temp_id) = frame_idx;
                            temp_id = temp_id + 1;
                        end
                    end
                end

                %% === TRACK TERMINATION ===
                temp_keys = keys(Tracks_temp);
                remove_ids = [];

                for kk = 1:length(temp_keys)
                    key = temp_keys{kk};

                    if (frame_idx - last_update(key)) > dead_frame_limit

                        if size(Tracks_temp(key),1) > 3
                            track_id = track_id + 1;
                            Tracks_final(track_id) = Tracks_temp(key);

                            %% === EVERY 40 TRACKS GRAMMAR EXTRACTION ===
                            %This value can be adjusted as desired
                            if mod(Tracks_final.Count,40)==0

                                [vec, state_mask] = Watershed(decay_acc, Im_color);
                                Track_symbols = convertPathsToSymbols(Tracks_final, vec);

                                symbol_names = fieldnames(Track_symbols);
                                Rules_aux = [];
                                rules_index = 0;

                                for t_sym = 1:length(symbol_names)

                                    name_trk = symbol_names{t_sym};
                                    id_num = str2double(name_trk(7:end));

                                    if ~isKey(Tracks_final, id_num)
                                        continue;
                                    end

                                    track_raw = Tracks_final(id_num);
                                    last_frame = track_raw(end,3);
                                    time_min = (last_frame / fps) / 60;

                                    sequence = Track_symbols.(name_trk);
                                    unique_sym = unique(sequence);

                                    if length(unique_sym) > 1
                                        [R,RE,reg] = OriSeqV1(sequence);
                                        Rul = decode_rules(R);

                                        Rules_aux = [Rules_aux, Rul];
                                        Rules_aux = removeDuplicateRules(Rules_aux);
                                    end

                                    %% === update rule list ===
                                    rules_index = rules_index + 1;
                                    ProductionRules(1, rules_index) = length(Rules_aux);
                                    ProductionRules(2, rules_index) = time_min;

                                    %% === compute rho ===
                                    if rules_index > 3
                                        t = ProductionRules(2,1:rules_index);
                                        f_n = ProductionRules(1,1:rules_index);

                                        p = polyfit(log(t), f_n, 1);
                                        a = p(1);

                                        rho = a / t(end);   % derivative of a*log(t)
                                        if rho==1 || rho<1 
                                            %% === SAVE OUTPUTS ===
                                            fprintf('rho = %.4f (%.2f min) | Remaining = %.1f s (%.2f min) | Progress = %.1f%%\n', ...
            rho, t_min, remaining_s, remaining_min, progress);
                                            disp('The model now has enough information.')
                                            save('FullGrammarExtraction.mat', ...
    'vec','ProductionRules','Rules_aux','Track_symbols','Tracks_final','state_mask');

                                            return;
                                        end
                                    end

                                    %% === Update Grammar Growth Plot ===
                                    if isempty(hRules)
                                        hRules = plot(axRules, ...
                                            ProductionRules(2,:), ...
                                            ProductionRules(1,:), ...
                                            'LineWidth', 2);
                                    else
                                        set(hRules, ...
                                            'XData', ProductionRules(2,:), ...
                                            'YData', ProductionRules(1,:));
                                    end

                                    drawnow;
                                end
                            end
                        end

                        remove_ids(end+1) = key;
                    end
                end

                %% Remove finished tracks
                for kk = 1:length(remove_ids)
                    remove(Tracks_temp, remove_ids(kk));
                    remove(last_update, remove_ids(kk));
                end
            end
        end

        %% === DRAW TRACKS ===
        temp_keys = keys(Tracks_temp);
        for kk = 1:length(temp_keys)
            key = temp_keys{kk};
            pts = Tracks_temp(key);

            if size(pts,1) > 1
                for t = 1:size(pts,1)-1
                    p1 = pts(t,1:2);
                    p2 = pts(t+1,1:2);
                end
            end
        end

        %% === UPDATE FIGURES ===
        set(hVideo,'CData',Im);
        set(hMotion,'CData',decay_acc);
        set(hPaths,'CData',vec);
        set(hStates,'CData',state_mask);
        drawnow;

        %% === Time Reporting ===
        t_sec = frame_idx / fps;
        t_min = t_sec / 60;

        progress      = (frame_idx / total_frames) * 100;
        remaining_s   = (total_frames / fps) - t_sec;
        remaining_min = remaining_s / 60;

        fprintf('rho = %.4f (%.2f min) | Remaining = %.1f s (%.2f min) | Progress = %.1f%%\n', ...
            rho, t_min, remaining_s, remaining_min, progress);

        accumulator = 0;
    end
end

%% === SAVE OUTPUTS ===
save('FullGrammarExtraction.mat', ...
    'vec','ProductionRules','Rules_aux','Track_symbols','Tracks_final','state_mask');

