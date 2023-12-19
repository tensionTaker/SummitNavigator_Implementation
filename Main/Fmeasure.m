
function  measure = Fmeasure(imgGT, imgT)
    [m,n] = size(imgGT);

    intensity_valuesGround = imgGT(:); 
    [unique_intensitiesGround, ~, ~] = unique(intensity_valuesGround);  % unique_intensities is coloumn vector
    
    nClasses = size(unique_intensitiesGround, 1);

    tp = zeros(nClasses, 1);
    fn = zeros(nClasses, 1);
    fp = zeros(nClasses, 1);
    tn = zeros(nClasses, 1);

    for i=1:m
        for j=1:n
            for k=1:nClasses
                  if(imgGT(i,j) == unique_intensitiesGround(k,1) && imgT(i,j) == unique_intensitiesGround(k,1))
                      tp(k, 1) = tp(k, 1) + 1;
                  elseif(imgGT(i,j) ~= unique_intensitiesGround(k,1) && imgT(i,j) == unique_intensitiesGround(k,1))
                      fp(k, 1) = fp(k, 1) + 1;
                  elseif(imgGT(i,j) ~= unique_intensitiesGround(k,1) && imgT(i,j) ~= unique_intensitiesGround(k, 1))
                      tn(k, 1) = tn(k, 1) + 1;
                  else
                      fn(k, 1) = fn(k, 1) + 1;
                  end
            end
        end
    end

    p = zeros(nClasses,1);
    r = zeros(nClasses,1);
    F = zeros(nClasses,1);

    pm = 0;
    rm = 0;

    for q=1:nClasses
        p(k, 1) = tp(q, 1) / (tp(q, 1) + fp(q, 1));
        r(k, 1) = tp(q, 1) / (tp(q, 1) + fn(q, 1));
        F(q, 1) =  (2*p(k, 1)*r(k, 1)) / (p(k,1) + r(k,1));
        pm = pm + p(k, 1);
        rm = rm + r(k, 1);
    end
    pm = pm/nClasses;
    rm = rm/nClasses;
    fm = (2*pm*rm)/(pm + rm);
    measure = [fm, pm, rm];
end
%score = bfscore(imageResultName, imageGroundTruth);

    