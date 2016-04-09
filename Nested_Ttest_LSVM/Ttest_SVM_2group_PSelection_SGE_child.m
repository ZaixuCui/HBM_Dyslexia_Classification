function Ttest_SVM_2group_PSelection_SGE_child(SubjectsData_Path, Subjects_Label, i, P_Value_Range, Pre_Method, ResultantFolder)
%
% Copyright(c) 2016
% State Key Laboratory of Cognitive Neuroscience and Learning, Beijing Normal University
%    Written by <a href="zaixucui@gmail.com">Zaixu Cui</a>
%    Mail to Author:  <a href="zaixucui@gmail.com">zaixucui@gmail.com</a>
%
% SubjectData_Path:
%           path of .mat file containing a m*n matrix
%           m is the number of subjects
%           n is the number of features
%
% Subject_Label:
%           n * 1 vector, each element is 1 or -1
%
% i:
%           the ith fold
%
% P_Value_Range:
%           threshold to delete non-important features
%
% Pre_Method:
%           'Scale' or 'Normalzie'
%
% ResultantFolder:
%           the path of folder storing resultant files
%

if ~exist(ResultantFolder, 'dir')
    mkdir(ResultantFolder);
end
load(SubjectsData_Path);
Subjects_Quantity = length(Subjects_Label);
    
disp(['The ' num2str(i) ' iteration!']);

Subjects_Data_tmp = Subjects_Data;
Subjects_Label_tmp = Subjects_Label;
% Select training data and testing data
test_label = Subjects_Label_tmp(i);
test_data = Subjects_Data_tmp(i, :);

Subjects_Label_tmp(i) = [];
Subjects_Data_tmp(i, :) = [];
Training_group1_Index = find(Subjects_Label_tmp == 1);
Training_group0_Index = find(Subjects_Label_tmp == -1);
Training_group1_data = Subjects_Data_tmp(Training_group1_Index, :);
Training_group0_data = Subjects_Data_tmp(Training_group0_Index, :);
Training_group1_Label = Subjects_Label_tmp(Training_group1_Index);
Training_group0_Label = Subjects_Label_tmp(Training_group0_Index);

% feature selection for training data
All_Training = [Training_group1_data; Training_group0_data];
Label = [Training_group1_Label; Training_group0_Label];

for j = 1:length(P_Value_Range)
    Accuracy(j) = Ttest_SVM_2group_ACC(All_Training, Label, P_Value_Range(j), Pre_Method);
end
Accuracy = roundn(Accuracy, -4);

ACC_Sum_3Feature(1) = Accuracy(1) + Accuracy(1) + Accuracy(2);
for j = 2:length(P_Value_Range) - 1
    ACC_Sum_3Feature(j) = Accuracy(j-1) + Accuracy(j) + Accuracy(j+1);
end
ACC_Sum_3Feature(length(P_Value_Range)) = Accuracy(length(P_Value_Range)-1) + Accuracy(length(P_Value_Range)) + Accuracy(length(P_Value_Range));
ACC_Sum_3Feature = roundn(ACC_Sum_3Feature, -4);
MaxIndex = find(ACC_Sum_3Feature == max(ACC_Sum_3Feature));

if length(MaxIndex) > 1
    Tmp = Accuracy(MaxIndex);
    MaxIndex2 = MaxIndex(find(Tmp == max(Tmp)));
    P_Value_Final = P_Value_Range(MaxIndex2(1));
else
    P_Value_Final = P_Value_Range(MaxIndex(1));
end

% T test
[PValue RetainID] = Ranking_Ttest(All_Training, Label, P_Value_Final);
All_Training_New = All_Training(:, RetainID);
save([ResultantFolder filesep 'RetainID_' num2str(i) '.mat'], 'RetainID');

if strcmp(Pre_Method, 'Normalize')
    % Normalizing
    MeanValue = mean(All_Training_New);
    StandardDeviation = std(All_Training_New);
    [rows, columns_quantity] = size(All_Training_New);
    for j = 1:columns_quantity
        if StandardDeviation(j)
            All_Training_New(:, j) = (All_Training_New(:, j) - MeanValue(j)) / StandardDeviation(j);
        end
    end
elseif strcmp(Pre_Method, 'Scale')
    % Scaling to [0 1]
    MinValue = min(All_Training_New);
    MaxValue = max(All_Training_New);
    [rows, columns_quantity] = size(All_Training_New);
    for j = 1:columns_quantity
        All_Training_New(:, j) = (All_Training_New(:, j) - MinValue(j)) / (MaxValue(j) - MinValue(j));
    end
end

% SVM classification
All_Training_New = double(All_Training_New);
model = svmtrain(Label, All_Training_New,'-t 0');

% Ttest
test_data_New = test_data(RetainID);
% Normalizing
if strcmp(Pre_Method, 'Normalize')
    % Normalizing
    test_data_New = (test_data_New - MeanValue) ./ StandardDeviation;
elseif strcmp(Pre_Method, 'Scale')
    % Scale
    test_data_New = (test_data_New - MinValue) ./ (MaxValue - MinValue);
end

% predicts
test_data_New = double(test_data_New);
[predicted_label, ~, tmp] = svmpredict(test_label, test_data_New, model);
% Calculate decision value
w = zeros(size(model.SVs(1, :)));
for j = 1 : model.totalSV
    w = w + model.sv_coef(j) * model.SVs(j, :);
end
decision_value = w * test_data_New' - model.rho;

save([ResultantFolder filesep 'predicted_labels_' num2str(i) '.mat'], 'predicted_label');
save([ResultantFolder filesep 'decision_values_' num2str(i) '.mat'], 'decision_value');

% For averaging w
w = w / norm(w);
save([ResultantFolder filesep 'w_' num2str(i) '.mat'], 'w');


