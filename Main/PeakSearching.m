function PeakSearching()
data1 = load('InitialPeaksofImage.txt');
data2 = load('SmoothedDataPointsOfImage.txt');

S = data1(:, 1); %Location of initial peaks
%S = int8(S');
I = data2(:, 1); %all available intensity
H = data2(:, 2); %pixel count corresponding to I

h = []; %Value of initial peaks

noOfinitialPeaks = size(S, 1);

for b=1:noOfinitialPeaks
    pCount = pCountToI(S(b, 1), I, H);
    h = [h, pCount];
end

P = size(S);    %Number of initial peaks

L_k = [];

L_tmp = [];
 
for k = 2:P
    s_k = S(k); % Location of kth initial peak
    h_s_k = h(k); %value at s_k 
    x_k = s_k*ones(1, k-1); %[s_k s_k ..........s_k]
    y_k = h_s_k*ones(1, k-1); %[h_s_k h_s_k ..........h_s_k]
    deltaX_k = x_k - s_1_to_k_1(S,k);
    deltaY_k = [];
    for j=1:k-1
        if(h_s_k ~= h(j))
            deltaY_k = [deltaY_k, (h_s_k - h(j))];
        else
            deltaY_k = [deltaY_k, 0.0000001];

        end
    end
    temp = y_k .* (deltaX_k);
    temp2 = temp ./ deltaY_k;
    L_k = x_k - temp2;
    L_tmp = [L_tmp, min(L_k)];
end

L_s = min(L_tmp);    % Best Observing location

Y_p = hs_1_to_k_1(h,P+1);
X_p = s_1_to_k_1(S,P+1);

L_star =[];

for i=1:P
    L_star = [L_star, L_s];
end

C = Y_p ./ (X_p - L_star);
l = size(C);
V = [];

for i=2:P-1
    if (C(i) > C(i-1)) && (C(i) > C(i+1))
        V = [V, S(i)];
    end
end

if C(1)>C(2)
    V = [S(1)  V];
end

if C(end) > C(end - 1)
    V = [V S(length(C))];
end

%dlmwrite('PeakDetectedSunspot.txt', V);

fileID = fopen('PeakDetected.txt', 'w');
z = length(V);
for t = 1:z
    fprintf(fileID, '%d\n', V(1, t));
end
fclose(fileID);
%peaksDetected = V;
end

function sks = s_1_to_k_1(S, k)
    sks = [];
    for i=1:k-1
        sks = [sks, S(i)];
    end
end

function hsks = hs_1_to_k_1(h, k)
    hsks = [];
    for i=1:k-1
        hsks = [hsks, h(i)];
    end
end

function pCount = pCountToI(intensity, I, H)
    [row, ~] = find(I == intensity);
    pCount = H(row, 1);
end