function Upo = potential_term(X, A, P)
%POTENTIAL_TERM  Potential-based interaction term (collision avoidance / connectivity).
%
%   Upo = POTENTIAL_TERM(X, A, P) computes the potential/action component of
%   the distributed controller using the weighted interaction graph.
%
%   For each agent i:
%       u_po,i = - sum_j a_ij * f(d_ij) * (x_i - x_j) / d_ij
%   where d_ij = ||x_i - x_j|| and f(.) is given by ACTION_F(.) in accordance
%   with the reference formulation.
%
%   Inputs:
%       X : agent positions (n-by-m)
%       A : weighted adjacency matrix (n-by-n)
%       P : parameter struct with fields n, m, eps_d (and action_f parameters)
%
%   Output:
%       Upo : potential/action term for all agents (n-by-m)

n = P.n;
m = P.m;
Upo = zeros(n,m);

for i = 1:n
    ui = zeros(1,m);
    for j = 1:n
        if (j ~= i) && (A(i,j) > 0)
            diff = X(i,:) - X(j,:);
            dij  = norm(diff);

            if dij > P.eps_d
                fij = action_f(dij, P);
                ui  = ui - A(i,j) * fij * (diff / dij);
            end
        end
    end
    Upo(i,:) = ui;
end
end
