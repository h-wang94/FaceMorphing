function [varargout] = clean_points(w, h, varargin)
    points = varargin{1};
    indexes = (points(1, :) > 0 & points(1, :) <= w & points(2,:) > 0 & points(2, :) <= h);
    varargout=cell(1, length(varargin));
    for i = 1:length(varargin)
        pts = varargin{i};
        varargout{i} = pts(:, indexes);
    end
end