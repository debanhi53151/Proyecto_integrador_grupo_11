function results = calcular_metricas(xTrue, estStruct, covStruct, Q, latencyStruct)

    filters = fieldnames(estStruct);
    results = struct();
    
    for i = 1:numel(filters)
        name = filters{i};
        x_est = estStruct.(name);
        P_est = [];
        if isfield(covStruct, name)
            P_est = covStruct.(name);
        end
        latency = latencyStruct.(name);
    
        % Errores
        ate = compute_ate(xTrue, x_est);
        rpe = compute_rpe(xTrue, x_est);
        [rmse_full, rmse_pos] = compute_rmse(xTrue, x_est);
        drift = compute_drift(xTrue, x_est);
        final_err = compute_error_final(xTrue, x_est);
        std_err = compute_std_error(xTrue, x_est);
        nees = compute_nees(xTrue, x_est, P_est);
        nis = compute_nis(xTrue, x_est, Q);
        [lat_mean, freq] = compute_latency(latency);
    
        results.(name) = struct( ...
            'ATE', ate, ...
            'RPE', rpe, ...
            'RMSE_full', rmse_full, ...
            'RMSE_pos', rmse_pos, ...
            'Drift', drift, ...
            'FinalError', final_err, ...
            'StdError', std_err, ...
            'NEES', nees, ...
            'NIS', nis, ...
            'Latency_ms', lat_mean * 1000, ...
            'UpdateHz', freq ...
        );
    end
    
    % Mostrar en consola
    disp('--- MÉTRICAS DE LOS ESTIMADORES ---');
    for i = 1:numel(filters)
        name = filters{i};
        r = results.(name);
        fprintf('\n[%s]\n', name);
        fprintf('ATE:           %.4f m\n', r.ATE);
        fprintf('RPE:           %.4f m\n', r.RPE);
        fprintf('RMSE (full):   %.4f m\n', r.RMSE_full);
        fprintf('RMSE (pos):    %.4f m\n', r.RMSE_pos);
        fprintf('Drift acumul.: %.4f m\n', r.Drift);
        fprintf('Error final:   %.4f m\n', r.FinalError);
        fprintf('STD Error:     %.4f m\n', r.StdError);
        fprintf('NEES:          %.4f\n', r.NEES);
        fprintf('NIS:           %.4f\n', r.NIS);
        fprintf('Latencia:      %.2f ms\n', r.Latency_ms);
        fprintf('Frecuencia:    %.2f Hz\n', r.UpdateHz);
    end
end