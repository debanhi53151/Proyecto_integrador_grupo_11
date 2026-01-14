function rpe = compute_rpe(x_true, x_est)
    d_est = diff(x_est(1:2,:), 1, 2);
    d_true = diff(x_true(1:2,:), 1, 2);
    rpe = mean(vecnorm(d_est - d_true));
end