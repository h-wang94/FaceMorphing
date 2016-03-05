function affine_matrix = computeAffine(tri1_pts, tri2_pts)
    one = ones(3, 1);
    x_1 = [tri1_pts one]';
    x_2 = [tri2_pts one]';
    affine_matrix = x_2 * pinv(x_1);
    affine_matrix(3,:,:) = [0 0 1];
end