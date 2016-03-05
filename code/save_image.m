function nothing = save_image(filename, folder, img, save)
    if save
       file_location = strcat(folder, filename);
       imwrite(img, file_location);
    end
end