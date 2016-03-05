function [] = tri_plot(points, graph)
    if graph == true
        figure();
        triplot(points);
    end
end
