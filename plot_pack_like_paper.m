function plot_pack_like_paper(out, P, out_dir, tag)
%PLOT_PACK_LIKE_PAPER  Generate a standard set of plots and export to files.
%
%   PLOT_PACK_LIKE_PAPER(out, P, out_dir, tag) produces a compact figure set
%   (similar to typical paper-style simulation result sections) and saves all
%   figures as PNG files into out_dir. The tag is appended to filenames and
%   figure titles to distinguish scenarios.
%
%   Inputs:
%       out     : simulation output struct (expects fields: t, X_hist, V_hist,
%                 xr_hist, vr_hist, lambda2, minDist, and optionally U_hist)
%       P       : parameter struct (expects fields: n, d_safe)
%       out_dir : output directory path for saved figures
%       tag     : descriptive string identifier, e.g., 'triangle_with_potential'

t = out.t; n = P.n;

%% 1) Trajectories
figure; hold on; grid on;
for i = 1:n
    xi = squeeze(out.X_hist(i,1,:));
    yi = squeeze(out.X_hist(i,2,:));
    plot(xi, yi, 'LineWidth', 1.2);
end
plot(out.xr_hist(1,:), out.xr_hist(2,:), 'k--', 'LineWidth', 2);
xlabel('x'); ylabel('y'); title(['Trajectories - ' tag]);
saveas(gcf, fullfile(out_dir, ['traj_' tag '.png'])); close;

%% 2) Pairwise distances
figure; grid on; hold on;
for i = 1:n
    Xi = squeeze(out.X_hist(i,:,:)); % 2-by-Nt
    for j = i+1:n
        Xj = squeeze(out.X_hist(j,:,:));
        dij = sqrt((Xi(1,:)-Xj(1,:)).^2 + (Xi(2,:)-Xj(2,:)).^2);
        plot(t, dij, 'LineWidth', 1.0);
    end
end
yline(P.d_safe, 'k--', 'LineWidth', 2);
xlabel('time (s)'); ylabel('d_{ij}(t)');
title(['Inter-agent distances - ' tag]);
saveas(gcf, fullfile(out_dir, ['dist_' tag '.png'])); close;

%% 3) Velocity tracking error
figure; grid on; hold on;
for i = 1:n
    vi  = squeeze(out.V_hist(i,:,:)); % 2-by-Nt
    err = sqrt((vi(1,:)-out.vr_hist(1,:)).^2 + (vi(2,:)-out.vr_hist(2,:)).^2);
    plot(t, err, 'LineWidth', 1.1);
end
xlabel('time (s)'); ylabel('||v_i - v_r||');
title(['Velocity error - ' tag]);
saveas(gcf, fullfile(out_dir, ['velErr_' tag '.png'])); close;

%% 4) Control inputs u_x and u_y (if available)
if isfield(out, 'U_hist')
    figure; grid on; hold on;
    for i = 1:n
        ux = squeeze(out.U_hist(i,1,:));
        plot(t, ux, 'LineWidth', 1.0);
    end
    xlabel('time (s)'); ylabel('u_x');
    title(['Control input u_x - ' tag]);
    saveas(gcf, fullfile(out_dir, ['ux_' tag '.png'])); close;

    figure; grid on; hold on;
    for i = 1:n
        uy = squeeze(out.U_hist(i,2,:));
        plot(t, uy, 'LineWidth', 1.0);
    end
    xlabel('time (s)'); ylabel('u_y');
    title(['Control input u_y - ' tag]);
    saveas(gcf, fullfile(out_dir, ['uy_' tag '.png'])); close;
end

%% 5) Algebraic connectivity (lambda2)
figure; grid on;
plot(t, out.lambda2, 'LineWidth', 1.5);
xlabel('time (s)'); ylabel('\lambda_2(L)');
title(['Connectivity (\lambda_2) - ' tag]);
saveas(gcf, fullfile(out_dir, ['lambda2_' tag '.png'])); close;

%% 6) Minimum inter-agent distance
figure; grid on; hold on;
plot(t, out.minDist, 'LineWidth', 1.5);
yline(P.d_safe, 'k--', 'LineWidth', 2);
xlabel('time (s)'); ylabel('min d_{ij}(t)');
title(['Minimum distance - ' tag]);
saveas(gcf, fullfile(out_dir, ['minDist_' tag '.png'])); close;

end
