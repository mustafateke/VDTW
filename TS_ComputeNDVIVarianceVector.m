function means = TS_ComputeNDVIVarianceVector(samples, labels)

global ProductNames;
global L8Product;
init
init_CKS

[Classes] = unique(labels);



for class = 1:size(Classes, 1)
    
    figure
hold on
grid on
    signatures = samples( labels == Classes(class), : ); 
    numDays = size(samples, 2);
    meanSignature = mean(signatures);
    medianSignature = median(signatures);
    if(size(signatures,1) > 1)
        medians(:,class) = medianSignature;
    else
        medians(:,class) = signatures;
    end
    
    plot(1:numDays,signatures, 'Color', tempcolormap(Classes(class)+1, :)); 
    
    if( size(signatures, 1) > 1)
        meanSignature = mean(signatures);
        medianSignature = median(signatures);
    else
        meanSignature = (signatures);
        medianSignature = (signatures);
    end
    
    means(:,class) = meanSignature;

    title( ProductNames( Classes(class) ) )

    ylabel('Vegetation Index');
    hold off
    
end
hold off

figure('Position', [50 50 800 600])
hold on
grid on
for class = 1:size(Classes, 1)
    
    curMedian = medians(:,class);
    plot(curMedian, 'Color', tempcolormap(Classes(class) + 1, :), 'LineWidth',2, 'Marker', 'o')
    
    legends(class) = ProductNames( Classes(class) );
    
    ProductNames( Classes(class) )
    
end
hold off
legend( legends, 'Location', 'north', 'Orientation', 'horizontal','FontSize',8)
xlabel('Day of Year');
ylabel(L8Product);


end