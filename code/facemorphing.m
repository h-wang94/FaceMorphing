%% setup boolean variables
graph = true;
save_img = false;
save_video = false;

%% setup images
images_folder = '../images/';
output_folder = '../output/';
img1_name = 'me.jpg';
img2_name = 'george.jpg';
img1 = im2double(imread(strcat(images_folder, img1_name)));
img2 = im2double(imread(strcat(images_folder, img2_name)));

%% display images
display_images(graph, img1, img2);

%% defining correspondences
% uncomment to manually select points
%     [img1_points, img2_points] = cpselect(img1, img2, 'Wait', true);
% comment if you want to select points
img1_points = load('im1_points.mat', 'img1_points');
img1_points = img1_points(1).img1_points;
img2_points = load('im2_points.mat', 'img2_points');
img2_points = img2_points(1).img2_points;

%% saving old points
if exist('im1_points.mat', 'file') ~= 2
    disp('Saved im1_points');
    save('im1_points.mat', 'img1_points');
end
if exist('im2_points.mat', 'file') ~= 2
    disp('Saved im2_points');
    save('im2_points.mat', 'img2_points');
end

%% get triangulation
mean_points = (img1_points + img2_points) * 0.5;
tri = delaunayTriangulation(mean_points);
tri_plot(tri, graph);

%% run halfway image
warp_frac = 0.5;
dissolve_frac = 0.5;
morphed_im = morph(img1, img2, img1_points, img2_points, tri, warp_frac, dissolve_frac);
display_images(graph, morphed_im);
save_image('midway_harrison_george.jpg', output_folder, morphed_im, save_img);

%% setup video

nFrames = 45;
vid_name = 'harrison_george.avi';
filename = strcat(output_folder, vid_name);
vidObj = VideoWriter(filename);
vidObj.Quality = 100;
vidObj.FrameRate = 45/1.5;
%% save the video 
if save_video == true
    open(vidObj);
    for n = linspace(0,1,nFrames)
        disp(n)
        if n == 0
            morphed_im = img1;
        elseif n == 1
            morphed_im = img2;
        else
            morphed_im = morph(img1, img2, img1_points, img2_points, tri, n, n);
        end
        writeVideo(vidObj, morphed_im);
    end
    close(vidObj);
end