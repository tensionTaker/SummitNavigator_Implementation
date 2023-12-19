imgName = "NoisedData.png";

Histogram(imgName)
InitialPeaks()
PeakSearching()
PeakMerging(20)
score = ThresholdingSyn(imgName);
display(score)
