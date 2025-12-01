function handles = actualizarAjuste(ax, Production_rules, handles)
% Actualiza una gráfica logarítmica en tiempo real usando plotyy (MATLAB 2015)

    tiempos = Production_rules(2,:);
    reglas  = Production_rules(1,:);

    valid = (tiempos > 0) & (reglas > 0);
    tiempos = tiempos(valid);
    reglas  = reglas(valid);

    if length(tiempos) < 3
        return;
    end

    % Ajuste logarítmico
    p = polyfit(log(tiempos), reglas, 1);
    a = p(1); 
    b = p(2);

    y_aprox = a * log(tiempos) + b;
    dy = a ./ tiempos;

    %% PRIMERA VEZ ? Crear plotyy
    if isempty(handles)
        [AX, H1, H2] = plotyy(ax, tiempos, reglas, tiempos, dy);

        hold(AX(1),'on');
        hold(AX(2),'on');

        Hap = plot(AX(1), tiempos, y_aprox, 'r-', 'LineWidth', 2);

        ylabel(AX(1),'Número de reglas');
        ylabel(AX(2),'Derivada a/t');
        xlabel(AX(1),'Tiempo (min)');
        title(AX(1),'Crecimiento de reglas + ajuste logarítmico');

        handles.AX = AX;
        handles.H1 = H1;
        handles.H2 = H2;
        handles.Hap = Hap;
        return;
    end

    %% ACTUALIZAR DATOS
    set(handles.H1,'XData',tiempos,'YData',reglas);
    set(handles.H2,'XData',tiempos,'YData',dy);
    set(handles.Hap,'XData',tiempos,'YData',y_aprox);

    drawnow;
end
