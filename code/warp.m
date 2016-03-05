function warped = warp(img, img_pts, morphed_im_pts, tri)
    warped = img;
    num_triangles = size(tri, 1);
    affineMatrices = zeros(3,3,num_triangles);
    for i = 1:num_triangles
       affineMatrices(:, :, i) = computeAffine(img_pts(tri(i,:),:), morphed_im_pts(tri(i, :),:));
    end
    [h, w, d] = size(warped);
    [y, x] = meshgrid(1:h, 1:w);
    
    T = mytsearch(morphed_im_pts(:,1), morphed_im_pts(:, 2), tri, x(:), y(:));
    invalidTs = isnan(T);
    validTs = ~invalidTs;
    x_valid = x(validTs);
    y_valid = y(validTs);

    for i = 1:num_triangles
        triangle_indices = find(T(validTs) == i);
        morph_pts_mat = [x_valid(triangle_indices) y_valid(triangle_indices) ones(size(triangle_indices, 1), 1)]';
        a_inv_mat = pinv(affineMatrices(:,:,i));
        orig_points = floor(a_inv_mat * morph_pts_mat);
        
        [orig_points, morph_pts_mat] = clean_points(w, h, orig_points, morph_pts_mat);
        
        morph_index = sub2ind([h, w], morph_pts_mat(2, :), morph_pts_mat(1, :));
        orig_index = sub2ind([h, w], orig_points(2, :), orig_points(1, :));
        
        warped(morph_index) = img(orig_index);
        if d == 3
            warped(morph_index + w*h) = img(orig_index + w*h);
            warped(morph_index + 2 * w* h) = img(orig_index + 2*w*h);
    end
end