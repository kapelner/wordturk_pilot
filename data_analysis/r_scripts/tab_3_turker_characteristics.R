#libraries
tryCatch(library(nlme), error = function(e){install.packages("nlme")}, finally = library(nlme))
tryCatch(library(geepack), error = function(e){install.packages("geepack")}, finally = library(geepack))
tryCatch(library(gee), error = function(e){install.packages("gee")}, finally = library(gee))
tryCatch(library(lme4), error = function(e){install.packages("lme4")}, finally = library(lme4))

RUN_ALL_POSSIBLE_MODELS = FALSE


#clean up time_spent - the max time is 7 min = 420s
dis$time_spent[dis$time_spent >= 7 * 60] = NA
dis_without_bad_vals_of_time_spent = dis[!is.na(dis$time_spent), ]
#hist(dis_without_bad_vals_of_time_spent$time_spent, br = 1000)
#quantile(dis_without_bad_vals_of_time_spent$time_spent, c(0,.01, .02, .10,.20,.30,.40,.50,.60,.70,.80,.90,1.00))

############################
############################worker characteristics
############################

#this generates table 3 which is then formated in latex (latex formatting done by hand and is not shown)
wc_linear_mod_fixed_snippet_and_worker = lm(correct ~ 0 + #no intercept since we're using fixed intercepts
				time_spent + 
				comments_word_count +
				task_ord_number +
				snippet_id + 
				mturk_worker_id,
		data = dis_without_bad_vals_of_time_spent
)
summary(wc_linear_mod_fixed_snippet_and_worker) #table 3 results


###############everything beyond this point is experimental

#								Estimate   Std. Error t value Pr(>|t|)
#time_spent                    -0.0006187  0.0001134  -5.454 5.07e-08 ***
#comments_word_count           -0.0022538  0.0022551  -0.999 0.317620    
#num_disambiguations_by_worker  0.0008072  0.0073700   0.110 0.912793
#.
#. (all snippets...)
#.
#. (all workers...)
#.		

