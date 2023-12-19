function score = Thresholding(imgName, ThG)
%initialImageData = Histogram('238011.jpg');
%[Lip, data2] = InitialPeaks(initialImageData);
%peaksLocation = PeakDetection(Lip, data2);
%Thresholding Code
data1 = load("PeakMerged.txt");
data2 = load("SmoothedDataPointsOfImage.txt");
%imgName = "23025.jpg";

I = data2(:, 1);
pCount = data2(:, 2);
peaksLocation = data1(1, :);
peaksLocation = peaksLocation';


nPeaks = length(peaksLocation);
Th = [];

for q=1:(nPeaks - 1)
    index = ItoIndex(peaksLocation(q), I);
    finalIndex = ItoIndex(peaksLocation(q+1), I);
    mini = min(pCount(index:finalIndex));
    [t, ~] = find(mini == pCount);  
    Th = [Th, I(t(round(end/2)))]; 
end

% Reason for difference 
% There are multiple location at which minimum occurs
% authors might be taking a different one    
% and we are taking location in the
% middle
% say minimum occurs at [L1, L2, L3]
% authors might be taking L1 or L3 we
% are taking L2

imgP = imread(imgName);
imgGd = imread(imgName);
img = imread(imgName);
imgThresholded = imread(imgName);

imgGd = rgb2gray(imgGd);
imgP = rgb2gray(imgP);
img = rgb2gray(img);
imgThresholded = rgb2gray(imgThresholded);

[m,n] = size(img);
nTh = size(Th, 2);             

%Generating image that is threholded and better visualisation
for r=1:m
    for k=1:n
         for z=1:nTh
                if(z == 1)
                    if(img(r,k) < Th(z))
                        imgThresholded(r, k) = 0;
                    end
                else
                    if(img(r, k) < Th(z) && img(r,k) >= Th(z-1))
                        imgThresholded(r, k) = round((Th(z) + Th(z-1)) / 2);
                    end
                end
                if(z == nTh)
                    if(img(r, k) >= Th(z))
                        imgThresholded(r, k) = 255;
                    end
                end
        end
    end
end

%For generating the labelled image representing classes
for r=1:m
    for k=1:n
         for z=1:nTh
                if(z == 1)
                    if(img(r,k) < Th(z))
                        imgP(r, k) = 0;
                    end
                else
                    if(img(r, k) < Th(z) && img(r,k) >= Th(z-1))
                        imgP(r, k) =  z - 1;
                    end
                end
                if(z == nTh)
                    if(img(r, k) >= Th(z))
                         imgP(r, k) = z;
                    end
                end
        end
    end
end

% For Ground Thruth
nThG = size(ThG, 2);
imgx = img;
for r=1:m
    for k=1:n
         for z=1:nThG
                if(z == 1)
                    if(imgx(r,k) < ThG(z))
                        imgGd(r, k) = 0;
                    end
                else
                    if(imgx(r, k) < ThG(z) && imgx(r,k) >= ThG(z-1))
                        imgGd(r, k) =  z - 1;
                    end
                end
                if(z == nThG)
                    if(imgx(r, k) >= ThG(z))
                        imgGd(r, k) = z;
                    end
                end
        end
    end
end

%numColors = 256;
%yellowBlueColormap = [linspace(1, 0.8, numColors)', linspace(1, 0.8, numColors)', linspace(0, 1, numColors)'];
%colormap(yellowBlueColormap);
%labelsRGB = label2rgb(img, colormap);
%imshow(img)
%figure

imshow(imgThresholded,colormap(jet(m)));
score = Fmeasure(imgGd, imgP);
end

function index = ItoIndex(intensity, I)
    [row, ~] = find(I == intensity);
    index = row;
end