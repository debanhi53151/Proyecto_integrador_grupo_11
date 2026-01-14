function [waypoints] = planificar_ruta(mapPlan, start, goal)
    % Definición del espacio de estados SE(2)
    space = stateSpaceSE2;
    space.StateBounds = [mapPlan.XWorldLimits; mapPlan.YWorldLimits; [-pi pi]];

    % Validador de colisiones con el mapa
    validator = validatorOccupancyMap(space);
    validator.Map = mapPlan;
    validator.ValidationDistance = 0.05;

    % Semilla fija para reproducibilidad
    rng(42);

    % Creación del planificador RRT*
    planner = plannerRRTStar(space, validator);
    planner.MaxIterations = 3000;
    planner.MaxConnectionDistance = 1.0;

    % Ejecución de la planificación
    [pathObj, solnInfo] = plan(planner, start, goal);

    % Validación de que se encontró una solución
    if isempty(pathObj.States)
        error("No se encontró un camino válido.");
    end

    % Extracción de los waypoints en (x,y)
    waypoints = pathObj.States(:,1:2);
end