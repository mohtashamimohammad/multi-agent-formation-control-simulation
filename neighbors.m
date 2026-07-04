function [Dmat, N, Adj01] = neighbors(X, P)
%NEIGHBORS  Compute neighbor sets and distance-based adjacency.
%
%   [Dmat, N, Adj01] = NEIGHBORS(X, P) computes pairwise distances and the
%   corresponding neighbor list using the interaction radius P.R.
%
%   Inputs:
%       X : agent positions (n-by-m), each row is an agent position
%       P : parameter struct with fields n, R
%
%   Outputs:
%       Dmat  : pairwise distance matrix (n-by-n)
%       N     : cell array of neighbor indices, N{i} contains neighbors of i
%       Adj01 : binary adjacency matrix (n-by-n), Adj01(i,j)=1 if d_ij < R
%
%   Notes:
%   - Self-distances are set to zero and self-edges are excluded.
%   - Neighbor relations are determined strictly by the threshold d_ij < R.

n = P.n;
Dmat = zeros(n,n);
Adj01 = zeros(n,n);
N = cell(n,1);

for i = 1:n
    for j = 1:n
        if i == j
            Dmat(i,j) = 0;
        else
            Dmat(i,j) = norm(X(i,:) - X(j,:));
            if Dmat(i,j) < P.R
                Adj01(i,j) = 1;
            end
        end
    end
end

for i = 1:n
    N{i} = find(Adj01(i,:) == 1);
end
end
