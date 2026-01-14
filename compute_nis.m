function nis = compute_nis(x_true, x_est, Q)
    e = x_est - x_true;
    e(3,:) = wrapToPi(e(3,:));
    nis = mean(arrayfun(@(i) e(:,i)' * (Q \ e(:,i)), 1:size(e,2)));
end