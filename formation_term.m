function Ufo = formation_term(X, V, A, Pstar, P)
%FORMATION_TERM  Distributed formation-keeping control term.
%
%   Ufo = FORMATION_TERM(X, V, A, Pstar, P) computes the formation component
%   of the control input for each agent using weighted relative errors over
%   the communication/sensing graph.
%
%   For each agent i:
%       u_fo,i = - sum_j k1*a_ij*(e_i - e_j) - sum_j k2*a_ij*(v_i - v_j)
%   where:
%       e_i = x_i - p_i*
%
%   Inputs:
%       X     : agent positions (n-by-m)
%       V     : agent velocities (n-by-m)
%       A     : weighted adjacency matrix (n-by-n)
%       Pstar : desired relative formation targets (n-by-m)
%       P     : parameter struct with fields n, m, k1, k2
%
%   Output:
%       Ufo : formation control term for all agents (n-by-m)

n = P.n; m = P.m;
Ufo = zeros(n,m);

E = X - Pstar;

for i = 1:n
    ui = zeros(1,m);
    for j = 1:n
        if (j ~= i) && (A(i,j) > 0)
            ui = ui ...
                - P.k1 * A(i,j) * (E(i,:) - E(j,:)) ...
                - P.k2 * A(i,j) * (V(i,:) - V(j,:));
        end
    end
    Ufo(i,:) = ui;
end
end
