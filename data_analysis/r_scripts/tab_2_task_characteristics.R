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
colnames(dis)


############################
############################snippet characteristics
############################


formula = correct ~ 0 +
				target_word_is_noun + 
				target_word_length + 
				log(word_freq) + 
				snippet_context_num_chars + 		
				correct_sense_def_num_rephrasings + 
				correct_sense_num_chars +
				num_senses_to_disambiguate +
				mturk_worker_id
				
				

#this generates table 2 which is then formated in latex (latex formatting done by hand and is not shown)
sc_linear_mod_fixed_worker = lm(formula, data = dis_without_bad_vals_of_time_spent)

#results for table 2
summary(sc_linear_mod_fixed_worker)

########## Everything beyond this point is experimental


formula_full = correct ~ 0 + target_word_is_noun + 
		target_word_length + 
		log(word_freq) + 
		correct_sense_def_num_rephrasings + 
		correct_sense_num_words +
		correct_sense_num_syllables + 
		correct_sense_num_chars +
		correct_sense_kincaid_score +
		correct_sense_fog_score +
		snippet_context_num_words +
		snippet_context_num_syllables +
		snippet_context_num_chars +
		snippet_context_kincaid_score +
		snippet_context_fog_score +
		num_senses_to_disambiguate +
		mturk_worker_id

#let's try to see what snippet_context_num_words looks like
formula_without_snippet_context_num_words = correct ~ 0 +
				target_word_is_noun + 
				target_word_length + 
				log(word_freq) + 		
				correct_sense_def_num_rephrasings + 
				correct_sense_num_chars +
				num_senses_to_disambiguate +
				mturk_worker_id
				
mod_without_x = lm(formula_without_snippet_context_num_words, data = dis_without_bad_vals_of_time_spent)	
mod_just_x_poly = lm(mod_without_x$residuals ~ poly(dis_without_bad_vals_of_time_spent$snippet_context_num_words, 10))
summary(mod_just_x_poly)	
mod_just_x = lm(mod_without_x$residuals ~ dis_without_bad_vals_of_time_spent$snippet_context_num_words)	
summary(mod_just_x)	
		
plot(dis_without_bad_vals_of_time_spent$snippet_context_num_words, mod_without_x$residuals, xlab = "snippet_context_num_words", ylab = "resids", main = "polynomial regression")
points(dis_without_bad_vals_of_time_spent$snippet_context_num_words, mod_just_x_poly$fitted.values, col = "blue")

plot(dis_without_bad_vals_of_time_spent$snippet_context_num_words, mod_without_x$residuals, xlab = "snippet_context_num_words", ylab = "resids", main = "linear regression")
points(dis_without_bad_vals_of_time_spent$snippet_context_num_words, mod_just_x$fitted.values, col = "blue")


mod_just_x_poly = lm(mod_without_x$residuals ~ poly(dis_without_bad_vals_of_time_spent$snippet_context_num_chars, 10))
summary(mod_just_x_poly)	
mod_just_x = lm(mod_without_x$residuals ~ dis_without_bad_vals_of_time_spent$snippet_context_num_chars)	
summary(mod_just_x)	
		
plot(dis_without_bad_vals_of_time_spent$snippet_context_num_chars, mod_without_x$residuals, xlab = "snippet_context_num_chars", ylab = "resids", main = "polynomial regression")
points(dis_without_bad_vals_of_time_spent$snippet_context_num_chars, mod_just_x_poly$fitted.values, col = "blue")

plot(dis_without_bad_vals_of_time_spent$snippet_context_num_chars, mod_without_x$residuals, xlab = "snippet_context_num_chars", ylab = "resids", main = "linear regression")
points(dis_without_bad_vals_of_time_spent$snippet_context_num_chars, mod_just_x$fitted.values, col = "blue")

#chop off the tail and see what happens
sc_linear_mod_fixed_worker = lm(formula, data = dis_without_bad_vals_of_time_spent[dis_without_bad_vals_of_time_spent$snippet_context_num_words < 180, ])
summary(sc_linear_mod_fixed_worker)




