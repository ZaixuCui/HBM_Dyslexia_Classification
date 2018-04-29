# HBM_Dyslexia_Classification
Codes for nested linear svm &amp; logistic classifcation in HBM paper (http://onlinelibrary.wiley.com/doi/10.1002/hbm.23112/abstract). 
A nested corss validation was applied, with inner cross validation for P threshold selection, outer cross validation for classifier evaluation.
Ttest_SVM_2group_PSelection_SGE.m and Ttest_LR_2group_PSelection_SGE.m are main functions for LSVM and logistic regression, respectively.

Citing our related paper will be greatly appreciated if you use these codes.
<br>&emsp; ```Zaixu Cui, Mengmeng Su, Liangjie Li, Hua Shu, Gaolang Gong; Individualized Prediction of Reading Comprehension Ability Using Gray Matter Volume, Cerebral Cortex, Volume 28, Issue 5, 1 May 2018, Pages 1656–1672, https://doi.org/10.1093/cercor/bhx061```

LIBSVM (https://www.csie.ntu.edu.tw/~cjlin/libsvm/) is called for implementing support vector classification.  
Weka (http://www.cs.waikato.ac.nz/ml/weka/) is used for implementing logistic regression.

PSOM (http://psom.simexp-lab.org/) was used here for parallelization in SGE.

Copyright (c) Zaixu Cui, State Key Laboratory of Cognitive Neuroscience and Learning, Beijing Normal University.  
Contact information: 
zaixucui@gmail.com

