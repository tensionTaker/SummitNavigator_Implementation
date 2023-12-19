function Histogram(imagePath)
%imagePath = '23025.jpg';
img = imread(imagePath);

img = rgb2gray(img);
intensity_values = img(:); % Coloumn Vector
[unique_intensities, ~, ~] = unique(intensity_values);  % unique_intensities is coloumn vector

n = size(unique_intensities, 1);
m = size(intensity_values, 1);

pixel_count = zeros(n, 1);  % Coloumn vector

for i=1:n
    for j=1:m
        if(unique_intensities(i, 1) == intensity_values(j, 1))
            pixel_count(i, 1) = pixel_count(i, 1) + 1;
        end
    end
end

fileID = fopen('imageDataPoints.txt', 'w');

% Write data to the file using fprintf
for i = 1:n
    fprintf(fileID, '%d\t%d\n', unique_intensities(i, 1), pixel_count(i, 1));
end

% Close the file
fclose(fileID);

histogram(img, 'BinWidth', 0.5, 'EdgeColor', 'b');

%ImageData = [unique_intensities, pixel_count];

end