if (RUN_ALL_POSSIBLE_MODELS){
	
	wc_linear_mod_fixed_snippet_and_worker = lm(correct ~ 
					time_spent + 
					comments_word_count +
					num_disambiguations_by_worker +
					snippet_id,
			data = dis_without_bad_vals_of_time_spent
	)
	summary(wc_linear_mod_fixed_snippet_and_worker)
	
	#								Estimate Std. Error t value Pr(>|t|)    
	#(Intercept)                    1.060e+00  1.328e-01   7.978 1.67e-15 ***
	#time_spent                    -4.500e-04  9.627e-05  -4.674 3.00e-06 ***
	#comments_word_count            1.022e-03  2.094e-03   0.488 0.625347    
	#num_disambiguations_by_worker -2.574e-04  4.324e-05  -5.953 2.73e-09 ***
	#.
	#. (all snippets...)
	#.
	
	wc_logit_mod_fixed_snippet_and_worker = glm(correct ~ 
					time_spent + 
					comments_word_count +
					num_disambiguations_by_worker +
					snippet_id + 
					mturk_worker_id,
			family = "binomial",
			data = dis_without_bad_vals_of_time_spent
	)
	summary(wc_logit_mod_fixed_snippet_and_worker) #screwed up!!
	
	
	wc_linear_mod_random_snippet_and_worker = lmer(correct ~ 
					time_spent + 
					comments_word_count +
					num_disambiguations_by_worker +
					(1 | snippet_id) +
					(1 | mturk_worker_id),
			data = dis_without_bad_vals_of_time_spent
	)
	summary(wc_linear_mod_random_snippet_and_worker)
	
	#AIC  BIC logLik deviance REMLdev
	#9857 9907  -4921     9792    9843
	#Random effects:
	#Groups          Name        Variance  Std.Dev.
	#snippet_id      (Intercept) 0.0521053 0.22827 
	#mturk_worker_id (Intercept) 0.0078979 0.08887 
	#Residual                    0.1326521 0.36421 
	#Number of obs: 9736, groups: snippet_id, 1000; mturk_worker_id, 593
	#
	#Fixed effects:
	#		Estimate Std. Error t value
	#(Intercept)                    7.748e-01  1.234e-02   62.79 ***
	#time_spent                    -6.922e-04  1.029e-04   -6.73 ***
	#comments_word_count           -5.486e-04  2.086e-03   -0.26
	#num_disambiguations_by_worker -3.763e-05  1.266e-04   -0.30
	
	wc_logit_mod_random_snippet_and_worker = lmer(correct ~ 
					time_spent + 
					comments_word_count +
					num_disambiguations_by_worker +
					(1 | snippet_id) +
					(1 | mturk_worker_id),
			family = "binomial",
			data = dis_without_bad_vals_of_time_spent
	)
	summary(wc_logit_mod_random_snippet_and_worker)
	
	#AIC  BIC logLik deviance
	#9612 9656  -4800     9600
	#Random effects:
	#		Groups          Name        Variance Std.Dev.
	#snippet_id      (Intercept) 2.4536   1.56639 
	#mturk_worker_id (Intercept) 0.3936   0.62738 
	#Number of obs: 9736, groups: snippet_id, 1000; mturk_worker_id, 593
	#
	#Fixed effects:
	#								Estimate 	Std. Error z value Pr(>|z|)    
	#(Intercept)                    1.8246038  0.0888314  20.540  < 2e-16 ***
	#time_spent                    -0.0048974  0.0006982  -7.014 2.31e-12 ***
	#comments_word_count           -0.0081737  0.0154675  -0.528    0.597    
	#num_disambiguations_by_worker -0.0003247  0.0009019  -0.360    0.719
	
	#warning: takes 15min to compute
	wc_linear_mod_fixed_snippet_and_corr_worker = gls(correct ~ 
					time_spent + 
					comments_word_count +
					num_disambiguations_by_worker +
					snippet_id,
			corr = corCompSymm(form = ~ 1 | mturk_worker_id),
			data = dis_without_bad_vals_of_time_spent
	)
	summary(wc_linear_mod_fixed_snippet_and_corr_worker)
	
	#AIC      BIC    logLik
	#11722.69 18832.93 -4856.344
	#
	#Correlation Structure: Compound symmetry
	#Formula: ~1 | mturk_worker_id 
	#Parameter estimate(s):
	#		Rho 
	#0.05525971 
	#
	#Coefficients:
	#								Value  	  Std.Error   t-value p-value
	#(Intercept)                    1.0174817 0.12999464  7.827105  0.0000
	#time_spent                    -0.0005273 0.00010478 -5.032814  0.0000
	#comments_word_count           -0.0007701 0.00211311 -0.364428  0.7155
	#num_disambiguations_by_worker -0.0000311 0.00012610 -0.246648  0.8052
	
	
	#can't get this to work....
	#wc_logit_mod_fixed_snippet_and_corr_worker = gee(correct ~
	#				time_spent + 
	#				comments_word_count +
	#				num_disambiguations_by_worker +
	#				snippet_id,
	#		id = mturk_worker_id,
	#		corstr = "exchangeable",
	#		family = "binomial",
	#		data = dis_without_bad_vals_of_time_spent
	#)
	#summary(wc_logit_mod_fixed_snippet_and_corr_worker)
	
	
	AIC(wc_linear_mod_fixed_snippet_and_worker)
	AIC(wc_logit_mod_fixed_snippet_and_worker)
	AIC(wc_linear_mod_random_snippet_and_worker)
	AIC(wc_logit_mod_random_snippet_and_worker)
	AIC(wc_linear_mod_fixed_snippet_and_corr_worker)
	
	
	wc_linear_mod_fixed_snippet_and_worker_poly_t = lm(correct ~ 0 +
					poly(time_spent, 3) + 
					comments_word_count +
					num_disambiguations_by_worker +
					snippet_id + 
					mturk_worker_id,
			data = dis_without_bad_vals_of_time_spent
	)
	summary(wc_linear_mod_fixed_snippet_and_worker_poly_t)
	#plot the poly function
	#t = seq(from = 0, to = 420, length = 10000)
	#f_t =  -2.795e-03 * t + 1.374e-05 * t^2 + -2.147e-08 * t^3
	#plot(t, f_t, xlab = "time spent (seconds)", ylab = "f(t)", type = "l", main = "Effect of time spent of accuracy")

}


