function [endMemberLabelsTr, endMembersTr, endMemberLabelsTest, endMembersTest]=GetEndmembers(method, samples, labels, numElements, k)

endMembersTr = [];
endMemberLabelsTr = [];
endMemberLabelsTest = [];
endMembersTest = [];
trDataSubT = samples';
[Classes] = unique(labels);
numClasses = size(Classes,1);
%% Random
if (strcmp( method , 'random') )
    endMemberLabelsTemp = getRandomElements(labels, numElements);
    endMemberLabelsTr= endMemberLabelsTemp(endMemberLabelsTemp>0);
    endMembersTr = samples(endMemberLabelsTemp > 0, :);
    %% MDPPI
elseif (strcmp(method ,'median') )
    for class = 1:numClasses
        
        tEndMembers = [];
        tEndMemberLabels = [];
        
        medianValue = median(samples (labels == Classes(class), :));
        endMembersTr (class, :)  = medianValue;
        endMemberLabelsTr(class, 1) = Classes(class);
        
    end
elseif (strcmp(method ,'mean') )
    for class = 1:numClasses
        
        tEndMembers = [];
        tEndMemberLabels = [];
        
        medianValue = mean(samples (labels == Classes(class), :));
        endMembersTr (class, :)  = medianValue;
        endMemberLabelsTr(class, 1) = Classes(class);
        
    end    
elseif (strcmp(method ,'kfold') )
    for class = 1:numClasses
        
        tEndMembers = [];
        tEndMemberLabels = [];
        
        tEndMembers = samples (labels == Classes(class), :);
        tEndMemberLabels = labels(labels == Classes(class));
        tEndMembersTr = tEndMembers;
        tEndMembersTest  = tEndMembers;
        tEndMemberLabelsTr = tEndMemberLabels;
        tEndMemberLabelsTest  = tEndMemberLabels;
        
        Indices = crossvalind('Kfold', length(tEndMemberLabels), k);
        
        tEndMembersTr(Indices ~= 1,:) = [];
        tEndMembersTest(Indices == 1,:) = [];
        tEndMemberLabelsTr(Indices ~= 1) = [];
        tEndMemberLabelsTest(Indices == 1) = [];
        
        endMembersTr  = [endMembersTr ;tEndMembersTr];
        endMemberLabelsTr = [endMemberLabelsTr; tEndMemberLabelsTr];
        
        endMembersTest  = [endMembersTest ;tEndMembersTest];
        endMemberLabelsTest = [endMemberLabelsTest; tEndMemberLabelsTest];
        
    end
elseif (strcmp(method ,'leavemeout') )
    for class = 1:numClasses
        
        tEndMembers = [];
        tEndMemberLabels = [];
        
        tEndMembers = samples (labels == Classes(class), :);
        tEndMemberLabels = labels(labels == Classes(class));
        tEndMembersTr = tEndMembers;
        tEndMembersTest  = tEndMembers;
        tEndMemberLabelsTr = tEndMemberLabels;
        tEndMemberLabelsTest  = tEndMemberLabels;
        curElements = int32(numElements);
        if(curElements>length(tEndMemberLabels) )
            curElements = int32( length(tEndMemberLabels) - 1);
        end
        [Train, Test] = crossvalind('LeaveMOut', length(tEndMemberLabels), curElements);
        tEndMembersTr(Test == 0,:) = [];
        tEndMembersTest(Train == 0,:) = [];
        tEndMemberLabelsTr(Test == 0) = [];
        tEndMemberLabelsTest(Train == 0) = [];
        
        endMembersTr  = [endMembersTr ;tEndMembersTr];
        endMemberLabelsTr = [endMemberLabelsTr; tEndMemberLabelsTr];
%         endMembersTr  = [endMembersTr ;median(tEndMembersTr)];
%         endMemberLabelsTr = [endMemberLabelsTr; Classes(class)];
        
        endMembersTest  = [endMembersTest ;tEndMembersTest];
        endMemberLabelsTest = [endMemberLabelsTest; tEndMemberLabelsTest];
        
    end
elseif (strcmp(method ,'all') )
    for class = 1:numClasses
        
        tEndMembers = [];
        tEndMemberLabels = [];
        
        tEndMembers = samples (labels == Classes(class), :);
        tEndMemberLabels = labels(labels == Classes(class));
        endMembersTr  = [endMembersTr ;tEndMembers];
        endMemberLabelsTr = [endMemberLabelsTr; tEndMemberLabels];
        
    end
elseif (strcmp(method ,'MDPPI') )
    for class = 1:numClasses
        cLabels = labels( labels == Classes(class) );
        cData   = trDataSubT(:,labels == Classes(class) );
        score    =MDPPI( cData,3,200,1 );
        [scoreSorted, scoreIndex] = sort(score,2, 'descend');
        numCEndmembers = length(score(score>0));
        cNumElements = min(numCEndmembers, numElements);
        tEndMembers = [];
        tEndMemberLabels = [];
        for i = 1:cNumElements
            tEndMembers (:, i)         = cData(:, scoreIndex(i) );
            tEndMemberLabels(i)    = Classes(class);
        end
        
        endMembersTr              = [endMembersTr; tEndMembers'];
        endMemberLabelsTr     = [endMemberLabelsTr; tEndMemberLabels'];
    end
elseif (strcmp(method ,'MDPPI2') )
    
    score    =MDPPI( trDataSubT,3,200,1 );
    [scoreSorted, scoreIndex] = sort(score,2, 'descend');
    
    for i = 1:numElements*length(Classes)
        endMembersTr (:, i)         = trDataSubT(:, scoreIndex(i) );
        endMemberLabelsTr(i)    = labels(scoreIndex(i));
    end
    endMembersTr = endMembersTr';
    endMemberLabelsTr = endMemberLabelsTr';
    
elseif (strcmp(method ,'EIA_FIPPI2') )
    addpath('EIAT')
    addpath('matlabhyperspec')
    numEndMembers = numElements*length(Classes);
    maxit = 3*numEndMembers;
    [E C]    = EIA_FIPPI(trDataSubT,numEndMembers,maxit, labels) ;
    
    [scoreSorted, scoreIndex] = sort(score,2, 'descend');
    
    for i = 1:numElements*length(Classes)
        endMembersTr (:, i)         = trDataSubT(:, scoreIndex(i) );
        endMemberLabelsTr(i)    = labels(scoreIndex(i));
    end
    endMembersTr = endMembersTr';
    endMemberLabelsTr = endMemberLabelsTr';
    
end


end