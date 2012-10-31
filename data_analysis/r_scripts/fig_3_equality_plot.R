
raw_pct_corr = sum(worker_summ$num_correct) / sum(worker_summ$num_disambiguations)


ALPHA = 0.05

par(mar = c(4, 4, 0, 0.01), oma = c(1, 1, 1, 1), mfrow = c(1, 1))
plot(worker_summ$num_disambiguations, worker_summ$num_correct / worker_summ$num_disambiguations, 
		xaxs = "i", yaxs = "i",
		xlab = "Number of Disambiguations Completed",
		ylab = "Accuracy (%)",
		xaxt = "n",
		yaxt = "n",
		xlim = c(0, 425),
		ylim = c(0, 1),
		type = "n",
		cex = 0.7)
#now do Clopper-Pearson exact CI's (assume iid bernoulli for each of the WSD tasks)
for (w in 1 : W){
	nt = worker_summ$num_disambiguations[w]
	nc = worker_summ$num_correct[w]
	phat = nc / nt
	ci = exactci(nc, nt, 1 - ALPHA / W)
	ci_a = ci[1][[1]][1]
	ci_b = ci[1][[1]][2]
	ci_non_bc = exactci(nc, nt, 1 - ALPHA)
	ci_non_bc_a = ci_non_bc[1][[1]][1]
	ci_non_bc_b = ci_non_bc[1][[1]][2]	
	segments(nt, ci_a, nt, ci_b, col = ifelse(ci_a <= raw_pct_corr && ci_b >= raw_pct_corr, ifelse(ci_non_bc_a <= raw_pct_corr && ci_non_bc_b >= raw_pct_corr, rgb(0,0.6,0), rgb(0.8,0.8,0)), rgb(0.8,0,0)), lwd = 2.5)
}

#abline(a = worker_acc_mod$coefficients[1], b = worker_acc_mod$coefficients[2])
abline(h = raw_pct_corr)
#abline(a = 0, b = 0.5, col = "purple")

for (w in 1 : W){
	nt = worker_summ$num_disambiguations[w]
	nc = worker_summ$num_correct[w]
	points(nt, nc / nt, cex = 0.5)
}





#power calculation for equality fig
n = 50
pstar = sqrt(.255*(1-.255) / n) * 1.69 + .255
(-.84 * .5 / (pstar - .5))^2


num_rand_correct = 0

for (i in 1 : nrow(dis)){
	ns = dis$num_senses_to_disambiguate[i]
	num_rand_correct = num_rand_correct + ifelse(sample(1 : ns, 1) == 1, 1, 0)
}

prop_rand_corr = num_rand_correct / nrow(dis)

abline(h = prop_rand_corr, col = "purple")

axis(1, c(0, 20, 50, 100, 150, 200, 250, 300, 350, 400))
axis(2, c(0, prop_rand_corr, 0.5, raw_pct_corr, 1), c("0", "Random", "50", "Average", "100"))

#plot not included in paper
#plot(jitter(worker_summ$num_disambiguations), jitter(worker_summ$num_correct), 
#		xaxs = "i", yaxs = "i",
#		xlab = "Number of Disambiguations Completed",
#		ylab = "Number of Disambiguations Correct",
#		xlim = c(0, 50),
#		ylim = c(0, 50),
#		cex = 0.7)
#abline(a = 0, b = 1, col = "blue")
#abline(a = worker_acc_mod$coefficients[1], b = worker_acc_mod$coefficients[2], col="green")
#abline(a = 0, b = 0.5, col = "red")
#
#plot(jitter(num_corr_by_snippet$num_senses), jitter(num_corr_by_snippet$num_correct))
#word_acc_mod = lm(num_correct ~ num_senses + word, num_corr_by_snippet)
#summary(word_acc_mod)

#other tests not included in paper

#do pvals accd to the binomial test, then do cochran's test to see if an iid model works
#TAKES A REALLY LONG TIME
#possible_prob_correct = seq(from = 0.6, to = 0.8, by = 0.1) #replace is by = 0.001 for the real deal
#cochran_pvals = array(NA, length(possible_prob_correct))
#for (i in 1 : length(possible_prob_correct)){
#	prob_success = possible_prob_correct[i]
#	pvals = array(NA, W)
#	for (w in 1 : W){
#		nc = worker_summ[w, ]$num_correct
#		nt = worker_summ[w, ]$num_disambiguations
#		pval = binom.test(nc, nt, prob_success, alternative = "two.sided")$p.value
#		pvals[w] = pval
#		if (pval * 595 < 0.05){
#			print(paste(ifelse(nc / nt < prob_success, "LOW", "HIGH"), "nt", nt, "nc", nc, "log_pval", log(pval) / log(10), "worker #", w))
#		}
#	}
#	#calculate_cochran_global_pval
#	chi_sq = sum(-2 * log(pvals))
#	cochran_pvals[i] = 1 - pchisq(chi_sq, 2 * W)
#}
#plot(possible_prob_correct, cochran_pvals, 
#		xlab = "probability of selecting correct answer",
#		xlim = c(0.6, 0.8),
#		ylab = "p-val of Cochran's Test",
#		type = "l")
#abline(h = 0.05, col = "green")
#abline(v = raw_pct_corr, col = "blue")
##get credible region at alpha = 5%
#all_credible_ps = possible_prob_correct[cochran_pvals > 0.05]
#c(min(all_credible_ps), max(all_credible_ps))
#
#
#
##power for figure
#h = ES.h(prop_rand_corr, 0.5)
#pwr.p.test(h = h, n = NULL, power = 0.8, sig.level = 0.05 / W, alternative = "less")

