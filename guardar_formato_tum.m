function guardar_formato_tum(filename, traj, dt)
    T = size(traj, 2);
    fileID = fopen(filename, 'w');

    for k = 1:T
        t = (k-1)*dt;

        % Posición (z = 0)
        x = traj(1,k);
        y = traj(2,k);
        z = 0;

        % Orientación theta → cuaternión
        theta = traj(3,k);
        q = axang2quat([0 0 1 theta]);  % eje z

        % Escribir línea
        fprintf(fileID, '%.6f %.6f %.6f %.6f %.6f %.6f %.6f %.6f\n', ...
                t, x, y, z, q(2), q(3), q(4), q(1));  % TUM = [t x y z qx qy qz qw]
    end

    fclose(fileID);
    fprintf('Guardado en formato TUM: %s\n', filename);
end
