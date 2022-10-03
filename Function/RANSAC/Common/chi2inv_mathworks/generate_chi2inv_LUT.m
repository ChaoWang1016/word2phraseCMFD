% NAME:
% generate_chi2inv_LUT
%
% DESC:
% generates a look up table for the chi2inv function


% AUTHOR:
% Marco Zuliani, email: marco.zuliani@gmail.com
% Copyright (C) 2009 by Marco Zuliani 
% 
% LICENSE:
% This toolbox is distributed under the terms of the GNU GPL.
% Please refer to the files COPYING.txt for more information.


clear 
close all
clc

% parameter range
v_LUT = 1:8;
p_LUT = linspace(0.5, 1-eps, 512);

x_LUT = zeros(length(p_LUT), length(v_LUT));
for h = 1:length(p_LUT)
    for k = 1:length(v_LUT)
        x_LUT(h, k) = chi2inv(p_LUT(h), v_LUT(k));
    end;
end;

save chi2inv_LUT p_LUT v_LUT x_LUT