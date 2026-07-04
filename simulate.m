function out = simulate(X0, V0, P)
%SIMULATE  Multi-agent simulation loop with logging and plotting signals.
%
%   out = SIMULATE(X0, V0, P) runs the discrete-time simulation using Euler
%   integration for a double-integrator agent model:
%       Xdot = V
%       Vdot = U
%
%   Inputs:
%       X0 : initial positions (n-by-m)
%       V0 : initial velocities (n-by-m)
%       P  : parameter struct (expects fields n, m, dt, t, R, use_potential,
%            and controller-related parameters)
%
%   Output struct fields:
%       out.X_hist   : position history (n-by-m-by-Nt)
%       out.V_hist   : velocity history (n-by-m-by-Nt)
%       out.xr_hist  : reference position (m-by-Nt)
%       out.vr_hist  : reference velocity (m-by-Nt)
%       out.fr_hist  : reference acceleration (m-by-Nt)
%       out.minDist  : minimum nonzero inter-agent distance (1-by-Nt)
%       out.numEdges : number of undirected edges induced by d_ij < R (1-by-Nt)
%       out.lambda2  : algebraic connectivity metric (1-by-Nt)
%       out.U_hist   : control input history (n-by-m-by-Nt)
%       out.t        : time vector (1-by-Nt)

tvec = P.t;
Nt = numel(tvec);
n = P.n; m = P.m;
U_hist = zeros(n,m,Nt);

X = X0;
V = V0;

X_hist  = zeros(n,m,Nt);
V_hist  = zeros(n,m,Nt);
xr_hist = zeros(m,Nt);
vr_hist = zeros(m,Nt);
fr_hist = zeros(m,Nt);

minDist  = zeros(1,Nt);
numEdges = zeros(1,Nt);

for k = 1:Nt
    tk = tvec(k);

    % Log states
    X_hist(:,:,k) = X;
    V_hist(:,:,k) = V;

    % Reference generator (virtual leader)
    [xr, vr, fr] = navigator(tk);
    xr_hist(:,k) = xr;
    vr_hist(:,k) = vr;
    fr_hist(:,k) = fr;

    % Graph construction from current positions
    [Dmat, Adj01, A, D, L] = adjacency_laplacian(X, P);

    % Minimum inter-agent distance (exclude diagonal zeros)
    Dtmp = Dmat(:);
    Dtmp = Dtmp(Dtmp > 0);
    if isempty(Dtmp)
        minDist(k) = NaN;
    else
        minDist(k) = min(Dtmp);
    end

    % Number of undirected edges (upper triangular count)
    numEdges(k) = nnz(triu(Adj01,1));

    % Control law components
    Utr = tracking_term(X, V, xr, vr, fr, P.Pstar);
    Ufo = formation_term(X, V, A, P.Pstar, P);

    if P.use_potential
        Upo = potential_term(X, A, P);
    else
        Upo = zeros(n,m);
    end

    U = Utr + Ufo + Upo;

    % Actuator saturation (limits extreme transients)
    Umax = 100;
    U = max(min(U, Umax), -Umax);

    U_hist(:,:,k) = U;

    % Euler integration
    X = X + P.dt * V;
    V = V + P.dt * U;

    % Connectivity metric
    lambda2(k) = get_lambda2(L);
end

out.X_hist   = X_hist;
out.V_hist   = V_hist;
out.xr_hist  = xr_hist;
out.vr_hist  = vr_hist;
out.fr_hist  = fr_hist;
out.minDist  = minDist;
out.numEdges = numEdges;
out.t        = tvec;
out.lambda2  = lambda2;
out.U_hist   = U_hist;

end