#									Estimate 	Std. Error 	t value Pr(>|t|)    
#(Intercept)                        1.6344757  0.0992747  16.464  < 2e-16 ***
#target_word_is_noun1               0.1096351  0.0120861   9.071  < 2e-16 ***
#target_word_length                -0.0118783  0.0028848  -4.118 3.86e-05 ***
#log(word_freq)                    -0.0426407  0.0049493  -8.615  < 2e-16 ***
#correct_sense_def_num_rephrasings  0.0333550  0.0062402   5.345 9.25e-08 ***
#correct_sense_num_words            0.0208513  0.0062051   3.360 0.000782 ***
#correct_sense_num_syllables       -0.0201111  0.0056564  -3.555 0.000379 ***
#correct_sense_num_chars            0.0020690  0.0016895   1.225 0.220742    
#correct_sense_kincaid_score        0.0058043  0.0015322   3.788 0.000153 ***
#correct_sense_fog_score           -0.0037396  0.0008088  -4.624 3.82e-06 ***
#snippet_context_num_words          0.0030466  0.0007390   4.123 3.77e-05 ***
#snippet_context_num_syllables      0.0007175  0.0005967   1.202 0.229207    
#snippet_context_num_chars         -0.0007451  0.0001672  -4.455 8.49e-06 ***
#snippet_context_kincaid_score      0.0086751  0.0039233   2.211 0.027050 *  
#snippet_context_fog_score         -0.0039989  0.0035543  -1.125 0.260581    
#num_senses_to_disambiguate        -0.0312915  0.0014985 -20.882  < 2e-16 ***
#.
#. (all workers...)
#.

