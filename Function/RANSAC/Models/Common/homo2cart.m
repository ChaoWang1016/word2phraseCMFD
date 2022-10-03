function Q_cart = homo2cart(Q_homo)

% Q_cart = homo2cart(Q_homo)
%
% DESC:
% converts from cartesian coordinates to homegeneous ones
%
% VERSION:
% 1.0.0
% 
% INPUT:
% Q_homo		= homogeneous coordinates of the points
%
% OUTPUT:
% Q_cart		= cartesian coordinates of the points


% AUTHOR:
% Marco Zuliani, email: marco.zuliani@gmail.com
% Copyright (C) 2009 by Marco Zuliani 
% 
% LICENSE:
% This toolbox is distributed under the terms of the GNU GPL.
% Please refer to the files COPYING.txt for more information.



% HISTORY
% 1.0.0         - ??/??/01 - Initial version

l = size(Q_homo, 1);

% check if point or vector
if Q_homo(l) == 0
   Q_homo(l) = 1;
end;

Q_cart = Q_homo(1:l - 1, :)./repmat(Q_homo(l, :), [l-1, 1]);

return;