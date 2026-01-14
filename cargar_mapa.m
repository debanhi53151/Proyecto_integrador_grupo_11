
function [mapOriginal, mapPlan] = cargar_mapa(mapName, x0, y0, xf, yf)
    data = load('exampleMaps.mat');
    

    if ~isfield(data, mapName)
        available = string(fieldnames(data));
        error("El mapa '%s' no se encuentra. Mapas disponibles: %s", ...
              mapName, join(available, ', '));
    end

    % Obtener el mapa binario
    rawMap = data.(mapName);
    
    % Crear dos copias del mapa: uno para visualización y otro para planificación
    mapOriginal = binaryOccupancyMap(rawMap, 1);    % Mapa para visualización
    mapPlan = binaryOccupancyMap(rawMap, 1);        % Mapa para planificación
    
    % Inflado del mapa de planificación para evitar que el robot pase demasiado cerca de obstáculos
    inflate(mapPlan, 0.8);  % Simula un robot más grande (trayectorias más seguras)

    % Validación de que los puntos no estén en una celda ocupada (obstáculo) tras el inflado
    if getOccupancy(mapPlan, [x0, y0]) > 0 || getOccupancy(mapPlan, [xf, yf]) > 0
        error('El punto de inicio o fin está dentro de un obstáculo tras inflar el mapa.');
    end
end