%% setup boolean variables
graph = true;
save_img = false;

%% setup images
images_folder = '../images/';
population_folder = '../images/population/';
points_folder = '../points/';
output_folder = '../output/';
img1_name = 'me_gray_scaled.jpg';
img1 = im2double(imread(strcat(images_folder, img1_name)));
%%
images_regex = strcat(population_folder, '*.jpg');
pts_regex = strcat(points_folder, '*.pts');
files = dir(images_regex);
pts_files = dir(pts_regex);
images = cell(1,size(files, 1));
pts = zeros(400, 46, 2);
for i = 1:size(files)
    imgname = strcat(population_folder, files(i).name);
    images{i} = im2double(imread(imgname));
    FileId = fopen(strcat(points_folder, pts_files(i).name));
    npoints = textscan(FileId,'%s %f',1,'HeaderLines',1);
    points=  textscan(FileId,'%f %f',npoints{2},'MultipleDelimsAsOne',2,'Headerlines',2);
    pts(i, :, :) = cell2mat(points);
end

%% compute average of points
num_faces = size(pts, 1);
avg_facepoints = sum(pts, 1);
avg_facepoints = reshape(avg_facepoints, size(pts, 2), size(pts, 3));
avg_facepoints = avg_facepoints / num_faces;
% get triangulation
tri = delaunayTriangulation(avg_facepoints);
tri_plot(tri, graph);

%%
avg_morphs = zeros(num_faces, size(images{1}, 1), size(images{1}, 2));
for i = 1:num_faces
    morphed = morph(images{i}, images{i}, reshape(pts(i,:,:), size(pts, 2), size(pts, 3)), avg_facepoints, tri, 1, 0);
    avg_morphs(i, :, :) = morphed;
end

%%
if save_img
    for i = 1:2:5
        filename = strcat(output_folder, int2str(i), '_', 'avg_morph.jpg');
        avg_morph_img = reshape(avg_morphs(i, :, :), size(morphed, 1), size(morphed, 2));
        imwrite(avg_morph_img, filename);
    end
end

%% calculate average face
avg_face = sum(avg_morphs, 1);
avg_face = reshape(avg_face, size(avg_morphs, 2), size(avg_morphs, 3));
avg_face = avg_face / num_faces;
display_images(graph, avg_face);
save_image('avg_population.jpg', output_folder, avg_face, save_img);

%% warp my face into geometry

% uncomment the line below to select new points.
%[my_points, avg_points] = cpselect(img1, avg_face, 'Wait', true);

% comment these lines to load old points. default to just load old points
my_points = load('my_points.mat', 'my_points');
my_points = my_points(1).my_points;
avg_points = load('avg_points.mat', 'avg_points');
avg_points = avg_points(1).avg_points;
%% saving old points
if exist('my_points.mat', 'file') ~= 2
    disp('Saved my_points');
    save('my_points.mat', 'my_points');
end
if exist('avg_points.mat', 'file') ~= 2
    disp('Saved avg_points');
    save('avg_points.mat', 'avg_points');
end

%% get triangulation for population & me
mean_points = (my_points + avg_points) * 0.5;
tri_avg = delaunayTriangulation(mean_points);
tri_plot(tri_avg, graph);

%% morph into population geometry & vice versa
me_avg_geometry = morph(img1, img1, my_points, avg_points, tri_avg, 1, 0);
save_image('me_avg_geometry.jpg', output_folder, me_avg_geometry, save_img);
avg_geometry_me = morph(avg_face, avg_face, avg_points, my_points, tri_avg, 1, 0);
save_image('avg_geometry_me.jpg', output_folder, avg_geometry_me, save_img);
display_images(graph, me_avg_geometry, avg_geometry_me);
%% caricatures
warp_frac = 2.5;
me_caricature = morph(img1, img1, my_points, avg_points, tri_avg, warp_frac, 0);
save_image(strcat(num2str(warp_frac),  '_', 'me_caricature.jpg'), output_folder, me_caricature, save_img);
display_images(graph, me_caricature);

%% changing gender
img2_filename =  'me_cropped.jpg';
img2 = im2double(imread(strcat(images_folder, img2_filename)));
female_image_name = 'average_chinese_actress_cropped.jpg';
female_image = im2double(imread(strcat(images_folder, female_image_name)));

%% select points for changing gender
% uncomment the line below to select new points.
%[my_female_points, avg_female_points] = cpselect(img2, female_image, 'Wait', true);

% comment these lines to load old points. default to just load old points
 my_female_points = load('my_female_points.mat', 'my_female_points');
 my_female_points = my_female_points(1).my_female_points;
 avg_female_points = load('avg_female_points.mat', 'avg_female_points');
 avg_female_points = avg_female_points(1).avg_female_points;

%% save gender change points
if exist('my_female_points.mat', 'file') ~= 2
    disp('Saved my_female_points');
    save('my_female_points.mat', 'my_female_points');
end
if exist('avg_female_points.mat', 'file') ~= 2
    disp('Saved avg_female_oints');
    save('avg_female_points.mat', 'avg_female_points');
end
%% get triangulation for avg_female & me
mean_female_points = (my_female_points + avg_female_points) * 0.5;
tri_female = delaunayTriangulation(mean_female_points);
tri_plot(tri_female, graph);

%% me to avg_female and avg_female to me
me_avg_female = morph(img2, img2, my_female_points, mean_female_points, tri_female, 1, 0);
save_image('me_avg_female.jpg', output_folder, me_avg_female, save_img);

    
warp_appearance = morph(img2, female_image, my_female_points, avg_female_points, tri_female, 0, 0.5);
save_image('warp_appearance.jpg', output_folder, warp_appearance, save_img);
display_images(graph, me_avg_female, warp_appearance);
%% final image

final = morph(img2, female_image, my_female_points, avg_female_points, tri_female, 1, 0.5);
save_image('final_female_me.jpg', output_folder, final, save_img);
display_images(graph, final);