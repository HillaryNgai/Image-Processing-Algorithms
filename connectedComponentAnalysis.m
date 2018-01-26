classdef connectedComponentAnalysis < handle
    methods (Static)
        
        function labelBWObjects(image)
            threshold = graythresh(image);
            binaryImage = im2bw(image, threshold);
            ccImage = bwlabel(binaryImage); %creates labelled image 1,2,3...etc.
            CC = bwconncomp(binaryImage)
            imshow(ccImage, []);
        end
        
        function findBWCentroids(image) %image should ideally be BW
            threshold = graythresh(image);
            binaryImage = im2bw(image, threshold);
            ccImage = bwlabel(binaryImage); %creates labelled image 1,2,3...etc.

            s = regionprops(ccImage,'centroid'); %struct array containing centroids
            centroids = cat(1, s.Centroid) %concatenate the arrays into one matrix

            imshow(image, []);
            hold on
            plot(centroids(:,1),centroids(:,2), 'b*'); %row1 = x-axis, row2 = y-axis
            hold off
        end
        
        function fastMultiThresh(image, numOfClasses)
            m = numOfClasses; %number of classes, number of thresholds is M-1
            L = 255;
            image = uint8(L * mat2gray(image)); %normalize image to 0-255 scale
            [counts, binLocations] = imhist(image);
            p = zeros([L, L]);
            s = zeros([L, L]);

            pCounts = counts/sum(counts); %calculate probability histogram

            %u = row, v = column
            for u = 1:L 
                p(u, u) = pCounts(u);
                s(u, u) = u*pCounts(u);
                for v = 1:L-1    
                    if v >= u
                        p(u, v+1) = p(u, v) + pCounts(v+1);
                        s(u, v+1) = s(u, v) + v*pCounts(v+1);
                    end 
                end
            end

            t1 = 1;
            t2 = L-m+1;
            thresholds = [];

            for i = 1:m-1
                max = 0;
                for temp = t1:t2   
                    h1 = s(t1+1, temp)*s(t1+1, temp)/p(t1+1, temp);
                    h2 = s(temp+1, t2)*s(temp+1, t2)/p(temp+1, t2);
                    h = h1 + h2;

                    if h > max
                       max = h;
                       thresh = temp;
                    end
                end 
                thresholds(i) = thresh;
                t1 = thresh + 1;
                t2 = t2 + 1;
            end

            thresholds 
        end
    end
end



