%image = eighty8;
image = ninety7;
imshow(ninety7,[]);
%connectedComponentAnalysis.fastMultiThresh(image, 8);
%connectedComponentAnalysis.labelBWObjects(image);
%connectedComponentAnalysis.findBWCentroids(image);
connectedComponentAnalysis.fastMultiThresh(image, 9);