if (RUN_ALL_POSSIBLE_MODELS){
	
	# logistic model with fixed effects for worker
	sc_logit_mod_fixed_worker = glm(formula,
			family = "binomial",
			data = dis_without_bad_vals_of_time_spent
	)
	summary(sc_logit_mod_fixed_worker)
	AIC(sc_logit_mod_fixed_worker)
	
	#									Estimate 	Std. Error z value Pr(>|z|)    
	#(Intercept)                        6.772e+00  6.557e-01  10.329  < 2e-16 ***
	#target_word_is_noun1               6.266e-01  7.323e-02   8.556  < 2e-16 ***
	#target_word_length                -8.099e-02  1.807e-02  -4.482 7.40e-06 ***
	#log(word_freq)                    -2.646e-01  2.981e-02  -8.875  < 2e-16 ***
	#correct_sense_def_num_rephrasings  2.113e-01  3.771e-02   5.603 2.11e-08 ***
	#correct_sense_num_words            8.743e-02  3.628e-02   2.410 0.015943 *  
	#correct_sense_num_syllables       -9.654e-02  3.335e-02  -2.895 0.003794 ** 
	#correct_sense_num_chars            1.090e-02  9.863e-03   1.105 0.269305    
	#correct_sense_kincaid_score        2.633e-02  9.501e-03   2.771 0.005582 ** 
	#correct_sense_fog_score           -2.097e-02  4.882e-03  -4.294 1.75e-05 ***
	#snippet_context_num_words          1.888e-02  4.429e-03   4.264 2.01e-05 ***
	#snippet_context_num_syllables      4.285e-03  3.558e-03   1.204 0.228464    
	#snippet_context_num_chars         -4.562e-03  1.000e-03  -4.561 5.09e-06 ***
	#snippet_context_kincaid_score      6.574e-02  2.482e-02   2.649 0.008073 ** 
	#snippet_context_fog_score         -3.349e-02  2.211e-02  -1.515 0.129769    
	#num_senses_to_disambiguate        -1.721e-01  8.662e-03 -19.869  < 2e-16 ***
	#.
	#. (all workers...)
	#.
	
	
	# linear model with correlation structure for worker
	sc_linear_mod_corr_worker = gls(correct ~
					target_word_is_noun + 
					target_word_length + 
					log(word_freq) + 
					correct_sense_def_num_rephrasings + 
	#				correct_sense_num_words +
	#				correct_sense_num_syllables + 
					correct_sense_num_chars +
	#				correct_sense_kincaid_score +
	#				correct_sense_fog_score +
	#				snippet_context_num_words +
	#				snippet_context_num_syllables +
					snippet_context_num_chars +
	#				snippet_context_kincaid_score +
	#				snippet_context_fog_score +
					num_senses_to_disambiguate,
			corr = corCompSymm(form = ~ 1 | mturk_worker_id),
			data = dis_without_bad_vals_of_time_spent
	)
	summary(sc_linear_mod_corr_worker)
	AIC(sc_linear_mod_corr_worker)
	
	#Correlation Structure: Compound symmetry
	#Formula: ~1 | mturk_worker_id 
	#Parameter estimate(s):
	#		Rho 
	#0.04277281 
	#
	#Coefficients:
	#									Value  		Std.Error  t-value p-value
	#(Intercept)                        1.4457033 0.08011677  18.044953  0.0000 ***
	#target_word_is_noun1               0.1073200 0.01183240   9.070014  0.0000 ***
	#target_word_length                -0.0125724 0.00283388  -4.436468  0.0000 ***
	#log(word_freq)                    -0.0403130 0.00485031  -8.311427  0.0000 ***
	#correct_sense_def_num_rephrasings  0.0365556 0.00611358   5.979420  0.0000 ***
	#correct_sense_num_words            0.0202716 0.00603416   3.359477  0.0008 ***
	#correct_sense_num_syllables       -0.0196791 0.00551323  -3.569440  0.0004 ***
	#correct_sense_num_chars            0.0017928 0.00164920   1.087088  0.2770
	#correct_sense_kincaid_score        0.0062988 0.00149707   4.207448  0.0000 ***
	#correct_sense_fog_score           -0.0039268 0.00079150  -4.961163  0.0000 ***
	#snippet_context_num_words          0.0031823 0.00072009   4.419337  0.0000 ***
	#snippet_context_num_syllables      0.0003904 0.00058216   0.670579  0.5025
	#snippet_context_num_chars         -0.0006778 0.00016281  -4.163108  0.0000 ***
	#snippet_context_kincaid_score      0.0100015 0.00382880   2.612189  0.0090 ***
	#snippet_context_fog_score         -0.0044019 0.00346953  -1.268726  0.2046
	#num_senses_to_disambiguate        -0.0319223 0.00146628 -21.770850  0.0000 ***
	
	#do we need rho?
	
	sc_linear_mod_no_worker = gls(correct ~
					target_word_is_noun + 
					target_word_length + 
					log(word_freq) + 
					correct_sense_def_num_rephrasings + 
	#				correct_sense_num_words +
	#				correct_sense_num_syllables + 
					correct_sense_num_chars +
	#				correct_sense_kincaid_score +
	#				correct_sense_fog_score +
	#				snippet_context_num_words +
	#				snippet_context_num_syllables +
					snippet_context_num_chars +
	#				snippet_context_kincaid_score +
	#				snippet_context_fog_score +
					num_senses_to_disambiguate,
			data = dis_without_bad_vals_of_time_spent
	)
	AIC(sc_linear_mod_no_worker)
	anova(sc_linear_mod_no_worker, sc_linear_mod_corr_worker)
	
	#					Model df  AIC      BIC    logLik   Test  L.Ratio p-value
	#mod_without_rho     1 17 11133.28 11255.38 -5549.641                        
	#mod_with_rho        2 18 10897.67 11026.94 -5430.834 1 vs 2 237.6144  <.0001
	
	# ====> Looks like we need to put it in
	
	# logistic model with correlation structure for worker
	sc_logit_mod_corr_worker = gee(correct ~
					target_word_is_noun + 
					target_word_length + 
					log(word_freq) + 
					correct_sense_def_num_rephrasings + 
	#				correct_sense_num_words +
	#				correct_sense_num_syllables + 
					correct_sense_num_chars +
	#				correct_sense_kincaid_score +
	#				correct_sense_fog_score +
	#				snippet_context_num_words +
	#				snippet_context_num_syllables +
					snippet_context_num_chars +
	#				snippet_context_kincaid_score +
	#				snippet_context_fog_score +
					num_senses_to_disambiguate,
			id = snippet_id,
			corstr = "exchangeable",
			family = "binomial",
			data = dis_without_bad_vals_of_time_spent
	)
	summary(sc_logit_mod_corr_worker)
	
	#(Intercept)                        5.031131171 0.4627106433  10.8731693 0.4467577832  11.2614293 ***
	#target_word_is_noun1               0.566863667 0.0679742718   8.3393857 0.0702824692   8.0655059 ***
	#target_word_length                -0.079244477 0.0168389516  -4.7060220 0.0171369533  -4.6241870 ***
	#log(word_freq)                    -0.225613920 0.0274727578  -8.2122778 0.0260517488  -8.6602217 ***
	#correct_sense_def_num_rephrasings  0.217635497 0.0349462608   6.2277191 0.0346733434   6.2767381 ***
	#correct_sense_num_words            0.077769544 0.0334318079   2.3262141 0.0388563990   2.0014604 **
	#correct_sense_num_syllables       -0.090465204 0.0304665428  -2.9693295 0.0301810610  -2.9974163 ***
	#correct_sense_num_chars            0.009533517 0.0089850430   1.0610430 0.0090532438   1.0530499 
	#correct_sense_kincaid_score        0.028590104 0.0088642410   3.2253302 0.0095517503   2.9931796 ***
	#correct_sense_fog_score           -0.021003341 0.0045448927  -4.6213062 0.0046835147  -4.4845254 ***
	#snippet_context_num_words          0.018202385 0.0041085984   4.4303148 0.0041976435   4.3363341 ***
	#snippet_context_num_syllables      0.002158479 0.0032768018   0.6587152 0.0032507195   0.6640004 
	#snippet_context_num_chars         -0.003855530 0.0009231669  -4.1764171 0.0008867818  -4.3477776 ***
	#snippet_context_kincaid_score      0.070929485 0.0230166714   3.0816569 0.0231394151   3.0653102 ***
	#snippet_context_fog_score         -0.035494577 0.0204484711  -1.7358059 0.0201799306  -1.7589048 
	#num_senses_to_disambiguate        -0.160799525 0.0079306037 -20.2758241 0.0081138126 -19.8179983 ***
	
	
	#do we need the correlation
	sc_logit_mod_no_corr_worker = gee(correct ~
					target_word_is_noun + 
					target_word_length + 
					log(word_freq) + 
					correct_sense_def_num_rephrasings + 
					correct_sense_num_words +
					correct_sense_num_syllables + 
					correct_sense_num_chars +
					correct_sense_kincaid_score +
					correct_sense_fog_score +
					snippet_context_num_words +
					snippet_context_num_syllables +
					snippet_context_num_chars +
					snippet_context_kincaid_score +
					snippet_context_fog_score +
					num_senses_to_disambiguate,
			id = mturk_worker_id,
			corstr = "independence",
			family = "binomial",
			data = dis_without_bad_vals_of_time_spent
	)
	anova(sc_logit_mod_no_corr_worker, sc_logit_mod_corr_worker)
	#ERROR!!!
	
	
	#lm model with random effects for workers
	
	sc_linear_mod_random_worker = lme(correct ~
					target_word_is_noun + 
					target_word_length + 
					log(word_freq) + 
					correct_sense_def_num_rephrasings + 
	#				correct_sense_num_words +
	#				correct_sense_num_syllables + 
					correct_sense_num_chars +
	#				correct_sense_kincaid_score +
	#				correct_sense_fog_score +
	#				snippet_context_num_words +
	#				snippet_context_num_syllables +
					snippet_context_num_chars +
	#				snippet_context_kincaid_score +
	#				snippet_context_fog_score +
					num_senses_to_disambiguate,
			random = reStruct(~ 1 | mturk_worker_id, pdClass="pdSymm", REML = FALSE),
			data = dis_without_bad_vals_of_time_spent
	)
	summary(sc_linear_mod_random_worker)
	
	#Random effects:
	#		Formula: ~1 | mturk_worker_id
	#(Intercept)  Residual
	#StdDev:  0.08758083 0.4143027
	#									Value  		Std.Error DF    t-value p-value
	#(Intercept)                        1.4457037 0.08011676 9128  18.044960  0.0000 ***
	#target_word_is_noun1               0.1073200 0.01183239 9128   9.070016  0.0000 ***
	#target_word_length                -0.0125724 0.00283388 9128  -4.436466  0.0000 ***
	#log(word_freq)                    -0.0403130 0.00485031 9128  -8.311437  0.0000 ***
	#correct_sense_def_num_rephrasings  0.0365556 0.00611358 9128   5.979413  0.0000 ***
	#correct_sense_num_words            0.0202717 0.00603416 9128   3.359483  0.0008 ***
	#correct_sense_num_syllables       -0.0196792 0.00551323 9128  -3.569443  0.0004 ***
	#correct_sense_num_chars            0.0017928 0.00164919 9128   1.087089  0.2770
	#correct_sense_kincaid_score        0.0062988 0.00149707 9128   4.207446  0.0000 ***
	#correct_sense_fog_score           -0.0039268 0.00079150 9128  -4.961161  0.0000 ***
	#snippet_context_num_words          0.0031823 0.00072009 9128   4.419336  0.0000 ***
	#snippet_context_num_syllables      0.0003904 0.00058216 9128   0.670579  0.5025
	#snippet_context_num_chars         -0.0006778 0.00016281 9128  -4.163107  0.0000 ***
	#snippet_context_kincaid_score      0.0100015 0.00382880 9128   2.612184  0.0090 **
	#snippet_context_fog_score         -0.0044019 0.00346953 9128  -1.268722  0.2046
	#num_senses_to_disambiguate        -0.0319223 0.00146628 9128 -21.770852  0.0000 ***
	
	
	#logistic model with random effects for workers
	
	sc_logit_mod_random_worker = lmer(correct ~
					target_word_is_noun + 
					target_word_length + 
					log(word_freq) + 
					correct_sense_def_num_rephrasings + 
	#			correct_sense_num_words +
	#			correct_sense_num_syllables + 
					correct_sense_num_chars +
	#			correct_sense_kincaid_score +
	#			correct_sense_fog_score +
	#			snippet_context_num_words +
	#			snippet_context_num_syllables +
					snippet_context_num_chars +
	#			snippet_context_kincaid_score +
	#			snippet_context_fog_score +
					num_senses_to_disambiguate +
					(1 | mturk_worker_id),
			verbose = TRUE,
			family = "binomial",
			data = dis_without_bad_vals_of_time_spent
	)
	summary(sc_logit_mod_random_worker)
	
	#AIC   BIC logLik deviance
	#10330 10452  -5148    10296
	#Random effects:
	#		Groups          Name        Variance Std.Dev.
	#mturk_worker_id (Intercept) 0.16242  0.40302 
	#Number of obs: 9736, groups: mturk_worker_id, 593
	#
	#Fixed effects:
	#		Estimate Std. Error z value Pr(>|z|)    
	#(Intercept)                        5.004643   0.471625  10.611  < 2e-16 ***
	#target_word_is_noun1               0.571841   0.068951   8.293  < 2e-16 ***
	#target_word_length                -0.078904   0.017066  -4.624 3.77e-06 ***
	#log(word_freq)                    -0.224256   0.027963  -8.020 1.06e-15 ***
	#correct_sense_def_num_rephrasings  0.218465   0.035585   6.139 8.29e-10 ***
	#correct_sense_num_words            0.076370   0.033919   2.252  0.02435 *  
	#correct_sense_num_syllables       -0.090368   0.031111  -2.905  0.00368 ** 
	#correct_sense_num_chars            0.009755   0.009195   1.061  0.28871    
	#correct_sense_kincaid_score        0.028626   0.008986   3.186  0.00144 ** 
	#correct_sense_fog_score           -0.021207   0.004621  -4.589 4.46e-06 ***
	#snippet_context_num_words          0.018368   0.004176   4.399 1.09e-05 ***
	#snippet_context_num_syllables      0.002063   0.003340   0.618  0.53684    
	#snippet_context_num_chars         -0.003778   0.000937  -4.032 5.52e-05 ***
	#snippet_context_kincaid_score      0.071377   0.023338   3.058  0.00223 ** 
	#snippet_context_fog_score         -0.035697   0.020780  -1.718  0.08583 .  
	#num_senses_to_disambiguate        -0.161242   0.008071 -19.978  < 2e-16 ***
	
	
	
	
	
	
	AIC(sc_linear_mod_fixed_worker)
	AIC(sc_logit_mod_fixed_worker)
	AIC(sc_linear_mod_corr_worker)
	AIC(sc_logit_mod_corr_worker)
	AIC(sc_linear_mod_random_worker)
	AIC(sc_logit_mod_random_worker)
	
	#hundred std Bernoulli trials = y now 
	#1) compute estimate of AIC the normal mean 
	#2) copmute estimate of AIC under binomial model
	
	#n_sim = 1000
	#ps = seq(from = 0.01, to = .99, by = 0.025)
	#results = matrix(NA, nrow = length(ps), ncol = 3)
	#colnames(results) = c("AIC Linear Model", "AIC Logistic Model", "LM better?")
	#rownames(results) = paste("p =", ps)
	#
	#for (i in 1 : length(ps)){
	#	y = ifelse(runif(n_sim) < ps[i], 1, 0)
	#	lm_mod = lm(y ~ 1)
	#	results[i, 1] = AIC(lm_mod)
	#	logit_mod = glm(y ~ 1, family = "binomial")
	#	results[i, 2] = AIC(logit_mod)
	#	results[i, 3] = AIC(lm_mod) < AIC(logit_mod)
	#}

}