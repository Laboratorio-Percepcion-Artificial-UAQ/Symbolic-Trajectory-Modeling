function Im_debug = get_image_debug()
    Im     = evalin('caller','Im');
    tracks = evalin('caller','tracks');

    Im_debug = Im;

    for t = 1:numel(tracks)
        pos = tracks(t).positions;

        if isempty(pos), continue; end

        % posición actual
        y = pos(end,1);
        x = pos(end,2);

        % Punto
        Im_debug = insertShape(Im_debug,'FilledCircle',...
                                [x y 4],'Color','yellow','Opacity',1);

        % Texto ID
        Im_debug = insertText(Im_debug,[x+5 y+5],...
                     sprintf('ID %d',tracks(t).id),...
                     'TextColor','yellow','FontSize',12,...
                     'BoxOpacity',0.4,'BoxColor','black');

        % pequeños trazos
        if size(pos,1) > 2
            for k=max(1,size(pos,1)-10):size(pos,1)-1
                p1 = pos(k,:);
                p2 = pos(k+1,:);
                Im_debug = insertShape(Im_debug,'Line',...
                    [p1(2),p1(1), p2(2),p2(1)],...
                    'Color','green','LineWidth',2);
            end
        end
    end
end
