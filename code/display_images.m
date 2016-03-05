function [] = display_images(display, varargin)
    if display == true
        number_images = nargin-1;
        if number_images == 1
            figure();
            imshow(varargin{1});
            
        else
            figure_x = number_images/2;
            figure();
            for i = 1:number_images
                subplot(figure_x, 2, i)
                imshow(varargin{i})
            end
            
        end
    end
end