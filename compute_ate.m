function ate = compute_ate(x_true, x_est)
    e = x_est(1:2,:) - x_true(1:2,:);
    ate = mean(vecnorm(e));
end