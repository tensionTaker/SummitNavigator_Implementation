function PeakMerging(Rsquare_in)
data = load('SmoothedDataPointsOfImage.txt');% Read data from the file

x = data(:, 1); %all available intensity
y = data(:, 2); %pixel count corresponding to I

% Read vk values from the file
vk_file_name = 'PeakDetected.txt'; %Peak seached result file
vk_file = load(vk_file_name);% contain 1 row and n column
vk = vk_file(:, 1);
vk = vk';

% Display the Peak Seaching vk values
disp('Final Peak Seaching vk values:');
disp(vk_file);
r_threshold=Rsquare_in;%Change it according to your image
flag=1;
times=1;
while flag==1
    disp(['Running: ', num2str(times)]);
    times=times+1;
    flag=0;
    temp=[];
    for i = 1:length(vk)-1
        disp(['Pair ', num2str(i), ': ', num2str(vk(i)),' ',num2str(vk(i+1))]);
        vk_index=find(x == (vk(i)));
        vk_1_index=find(x ==vk(i+1));
        ya_b = y(vk_index(1):vk_1_index(1));
        xa_b = x(vk_index(1):vk_1_index(1));
        coefficients = polyfit(xa_b,ya_b, 1);
        % Predicted values using the fitted model
        y_pred = polyval(coefficients,xa_b);
        rsquare_value = calculateRsquare(ya_b,y_pred)*100;
        disp(['R-square value: ', num2str(rsquare_value),'%']);
        if (rsquare_value > r_threshold) && ((i > 2 && y(vk_index) < y(find(x == vk(i-1), 1))) || (y(vk_index) < y(find(x == vk(i+1), 1))))
            flag = 1;
        else
            temp = [temp, vk(i)];
        end

    end
    temp = [temp, vk(length(vk))];
    vk=temp;
end

disp('Final vk values after peak merging:');
disp(vk);% contain 1 row and n column
%dlmwrite('PeakMerged238011.txt', vk);
dlmwrite('PeakMerged.txt', vk);
end

function rsquare = calculateRsquare(ya_b, y_pred)
    havg = mean(ya_b);
    numerator = sum((ya_b -y_pred).^2);
    denominator = sum((ya_b - havg).^2);
    rsquare = 1 - (numerator / denominator);
end