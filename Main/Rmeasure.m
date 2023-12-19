data2 = load('SmoothedDataPointsOfImage.txt');

x = data2(:, 1); %all available intensity
y = data2(:, 2); %pixel count corresponding to I

% Read vk values from the file
vk_file_name = 'PeakDetected.txt'; % Replace with the actual file name
vk_file = load(vk_file_name);% contain 1 row and n column
vk = vk_file(:, 1);
vk = vk';

for i = 1:length(vk)-1
    disp(['Pair ', num2str(i), ': ', num2str(vk(i)),' ',num2str(vk(i+1))]);
    % i have to call some function here
    vk_index=find(x == (vk(i)));
    vk_1_index=find(x ==vk(i+1));
    ya_b = y(vk_index(1):vk_1_index(1));
    xa_b = x(vk_index(1):vk_1_index(1));
    %disp('ya_b:');
    %disp(ya_b);
    coefficients = polyfit(xa_b,ya_b, 1);
    % Predicted values using the fitted model
    y_pred = polyval(coefficients,xa_b);
    yk = mean(y_pred);
    
    rsquare_value = calculateRsquare(ya_b,y_pred,yk);
    
    % Display the result
    disp(['R-square value: ', num2str(rsquare_value*100),'%']);
end

%Code Testing
%vk_index=find(x == vk(1));
%disp(['vki: ', num2str(vk_index(1))]);
%disp(x)

function rsquare = calculateRsquare(ya_b, y_pred,yk)
    havg = mean(ya_b);
    numerator = sum((ya_b -y_pred).^2);
    %disp(['numerator: ', num2str(numerator)]);
    %Calculate the denominator: sum((hi - havg)^2)
    
    denominator = sum((ya_b - havg).^2);
    %disp(['denominator: ', num2str(denominator)]);
    %disp(['havg: ', num2str(havg),' yk: ', num2str(yk)]);

    % Calculate R-square using the formula
    rsquare = 1 - (numerator / denominator);
end