function [E, CS] = get_consensus_set(X, Theta_hat, T_noise_squared, man_fun)

% [E, CS] = get_consensus_set(X, Theta_hat, T_noise_squared, man_fun)
%
% DESC:
% select the consensus set for a given parameter vector.
%
% VERSION:
% 1.0
%
% INPUT:
% X                 = input data
% Theta_hat         = estimated parameter vector
% T_noise_squared   = noise threshold
% man_fun           = function that returns the residual error. Should
%                     be in the form of:
%
%                     Theta = man_fun(Theta, X)
%
%
% OUTPUT:
% E                 = error associated to each data element
% CS                = consensus set indicator vector


% AUTHOR:
% Marco Zuliani, email: marco.zuliani@gmail.com
% Copyright (C) 2009 by Marco Zuliani 
% 
% LICENSE:
% This toolbox is distributed under the terms of the GNU GPL.
% Please refer to the files COPYING.txt for more information.


% HISTORY:
%
% 1.0.0             - ??/??/06 - Initial version

% calculate the errors over the entire data set
E = feval(man_fun, Theta_hat, X, [], []);

% find the points within the error threshold
CS = (E <= T_noise_squared);

return