function nees = compute_nees(x_true, x_est, P)
    if isempty(P)
        nees = NaN;
        return;
    end
    e = x_est - x_true;
    e(3,:) = wrapToPi(e(3,:));
    nees = mean(arrayfun(@(i) e(:,i)' * (P \ e(:,i)), 1:size(e,2)));
end