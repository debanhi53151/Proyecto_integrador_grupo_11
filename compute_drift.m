function drift = compute_drift(x_true, x_est)
    d_est = x_est(1:2,end) - x_est(1:2,1);
    d_true = x_true(1:2,end) - x_true(1:2,1);
    drift = norm(d_est - d_true);
end