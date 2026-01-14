function err = compute_error_final(x_true, x_est)
    err = norm(x_est(1:2,end) - x_true(1:2,end));
end