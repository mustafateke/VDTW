function result=getRandomElements(labels, elementNumber)
addpath('PPI')
[Classes] = unique(labels);
numClasses = size(Classes,1);
result = zeros(size(labels));

for class = 1:numClasses
    [rownumbers colnumbers val] = find(labels == Classes(class) );
    numElements = size(val,1);
    % elementNumberx1'lik random eleman
%     rng(1);
    r = randi(numElements,elementNumber,1);
    for i=1:elementNumber
        result(rownumbers(r(i)), :) = labels(rownumbers(r(i)), :);
    end
    
end

end