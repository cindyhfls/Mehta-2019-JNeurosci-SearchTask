# SearchTask
Priyanka's Visual Search Task

# To-do:
Get the eye data.
Look into what exactly assumptions and shape von mises distribution takes.
Get the AIC and BIC functions (MATLAB R2017b).

1. Task 
There were 4/7 diamonds on the screen for each trial. The offer value can be seen by staring at the diamonds, max__offer * ratio where ratio = 0-1.
Staring any offer for 200ms = choice.
Total Neuron Number = 122
ScreenSize was larger for Neuron 12-70
PSTHs: Centered around the offers the monkey have checked, 10s before, and 10s after.
The number of offers checked is the length of vars.masksOpened. This determines the number of psths per trial.
We want the period from stimulus onset to choice, but I will discuss this with Michael again.

2. The main function was main_anal_search_task.m
It calls fitting of parameters for some # distribution function #.
Fitting was done by fminsearchbnd.m (a function from the Internet which was based on MATLAB fminsearch function).
What it does is fitting paramters by gradient descent, to maximize the loglikelihood.

3. The log likelihood of the model was calculated with log_likelihood.m
This can be changed to include multiple variables (with different distributions).
And then calculate the joint probability e.g. (log_likelihood_x + log_likelihood_y + ...).
Since the log likelihoods are additive, find the best-fit distribution for each variable if you want to fit a joint probabilty.


4. Distribution Functions: e.g. vonmises.m
Customized Likelihood Functions, which takes several parameters and ouput the probability given an independent variable x.
if x is x-coord/y-coord/velocity
   use Linear/Gaussian/(Mixed-Gaussian/Cubic spline/Exponential/Polynomial)
elseif x is angle (in deg or rad)
   use the Von mises function (which assumes 0 and 360 is the same).
end

5. The models are compared with Uniform Distribution using AIC, BIC criteria.
https://www.mathworks.com/help/econ/aicbic.html
