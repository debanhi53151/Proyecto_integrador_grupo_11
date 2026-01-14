
function controller = controlador_robot(waypoints)
    controller = controllerPurePursuit;
    controller.Waypoints = waypoints;
    controller.LookaheadDistance = 0.6;
    controller.DesiredLinearVelocity = 1.0;
    controller.MaxAngularVelocity = 1.5;
end