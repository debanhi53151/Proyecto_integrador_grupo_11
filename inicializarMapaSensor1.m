function [L, p0] = inicializarMapaSensor1(M_Real)
% INICIALIZARMAPASENSOR  Inicializa el mapa del robot en log-odds
% Entradas:
%   M_Real -> mapa binario del entorno (1=libre, 0=ocupado)
% Salidas:
%   L   -> mapa en log-odds inicializado con incertidumbre (l=0)
%   p0  -> probabilidad inicial (0.5)

    %----------------------------
    % 1) Probabilidad inicial
    %----------------------------
    p0 = 0.5;                          % incertidumbre total
    l0 = log(p0 / (1 - p0));           % log-odds de p=0.5 → l=0

    %----------------------------
    % 2) Inicializar mapa en log-odds
    %----------------------------
    L = l0 * ones(size(M_Real));       % todas las celdas con l=0

    %----------------------------
    % 3) Ajustar orientación para coincidir con M_Real
    %----------------------------
    L = imrotate(L, 180);              % rotar 180° para alinear
    L = flip(L, 2);                    % flip horizontal

    %----------------------------
    % 4) Visualización inicial
    %----------------------------
    Pm = 1 ./ (1 + exp(-L));           % convertir log-odds a probabilidad

    figure;
    hold on;
    image(100 * Pm);                   % escalar para colormap
    colormap(sky(100));                % usar colormap "sky"
    axis([0 size(M_Real,2) 0 size(M_Real,1)]);
    xlabel('X'); ylabel('Y');
    title('Mapa Sensorizado (Inicializado)');
end
