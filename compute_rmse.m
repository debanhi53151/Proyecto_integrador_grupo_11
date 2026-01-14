function [rmse_full, rmse_pos] = compute_rmse(x_true, x_est)
    e_full = x_est - x_true;
    e_full(3,:) = wrapToPi(e_full(3,:));
    rmse_full = sqrt(mean(vecnorm(e_full, 2, 1).^2));  % exacto

    e_pos = e_full(1:2,:);
    rmse_pos = sqrt(mean(vecnorm(e_pos, 2, 1).^2));    % exacto
end