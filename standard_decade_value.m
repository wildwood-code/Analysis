function value = standard_decade_value(value, varargin)
% STANDARD_DECADE_VALUE Standard decade electronic component value
%   value = STANDARD_DECADE_VALUE(value, flags, ...)
%
%   generates a standard decade resistance/capacitance value that is close
%   to the specified value.
%
%   value=standard_decade_value(value, flags)
%
%      value    value to convert (must be >= 0)
%      flags    specify which decade table and how to convert
%                    'E96' or '1%' specifies E96 decade table {default}
%                    'E24', '2%', or '5%' specifies E24 decade table
%                    'E12' or '10%' specifies E12 decade table
%               conversion:
%                    'near' specifies nearest value {default}
%                    'above' specifies closest >= value
%                    'below' specifies closest <= value
%
%   % Examples:
%   standard_decade_value(13.107e3, 'above')       % = 13300
%   standard_decade_value(231e-9, 'E24')           % = 240e-9
%   standard_decade_value(231e-9, 'E24', 'below')  % = 220e-9
%   standard_decade_value(0)                       % = 0
%
%   See also: SDV

% Kerry S. Martin, martin@wild-wood.net

if value<0
    error('input value cannot be negative');
elseif value==0
    return
end

E96 = [ 100 102 105 107 110 113 115 118 121 124 127 130 133 137 140 143 ...
        147 150 154 158 162 165 169 174 178 182 187 191 196 200 205 210 ...
        215 221 226 232 237 243 249 255 261 267 274 280 287 294 301 309 ...
        316 324 332 340 348 357 365 374 383 392 402 412 422 432 442 453 ...
        464 475 487 499 511 523 536 549 562 576 590 604 619 634 649 665 ...
        681 698 715 732 750 768 787 806 825 845 866 887 909 931 953 976 1000 ];

E24 = [ 100 110 120 130 150 160 180 200 220 240 270 300 ...
        330 360 390 430 470 510 560 620 680 750 820 910 1000 ];

E12 = [ 100 120 150 180 220 270 330 390 470 560 680 820 1000 ];

match = 0; % 0 = near, -1=below, 1=above
table = E96; % default

n = length(varargin);

if n>0
    for i=1:n
        arg = upper(varargin{i});
        
        switch arg
            case { '1%', 'E96' }
                table = E96;
            case { '2%', '5%', 'E24' }
                table = E24;
            case { '10%', 'E12' }
                table = E12;
            case { 'NEAR', 'NEAREST' }
                match = 0;
            case { 'ABOVE', 'HIGH', 'HIGHER', 'GREATER' }
                match = 1;
            case { 'BELOW', 'LOW', 'LOWER', 'LESSER' }
                match = -1;
            otherwise
                error('Do not understand ''%s''', varargin{i});
        end 
    end
end

vexp = floor(log10(value))-2;
vnorm = round(value / (10^vexp));

n = length(table);

is_exact = false;
idx_close = [];
diff_close = Inf;
vfind = [];

for i=1:n
    vt = table(i);
    diff = abs(vnorm-vt);
    if diff==0
        % found the exact value
        idx_close = i;
        vfind = vt;
        is_exact = true;
        break
    elseif diff<diff_close
        % getting closer, keep looking
        diff_close = diff;
        idx_close = i;
        vfind = vt;
    else
        % getting bigger, we must have passed it up
        break
    end
end

if is_exact || match==0
    % exact value was found, or we are looking for the closest
    value = vfind*(10^vexp);
elseif match==1
    % find the value above/larger
    idx_close = idx_close+1;
    if idx_close>n
        idx_close=1;
        vexp = vexp+1;
    end
    value = table(idx_close)*(10^vexp);
else
    % find the value below/smaller
    idx_close = idx_close-1;
    if idx_close<1
        idx_close=n;
        vexp = vexp-1;
    end
    value = table(idx_close)*(10^vexp);
end

