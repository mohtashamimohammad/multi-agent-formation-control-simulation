% main.m
clear; clc; close all;

%% Parameters
run('params.m');   % builds the parameter struct P

%% Create results folder
if ~exist('results', 'dir')
    mkdir('results');
end

% Create a unique output folder for this run
run_id  = datestr(now, 'yyyy-mm-dd_HH-MM-SS');
out_dir = fullfile('results', ['run_' run_id]);
mkdir(out_dir);
P.out_dir = out_dir;

%% Initial conditions
[X0, V0] = init_condition(P);

%% Scenarios: triangle and hexagon
formations = ["triangle", "hexagon"];

for f = 1:numel(formations)

    % Configure formation
    P.formation_type = formations(f);
    P.Pstar = formation_targets(P, P.formation_type);

    % Output folder for this formation
    form_dir = fullfile(P.out_dir, char(P.formation_type));
    mkdir(form_dir);

    fprintf('\n===== Formation: %s =====\n', P.formation_type);
    assert(all(size(P.Pstar) == [P.n, P.m]), 'Pstar size mismatch!');

    % Simulation cases (as in the reference setup):
    %   - triangle: with and without potential term
    %   - hexagon : without potential term only
    if P.formation_type == "hexagon"
        cases      = [false];
        case_names = ["without_potential"];
    else
        cases      = [true, false];
        case_names = ["with_potential", "without_potential"];
    end

    for c = 1:numel(cases)

        P.use_potential = cases(c);

        % Dedicated output folder for this case
        sub_dir = fullfile(form_dir, char(case_names(c)));
        mkdir(sub_dir);

        % --- Run simulation ---
        out = simulate(X0, V0, P);

        %  Save data 
        save(fullfile(sub_dir, 'data.mat'), 'P', 'X0', 'V0', 'out');

        %  Safety violations (d < d_safe) 
        badIdx   = find(out.minDist < P.d_safe);
        badTimes = out.t(badIdx);
        save(fullfile(sub_dir, 'badTimes.mat'), 'badIdx', 'badTimes');

        viol_time = numel(badIdx) * P.dt;

        %%  Plot 1: trajectories 
        figure; hold on; grid on;
        for i = 1:P.n
            xi = squeeze(out.X_hist(i,1,:));
            yi = squeeze(out.X_hist(i,2,:));
            plot(xi, yi, 'LineWidth', 1.3);
        end
        plot(out.xr_hist(1,:), out.xr_hist(2,:), 'k--', 'LineWidth', 2);
        xlabel('x'); ylabel('y');
        title(sprintf('Trajectories - %s - %s', P.formation_type, case_names(c)));
        saveas(gcf, fullfile(sub_dir, 'traj.png'));
        close;

        %%  Plot 2: minimum inter-agent distance 
        figure; grid on; hold on;
        plot(out.t, out.minDist, 'LineWidth', 1.5);
        yline(P.d_safe, 'k--', 'LineWidth', 2);
        xlabel('time (s)'); ylabel('min d_{ij}(t)');
        title(sprintf('Min Distance - %s - %s', P.formation_type, case_names(c)));
        saveas(gcf, fullfile(sub_dir, 'minDist.png'));
        close;

        %%  Plot 3: number of edges 
        figure; grid on;
        plot(out.t, out.numEdges, 'LineWidth', 1.5);
        xlabel('time (s)'); ylabel('edges');
        title(sprintf('Edges - %s - %s', P.formation_type, case_names(c)));
        saveas(gcf, fullfile(sub_dir, 'edges.png'));
        close;

        %%  Plot 4: algebraic connectivity (lambda2)
        figure; grid on;
        plot(out.t, out.lambda2, 'LineWidth', 1.5);
        xlabel('time (s)'); ylabel('\lambda_2(L)');
        title(sprintf('lambda2 - %s - %s', P.formation_type, case_names(c)));
        saveas(gcf, fullfile(sub_dir, 'lambda2.png'));
        close;

        %%  Plot 5: velocity tracking error 
        figure; grid on; hold on;
        for i = 1:P.n
            vi  = squeeze(out.V_hist(i,:,:));  % 2-by-Nt
            err = sqrt((vi(1,:) - out.vr_hist(1,:)).^2 + (vi(2,:) - out.vr_hist(2,:)).^2);
            plot(out.t, err, 'LineWidth', 1.1);
        end
        xlabel('time (s)'); ylabel('||v_i - v_r||');
        title(sprintf('Velocity Error - %s - %s', P.formation_type, case_names(c)));
        saveas(gcf, fullfile(sub_dir, 'vel_error.png'));
        close;

        %% Control input signals (if available) 
        if isfield(out, 'U_hist')
            % u_x
            figure; grid on; hold on;
            for i = 1:P.n
                ux = squeeze(out.U_hist(i,1,:));
                plot(out.t, ux, 'LineWidth', 1.0);
            end
            xlabel('time (s)'); ylabel('u_x');
            title(sprintf('Control input u_x - %s - %s', P.formation_type, case_names(c)));
            saveas(gcf, fullfile(sub_dir, 'ux.png'));
            close;

            % u_y
            figure; grid on; hold on;
            for i = 1:P.n
                uy = squeeze(out.U_hist(i,2,:));
                plot(out.t, uy, 'LineWidth', 1.0);
            end
            xlabel('time (s)'); ylabel('u_y');
            title(sprintf('Control input u_y - %s - %s', P.formation_type, case_names(c)));
            saveas(gcf, fullfile(sub_dir, 'uy.png'));
            close;
        end

        %%  Short numeric summary 
        fprintf('\n[%s | %s]\n', P.formation_type, case_names(c));
        fprintf('min(minDist) = %.6f (safe = %.6f)\n', min(out.minDist), P.d_safe);
        fprintf('violation time (s) = %.3f\n', viol_time);
        fprintf('min(lambda2) = %.6f, max(lambda2) = %.6f\n', min(out.lambda2), max(out.lambda2));
        fprintf('num safety violations = %d\n', numel(badIdx));

    end
end

disp('Done. Results saved in:');
disp(P.out_dir);
