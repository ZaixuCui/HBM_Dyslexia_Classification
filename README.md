# HBM_Dyslexia_Classification
Codes for nested linear svm &amp; logistic classifcation in HBM paper (http://onlinelibrary.wiley.com/doi/10.1002/hbm.23112/abstract). 

A nested corss validation was applied, with inner cross validation for P threshold selection, outer cross validation for classifier evaluation.

Ttest_SVM_2group_PSelection_SGE.m and Ttest_LR_2group_PSelection_SGE.m are main functions for LSVM and logistic regression, respectively.

Citing our paper will be greatly appreciated if you use these codes.
<br>&emsp; ```Cui, Z. , Xia, Z. , Su, M. , Shu, H. and Gong, G. (2016), Disrupted white matter connectivity underlying developmental dyslexia: A machine learning approach. Hum. Brain Mapp., 37: 1443-1458. doi:10.1002/hbm.23112```

LIBSVM (https://www.csie.ntu.edu.tw/~cjlin/libsvm/) is called for implementing support vector classification.  
Weka (http://www.cs.waikato.ac.nz/ml/weka/) is used for implementing logistic regression.

PSOM (http://psom.simexp-lab.org/) was used here for parallelization in SGE.

Copyright (c) Zaixu Cui, State Key Laboratory of Cognitive Neuroscience and Learning, Beijing Normal University.  
Contact information: 
zaixucui@gmail.com

