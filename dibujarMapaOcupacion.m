function dibujarMapaOcupacion(Pm, Pos)
% DIBUJARMAPAOCUPACION  Visualiza el mapa de ocupación estimado con la trayectoria del robot
% Entradas:
%   Pm  -> mapa de ocupación en probabilidades (matriz)
%   Pos -> trayectoria del robot [x,y]

    figure('Name','Mapa de Ocupación Estimado','NumberTitle','off');
    hold on;

    % Mostrar mapa de ocupación
    image(100 * Pm);
    colormap(sky(100));
    axis([0 size(Pm,2) 0 size(Pm,1)]);
    xlabel('X'); ylabel('Y');
    title('Mapa de Ocupación Estimado');

    % Dibujar trayectoria del robot
    if ~isempty(Pos)
        plot(Pos(:,1), Pos(:,2), 'r-', 'LineWidth', 2, 'DisplayName','Trayectoria');
        legend('Location','best');
    end

    hold off;
end