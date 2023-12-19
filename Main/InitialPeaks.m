%Load dataset from text file
function InitialPeaks()
data = load('imageDataPoints.txt'); % Assuming tab-delimited file

% Extracting relevant columns
intensities = data(:, 1);
pixel_counts = data(:, 2);

n = size(intensities, 1);

% Apply the moving average filter to pixel_counts
% Condering padding of zero

smoothed_pixel_counts = zeros(n, 1);
smoothed_pixel_counts(1,1) = pixel_counts(1,1) + pixel_counts(2,1) / 3;
smoothed_pixel_counts(end,1) = pixel_counts(end,1) + pixel_counts(end-1,1) / 3;
for i = 2:n-1
    smoothed_pixel_counts(i,1) = (pixel_counts(i-1,1) + pixel_counts(i,1) + pixel_counts(i+1,1)) / 3;
end

initialPeaks = [];

% Find initial peaks

if smoothed_pixel_counts(1, 1) > smoothed_pixel_counts(2, 1)
    initialPeaks = [initialPeaks, intensities(1, 1)];
end
for j=2:n-1
    if ((smoothed_pixel_counts(j,1) > smoothed_pixel_counts(j+1,1)) && (smoothed_pixel_counts(j,1) > smoothed_pixel_counts(j-1,1)))
        initialPeaks = [initialPeaks, intensities(j, 1)];
    end
end
if smoothed_pixel_counts(n,1) > smoothed_pixel_counts(n-1, 1)
    initialPeaks = [initialPeaks, intensities(n, 1)];
end

numberInitialPeaks = length(initialPeaks);

fileID = fopen('InitialPeaksofImage.txt', 'w');

% Write data to the file using fprintf
for m = 1:numberInitialPeaks
    fprintf(fileID, '%d\n', initialPeaks(m));
end

% Close the file
fclose(fileID);

fileID = fopen('SmoothedDataPointsOfImage.txt', 'w');

% Write data to the file using fprintf
for p = 1:n
    fprintf(fileID, '%d\t%f\n', intensities(p, 1), smoothed_pixel_counts(p, 1));
end
% Close the file
fclose(fileID);
%LocationInitialPeaks = double(initialPeaks);
%SmoothedDataImg = [double(intensities), double(smoothed_pixel_counts)];
end