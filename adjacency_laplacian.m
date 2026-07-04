function [Dmat, Adj01, A, D, L] = adjacency_laplacian(X, P)
%ADJACENCY_LAPLACIAN  Compute distance, adjacency, degree, and Laplacian matrices.
%
%   [Dmat, Adj01, A, D, L] = ADJACENCY_LAPLACIAN(X, P) builds the graph
%   structures induced by agent positions X using the sensing/interaction
%   radius P.R.
%
%   Outputs:
%       Dmat  : pairwise distance matrix (n-by-n)
%       Adj01 : binary adjacency (1 if d_ij < R, else 0)
%       A     : weighted adjacency with a_ij = bump(d_ij / R)
%       D     : degree matrix, D = diag(sum(A,2))
%       L     : Laplacian matrix, L = D - A
%
%   Inputs:
%       X : agent positions (n-by-m), each row is an agent position
%       P : parameter struct with fields:
%           n, R, h_bump
%
%   Notes:
%   - Self-distances are set to zero and self-edges are not included.
%   - For d_ij >= R, both Adj01(i,j) and A(i,j) are set to zero.
%   - The bump() function is assumed to implement the smooth weighting
%     described in the reference.

n = P.n;
Dmat = zeros(n,n);
Adj01 = zeros(n,n);
A = zeros(n,n);

for i = 1:n
    for j = 1:n
        if i == j
            Dmat(i,j) = 0;
        else
            dij = norm(X(i,:) - X(j,:));
            Dmat(i,j) = dij;

            if dij < P.R
                Adj01(i,j) = 1;

                % Weighted adjacency: a_ij = bump(dij / R)
                z = dij / P.R;
                A(i,j) = bump(z, P.h_bump);
            end
        end
    end
end

% Degree matrix and Laplacian
deg = sum(A, 2);
D = diag(deg);
L = D - A;
end
