classdef otsuApplication < handle
    methods (Static)
        
        function displayBinaryOtsu(image)
            %global thresholding (good for objects that have uniform lighting changes)
            %converting intensity image to binary image using level threshold
            threshold = graythresh(image); %calculates threshold and normalizes it from range 0 to 1
            binaryImage = im2bw(image, threshold); %converts the image into a binary image given a threshold
            imshowpair(image, binaryImage, 'montage'); %montage displays A and B next to eachother in one image
        end
        
        %global thresholding 
        %calculating two thresholds
        function displayDoubleThresholdOtsu(image)
            threshold_levels = multithresh(image,2);
            seg_I = imquantize(image,threshold_levels);
            I = mat2gray(seg_I); 
            imshow(image);
            figure;
            imshowpair(I, [0 255]);
            axis off
            title('Two-Threshold Segmented Image')                      
        end
        
        function compareGlobalAndLocalThresholding(image)
            %comparing thresholding entire image versus local thresholding (good for images that have nonuniform lighting changes such as gradients)
            imshow(image)
            axis off
            title('Original Image');

            %generates 7 global thresholds
            global_thresholds = multithresh(image,7);
            
            %generates 7 thresholds per 3 colour planes (RGB)
            local_thresholds = zeros(3,7); %empty array
            
            for i = 1:3
            local_thresholds(i,:) = multithresh(image(:,:,i), 7); %image(:,:,1) represents all rows and all columns in the first image plane (red channel), green = 2, blue = 3
            end

            values = [0 global_thresholds(2:end) 255]; %array of possible pixel values based on the calculated thresholds; setting a min of 0 and max of 255
            globalThreshImage = imquantize(image, global_thresholds, values); %quantize converts from continuous to discrete. Can only have pixel values of "values"

            localThreshImage = zeros( size(image) ); %empty array same size as image

            %each plane of the image is quantized separately
            for i = 1:3
                value = [0 local_thresholds(i,2:end) 255]; %use 2 to end because number of values must be levels+1 = n+1 = 9
                localThreshImage(:,:,i) = imquantize(image(:,:,i),local_thresholds(i,:),value);
            end
            
            localThreshImage = uint8(localThreshImage); %can't have pixel values more than 255 = 2^8-1
            
            imshowpair(globalThreshImage, localThreshImage,'montage'); 
            axis off
            title('Full RGB Image Quantization        Plane-by-Plane Quantization')
        end
    end
end



