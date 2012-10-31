#first, run "tab_4_simulate_accuracy_by_num_turkers.R"

dis_without_bad_vals_of_time_spent$y_hat = predict(sc_linear_mod_fixed_worker, dis_without_bad_vals_of_time_spent)


#make list of words and accuracy
unique_words = unique(dis_without_bad_vals_of_time_spent$target_word)
words_and_pred_accuracy = as.data.frame(matrix(NA, nrow = length(unique_words), ncol = 3))
colnames(words_and_pred_accuracy) = c("target_word", "target_word_is_noun", "pred_accuracy")
for (i in 1 : length(unique_words)){
	word = unique_words[i]
	dis_for_word = dis_without_bad_vals_of_time_spent[dis_without_bad_vals_of_time_spent$target_word == word, ]
	is_noun = dis_for_word$target_word_is_noun[1]
	pred_accuracy = round(sum(dis_for_word$y_hat) / nrow(dis_for_word) * 100, 2)
	words_and_pred_accuracy[i, ] = c(as.character(word), is_noun, pred_accuracy)
}
words_and_pred_accuracy$pred_accuracy = as.numeric(words_and_pred_accuracy$pred_accuracy)

#switch the rows of this matrix
words_and_pred_accuracy = words_and_pred_accuracy[sample(nrow(words_and_pred_accuracy)), ]

#add count and num senses to table:
words_and_pred_accuracy$count = NA
words_and_pred_accuracy$num_senses_to_disambiguate = NA

for (i in 1 : length(unique_words)){
	word = words_and_pred_accuracy$target_word[i]
	words_and_pred_accuracy$count[i] = nrow(snippets[snippets$word == word, ])	
	words_and_pred_accuracy$num_senses_to_disambiguate[i] = dis[dis$target_word == word, ][1, ]$num_senses_to_disambiguate
}

par(mar = c(4, 4, 0, 0.01), oma = c(3, 1, 3, 3))
layout(matrix(rep(c(1,1,2), 2), 2, 3, byrow=TRUE))
plot(0, 0, type = "n", 
		ylim = c(min(words_and_pred_accuracy$pred_accuracy), 95), 
		xlim = c(0, max(words_and_pred_accuracy$num_senses_to_disambiguate)),
#		main = "Target Word Predicted Accuracy\n Nouns are in Blue, Verbs are in Red",
		xaxs = "i", yaxs = "i",
		ylab = "Accuracy (%)",
		xlab = "Number of Senses")
for (i in 1 : length(unique_words)){
	word = words_and_pred_accuracy$target_word[i]
	accuracy = words_and_pred_accuracy$pred_accuracy[i]
	target_word_is_noun = words_and_pred_accuracy$target_word_is_noun[i]
	num_senses_to_disambiguate = words_and_pred_accuracy$num_senses_to_disambiguate[i]
	if (runif(1) < 0.3){
		text(jitter(num_senses_to_disambiguate, amount = 1), accuracy, 
				labels = word, 
				cex = 1.5, 
				col = ifelse(target_word_is_noun == 1, "blue", "red"))
	}
}

ALPHA = 0.2


#MACRO AVGS
nouns_and_pred_accuracy_macro = dis_without_bad_vals_of_time_spent[dis_without_bad_vals_of_time_spent$target_word_is_noun == 1, ]$y_hat
verbs_and_pred_accuracy_macro = dis_without_bad_vals_of_time_spent[dis_without_bad_vals_of_time_spent$target_word_is_noun == 0, ]$y_hat
#length(nouns_and_pred_accuracy_macro)
#length(verbs_and_pred_accuracy_macro)

density_nouns = density(nouns_and_pred_accuracy_macro)
density_verbs = density(verbs_and_pred_accuracy_macro)
par(mar = c(4, 0, 0, 0.01))
plot(density_nouns$y, density_nouns$x, 
#	xlim = c(0, max(words_and_pred_accuracy$num_senses_to_disambiguate)),		
	type = "n", bty="n", col = rgb(0, 0, 1, ALPHA), yaxt="n", main = "", 
	xaxt = "n", ylab = "", xlab = "", xaxs = "i", yaxs = "i")
polygon(density_nouns$y, density_nouns$x, 
		xlim = c(0, max(words_and_pred_accuracy$num_senses_to_disambiguate)),
		col = rgb(0, 0, 1, ALPHA), yaxt="n", xaxt = "n", border = NA)
par(new = TRUE)
plot(density_verbs$y, density_verbs$x, 
#	xlim = c(0, max(words_and_pred_accuracy$num_senses_to_disambiguate)),
	type = "n", bty="n", col = rgb(1, 0, 0, ALPHA), 
	yaxt="n", main = "", xaxt = "n", ylab = "", xlab = "", xaxs = "i", yaxs = "i")
polygon(density_verbs$y, density_verbs$x, 
	xlim = c(0, max(words_and_pred_accuracy$num_senses_to_disambiguate)),
	col = rgb(1, 0, 0, ALPHA), yaxt="n", xaxt = "n", border = NA)

 
 
#MICRO AVGS (not used in paper)
#nouns_and_pred_accuracy_micro = words_and_pred_accuracy[words_and_pred_accuracy$target_word_is_noun == 1, ]
#verbs_and_pred_accuracy_micro = words_and_pred_accuracy[words_and_pred_accuracy$target_word_is_noun == 0, ]
#nrow(nouns_and_pred_accuracy_micro)
#nrow(verbs_and_pred_accuracy_micro)
#nrow(words_and_pred_accuracy)
 
#density_nouns = density(nouns_and_pred_accuracy_micro$pred_accuracy)
#density_verbs = density(verbs_and_pred_accuracy_micro$pred_accuracy)
#par(new=TRUE)
#plot(density_nouns, col = rgb(0,0,1,ALPHA), yaxt="n", main = "", xaxt = "n", ylab = "", xlab = "")
#polygon(density_nouns, col = rgb(0,0,1,ALPHA), yaxt="n", xaxt = "n", border = NA)
 ##windows()
#par(new=TRUE)
#plot(density_verbs, col = rgb(1,0,0,ALPHA), yaxt="n", main = "", xaxt = "n", ylab = "", xlab = "")
#polygon(density_verbs, col = rgb(1,0,0,ALPHA), yaxt="n", xaxt = "n", border = NA)