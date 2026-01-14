function [Pos, theta] = trayectoriaSerpiente()
% TRAJECTORIARSERPIENTE  Genera una trayectoria tipo serpiente entre racks
% Salidas:
%   Pos   -> matriz [x,y] con coordenadas del robot
%   theta -> orientación en cada punto

    % Parámetros del entorno logístico
    altoMapa  = 500;   % altura del mapa
    pasilloY  = 80;    % altura inicial del pasillo
    pasoY     = 40;    % avance vertical por tramo
    xRacks    = [80, 150, 220, 290, 360];  % posiciones X de los racks
    margen    = 10;    % margen respecto al rack

    % Inicializar trayectoria
    Pos = [];
    theta = [];

    for i = 1:length(xRacks)-1
        x1 = xRacks(i) + margen;
        x2 = xRacks(i+1) - margen;

        % Trayecto vertical ascendente
        for y = pasilloY:pasoY:(altoMapa - pasilloY)
            Pos = [Pos; x1, y];
            theta = [theta; pi/2];  % orientación hacia arriba
        end

        % Conexión horizontal al siguiente pasillo
        Pos = [Pos; linspace(x1, x2, 10)', (altoMapa - pasilloY) * ones(10,1)];
        theta = [theta; zeros(10,1)];  % orientación horizontal derecha

        % Trayecto vertical descendente
        for y = (altoMapa - pasilloY):-pasoY:pasilloY
            Pos = [Pos; x2, y];
            theta = [theta; -pi/2];  % orientación hacia abajo
        end

        % Conexión horizontal al siguiente pasillo
        if i < length(xRacks)-1
            Pos = [Pos; linspace(x2, xRacks(i+2) + margen, 10)', pasilloY * ones(10,1)];
            theta = [theta; zeros(10,1)];
        end
    end
end


%[appendix]{"version":"1.0"}
%---
