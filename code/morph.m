function morphed_im = morph(im1, im2, im1_pts, im2_pts, tri, warp_frac, dissolve_frac)
    % produces a warp between im1 and im2 using point correspondences
    % defined in im1_pts and im2_pts and triangulation structure tri.
    % warp_frac and dissolve_frac control shape warping and cross-disolve
    % im1 and im2 are warped into an intermediate shape configuration
    % controlled by warp_frac and then cross-dissolved according to
    % dissolve_frac
    if warp_frac == 0
        morphed_im_pts = im1_pts;
    elseif warp_frac == 1
        morphed_im_pts = im2_pts;
    else
        morphed_im_pts = (1 - warp_frac) * im1_pts + (warp_frac) * im2_pts;
    end
    
    if dissolve_frac == 0
        img1_warp = warp(im1, im1_pts, morphed_im_pts, tri);
        morphed_im = img1_warp;
    elseif dissolve_frac == 1
        img2_warp = warp(im2, im2_pts, morphed_im_pts, tri);
        morphed_im = img2_warp;
    else
        img1_warp = warp(im1, im1_pts, morphed_im_pts, tri);
        img2_warp = warp(im2, im2_pts, morphed_im_pts, tri);
        morphed_im = (1 - dissolve_frac) * img1_warp + dissolve_frac * img2_warp;
    end
end