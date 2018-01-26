function threshold = otsu(histogramCounts) %function returns the threshold and takes in a 256-element histogram of a grayscale image
	total = sum(histogramCounts); % total = number of pixels in the image
	sumB = 0;
	wB = 0; %weight of background
	totalSum = dot(0:255, histogramCounts); %total weighted sum
	max = 0.0; %max between-class variance

	for i = 1:256
		wB = wB + histogramCounts(i); %weight background; keep adding the # of pixels in each intensity 
		wF = total - wB; %weight foreground;
		if (wB == 0 | wF == 0)
			continue; %meaning skip the rest of the steps, go on to next intensity level
		end
		sumB = sumB + (i-1)*histogramCounts(i); %weighted sum to find average intensity; i-1 because we want to start with intensity of 0
		sumF = totalSum - sumB; %foreground weighted sum 
		meanB = sumB / wB;
		meanF = sumF / wF;
		betweenVar = wB * wF * (meanB - meanF) * (meanB - meanF); %given formula
        %betweenVar = (wB/total) * (wF/total) * (meanB - meanF) * (meanB - meanF);
		if (betweenVar > max)
		max = betweenVar;
		threshold = i;
		end
	end
end

%another option is to minimize the within-class variance which is wB*varB^2 + wF*varF^2;
