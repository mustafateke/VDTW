function stats = confusionmatStats(group,grouphat)
% INPUT
% group = true class labels
% grouphat = predicted class labels
%
% OR INPUT
% stats = confusionmatStats(group);
% group = confusion matrix from matlab function (confusionmat)
%
% OUTPUT
% stats is a structure array
% stats.confusionMat
%               Predicted Classes
%                    p'    n'
%              ___|_____|_____| 
%       Actual  p |     |     |
%      Classes  n |     |     |
%
% stats.accuracy = (TP + TN)/(TP + FP + FN + TN) ; the average accuracy is returned
% stats.precision = TP / (TP + FP)                  % for each class label
% stats.sensitivity = TP / (TP + FN)                % for each class label
% stats.specificity = TN / (FP + TN)                % for each class label
% stats.recall = sensitivity                        % for each class label
% stats.Fscore = 2*TP /(2*TP + FP + FN)            % for each class label
%
% TP: true positive, TN: true negative, 
% FP: false positive, FN: false negative
% 

field1 = 'confusionMat';
field8 = 'confusionMatPercentage';
if nargin < 2
    ConfusionMat = group;
else
    ConfusionMat = confusionmat(group,grouphat);
end

numOfClasses = size(ConfusionMat,1);

confusionMatPercentage = ConfusionMat;
sumRowsConfusion = sum(ConfusionMat,2);
for class = 1:numOfClasses
    confusionMatPercentage(class,:) = confusionMatPercentage(class,:) /sumRowsConfusion(class);
end

totalSamples = sum(sum(ConfusionMat));

% field2 = 'accuracy';  value2 = (2*trace(value1)+sum(sum(2*value1)))/(numOfClasses*totalSamples);
field2 = 'accuracy';  value2 = ( sum(trace(ConfusionMat)) )/(totalSamples);

[TP,TN,FP,FN,sensitivity,specificity,precision,f_score] = deal(zeros(numOfClasses,1));
for class = 1:numOfClasses
   TP(class) = ConfusionMat(class,class);
   tempMat = ConfusionMat;
   tempMat(:,class) = []; % remove column
   tempMat(class,:) = []; % remove row
   TN(class) = sum(sum(tempMat));
   FP(class) = sum(ConfusionMat(:,class))-TP(class);
   FN(class) = sum(ConfusionMat(class,:))-TP(class);
end

for class = 1:numOfClasses
    sensitivity(class) = TP(class) / (TP(class) + FN(class));
    specificity(class) = TN(class) / (FP(class) + TN(class));
    precision(class) = TP(class) / (TP(class) + FP(class));
    f_score(class) = 2*TP(class)/(2*TP(class) + FP(class) + FN(class));
end



field3 = 'sensitivity';  value3 = sensitivity;
field4 = 'specificity';  value4 = specificity;
field5 = 'precision';  value5 = precision;
field6 = 'recall';  value6 = sensitivity;
field7 = 'Fscore';  value7 = f_score;
stats = struct(field1,ConfusionMat,field2,value2,field3,value3,field4,value4,field5,value5,field6,value6,field7,value7,field8,confusionMatPercentage);