Q3 = prctile(trial_Length,75);
Q1 = prctile(trial_Length,25);
IQR = Q3 - Q1;
UF = Q3 + IQR*1.5;