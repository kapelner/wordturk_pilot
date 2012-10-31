
words = unique(dis$target_word)

word_summary = as.data.frame(matrix(NA, nrow = length(words), ncol = 5))
colnames(word_summary) = c("word", "is_noun", "num_instances", "num_senses", "accuracy")

for (i in 1 : length(words)){
	word = words[i]
	diss_word = dis[dis$target_word == word, ]
#  print(diss_word[1, c("target_word", "num_senses_to_disambiguate")])
	is_noun = diss_word[1, "target_word_is_noun"]
	num_senses = diss_word[1, "num_senses_to_disambiguate"]
	num_instances = nrow(snippets[snippets$word == word, ])
	word = paste0(as.character(word), "-", ifelse(is_noun == 1, "n", "v"))
	acc = sum(diss_word$correct) / nrow(diss_word)
	word_summary[i, ] = c(word, is_noun, num_instances, num_senses, round(acc, 2))
}
table(word_summary$accuracy)
word_summary = word_summary[order(word_summary$num_senses), ]
word_summary[word_summary$num_senses == 1, ]$word
word_summary

#sort by is noun
word_summary = word_summary[order(word_summary$word), ]
rownames(word_summary) = NULL
word_summary
dim(word_summary)
#verify we have 1000 different tasks
sum(as.numeric(word_summary$num_instances))


#get num senses +- sd for nouns and verbs
num_senses_nouns = as.numeric(word_summary[word_summary$is_noun == 1, "num_senses"])
mean(num_senses_nouns)
sd(num_senses_nouns)
num_senses_verbs = as.numeric(word_summary[word_summary$is_noun == 0, "num_senses"])
mean(num_senses_verbs)
sd(num_senses_verbs)

ws_out = word_summary[, c(1,3,4)]
ws_out = rbind(ws_out, c("","",""))
ws_out = cbind(ws_out[1 : 30, ], ws_out[31 : 60, ], ws_out[61 : 90, ])

tryCatch(library(xtable), error = function(e){install.packages("xtable")}, finally = library(xtable))
xt = xtable(ws_out)
print(xt, include.rownames = FALSE)



