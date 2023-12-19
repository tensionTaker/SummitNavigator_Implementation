imgName = "238011.jpg";%image name

Histogram(imgName)
InitialPeaks()
PeakSearching()
PeakMerging(86) %(R_k square value to be entered)
score = Thresholding(imgName, [54, 180]); %(image name, ground truth threshold)
display(score,'F-measure, precision (p), recall (r) ')