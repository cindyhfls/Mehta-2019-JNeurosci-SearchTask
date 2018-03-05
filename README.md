# SearchTask
Based on Priyanka's Visual Search Task

# To-do:
1. Plot for 10 neurons different model llkd, aic, bic with the vars = X,Y. In the epoch 961:1000.
2. Repeat for the epoch 1001:1020.
3. Get Velocity, angle and acceleration vectors...
4. Look into what exactly assumptions and shape von mises distribution takes.
5. Read about AIC/BIC
6. Read Grid-cell/autocorrelation method
7. Improve on fminsearchbnd/fminsearchunc/etc. optimization process
8. By the way, from bar viewing to begin fixation on next diamond takes about 200-250 ms. <300 (300 ms is the accepting time window).

# Less important analysis:
1. Check the same spatial tuning for inter-trial interval (at fixation)
2. Default mode network (after 1s of the ITI)----difference in in ITI and trial
3. Latency Analysis
4. Grid cell.

# To-do: for re-wrapping data
1. Calculate the freq of occurence of breaking fixation at bar viewing and obtain those time-stampes and mark trials
2. Calculate the freq of re-fixating mark those trials
3. Add in the orginial file name as a field of the data structure
4. Change mydata to data

# 1. Task 
There were 4/7 diamonds on the screen for each trial. The offer value can be seen by staring at the diamonds, max__offer * ratio where ratio = 0-1.
Staring any offer for 200ms = choice.
Total Neuron Number = 122
ScreenSize was larger for Neuron 12-70
PSTHs: Centered around the offers the monkey have checked, 10s before, and 10s after.
The number of offers checked is the length of vars.masksOpened. This determines the number of psths per trial.
We want the period from stimulus onset to choice, but I will discuss this with Michael again.

diamond fixation  = 400 ms
bar fixation (completed) = 300 ms
bar rejection < 300 ms

# 2. The main function was main_anal_search_task.m
It calls fitting of parameters for some # distribution function #.
Fitting was done by fminsearchbnd.m (a function from the Internet which was based on MATLAB fminsearch function).
What it does is fitting paramters by gradient descent, to maximize the loglikelihood.

# 3. The log likelihood of the model was calculated with log_likelihood.m
This can be changed to include multiple variables (with different distributions).
And then calculate the joint probability e.g. (log_likelihood_x + log_likelihood_y + ...).
Since the log likelihoods are additive, find the best-fit distribution for each variable if you want to fit a joint probabilty.


# 4. Distribution Functions: e.g. vonmises.m/linear.m
% remember to add in the constant term for each distribution
Customized Likelihood Functions, which takes several parameters and ouput the probability given an independent variable x.
if x is x-coord/y-coord/velocity
   use Linear/Gaussian/(Mixed-Gaussian/Cubic spline/Exponential/Polynomial)
elseif x is angle (in deg or rad)
   use the Von mises function (which assumes 0 and 360 is the same).
end

# 5. The models are compared with Uniform Distribution using AIC, BIC criteria.
https://www.mathworks.com/help/econ/aicbic.html
