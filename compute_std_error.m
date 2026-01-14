function std_err = compute_std_error(x_true, x_est)
    e = x_est(1:2,:) - x_true(1:2,:);
    std_err = std(vecnorm(e));
end