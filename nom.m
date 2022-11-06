function vnom=nom(val)
% NOM Nominal value of argument
%   vnom=NOM(val)
%     if val is a scalar, it just produces that value
%     otherwise it produces the median of val
%     for a value in the form [min nom max] it will always produce the
%     'nom' which is the median value
%     for a value in the for [min max] it will produce the mean value
%
%  See also: MIN, MAX, TOLTC

narginchk(1,1)

if isscalar(val)
    vnom = val;
elseif length(val)==3
    vnom = median(val);  % possibly [min nom max] format
end