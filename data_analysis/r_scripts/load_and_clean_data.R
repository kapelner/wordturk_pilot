#set your directory here
setwd("C:/Users/kapelner/Documents/NetBeansProjects/foster-kapelner-wordturkers/data_analysis")

#####
##### libraries
#####

tryCatch(library(PropCIs), error = function(e){install.packages("PropCIs")}, finally = library(PropCIs))
tryCatch(library(irr), error = function(e){install.packages("irr")}, finally = library(irr))
tryCatch(library(pwr), error = function(e){install.packages("pwr")}, finally = library(pwr))

#####
##### load all data from raw files
#####

words_by_snippets = read.csv("words_by_num_snippets.csv")
dis = read.csv("disambiguations_dump_08_14_12__14_07.csv")
snippets = read.csv("snippets_dump_11_21_11__19_05.csv")
senses = read.csv("senses_dump_02_22_12__21_21.csv")
word_freq_data = read.csv("word_freq_from_coca.csv", header = TRUE)

#####
##### Clean up all data
#####

#now kill the trimmings and convert it to a data frame
words_by_snippets = as.data.frame(words_by_snippets[1:100, ])
for (j in 2 : ncol(words_by_snippets)){
	words_by_snippets[, j] = as.numeric(as.character(words_by_snippets[, j]))
}

#format snippets table
snippets$word = as.character(snippets$word)
#kill snippets that have one sense
snippets = snippets[!(snippets$word %in% c("hope", "cause", "improve", "estimate", "purchase")), ]
S = nrow(snippets)

#format disambiguations
dis$created_at_time = as.numeric(dis$created_at_time)
dis$expired_at_time = as.numeric(dis$expired_at_time)
dis$started_at_time = as.numeric(dis$started_at_time)
dis$read_consent_at_time = as.numeric(dis$read_consent_at_time)
dis$finished_at_time = as.numeric(dis$finished_at_time)
dis$time_to_read_consent = as.numeric(dis$time_to_read_consent)
dis$time_spent = as.numeric(dis$time_spent)
dis$mturk_worker_id = as.factor(dis$mturk_worker_id)
dis$comments_text = as.character(dis$comments_text)
dis$comments_word_count = as.numeric(dis$comments_word_count)
dis$worker_left_comment = as.numeric(dis$worker_left_comment)
dis$comments_word_count_total = as.numeric(dis$comments_word_count_total)
dis$comments_word_count_average = as.numeric(dis$comments_word_count_average)
dis$num_disambiguations_by_worker = as.numeric(dis$num_disambiguations_by_worker)
dis$worker_did_more_than_one = as.factor(dis$worker_did_more_than_one)
dis$worker_did_more_than_two = as.factor(dis$worker_did_more_than_two)
dis$worker_did_more_than_three = as.factor(dis$worker_did_more_than_three)
dis$worker_did_more_than_four = as.factor(dis$worker_did_more_than_four)
dis$worker_did_more_than_five = as.factor(dis$worker_did_more_than_five)
dis$snippet_id = as.factor(dis$snippet_id)
dis$corresct_sense_id = as.numeric(dis$corresct_sense_id)
dis$snippet_context_num_words = as.numeric(dis$snippet_context_num_words)
dis$snippet_context_num_syllables = as.numeric(dis$snippet_context_num_syllables)
dis$snippet_context_num_chars = as.numeric(dis$snippet_context_num_chars)
dis$snippet_context_kincaid_score = as.numeric(dis$snippet_context_kincaid_score)
dis$snippet_context_fog_score = as.numeric(dis$snippet_context_fog_score)
dis$target_word = as.factor(dis$target_word)
dis$target_word_length = as.numeric(dis$target_word_length)
dis$target_word_is_noun = as.numeric(dis$target_word_is_noun)
dis$num_senses_to_disambiguate = as.numeric(dis$num_senses_to_disambiguate)
dis$correct_sense_num_words = as.numeric(dis$correct_sense_num_words)
dis$correct_sense_num_syllables = as.numeric(dis$correct_sense_num_syllables)
dis$correct_sense_num_chars = as.numeric(dis$correct_sense_num_chars)
dis$correct_sense_kincaid_score = as.numeric(dis$correct_sense_kincaid_score)
dis$correct_sense_fog_score = as.numeric(dis$correct_sense_fog_score)
dis$response_sense_id = as.numeric(dis$response_sense_id)
dis$correct = as.numeric(dis$correct)





#add word freq's to dis
N = nrow(dis)
word_freq = array(NA, N)

for (i in 1:N) {
	word_freq[i] = word_freq_data[word_freq_data$Word == as.character(dis$target_word[i]),]$Frequency
}

dis = cbind(dis, word_freq)

#format senses table
senses$word = as.character(senses$word)

#kill disambiguations that are not on the exp snippets list (these were the first few test runs that accidentally went live, oops)
i = 1
while (i < nrow(dis)){
	disamb_snippet_id = dis[i, "snippet_id"]
	exp_snippet = snippets[snippets$id == disamb_snippet_id, ]
	if (nrow(exp_snippet) != 1){
#		print("deleting disambiguation row that is non-experimental...")
		dis = dis[-i, ]
		i = 1
	}
	else {
		i = i + 1
	}
}


num_corr_by_snippet = as.data.frame(matrix(NA, ncol = 4, nrow = S))
colnames(num_corr_by_snippet) = c("word", "snippet_id", "num_senses", "num_correct")
for (i in 1 : S){
	num_corr_by_snippet[i, "word"] = snippets[i, "word"]
	num_corr_by_snippet[i, "snippet_id"] = snippets[i, "id"]
	word_senses = senses[senses$word == snippets[i, "word"], ]
	num_corr_by_snippet[i, "num_senses"] = nrow(word_senses)
	snippet_disambiguations = dis[dis$snippet_id == snippets[i, "id"], ]
	if (nrow(snippet_disambiguations) ==  11){
#		print(paste("WARNING  snippet id: ", snippets[i, "id"], "word", snippets[i, "word"], "num dis:", nrow(snippet_disambiguations), "!= 10  DELETING FIRST ROW"))
		id_to_kill = snippet_disambiguations[1, "id"]
		row_to_kill = which(dis$id == snippet_disambiguations[1, "id"], arr.ind=T)
#		print(paste("row to kill:", which(dis$id == snippet_disambiguations[1, "id"], arr.ind=T)))
		dis = dis[-row_to_kill, ]
	}
	snippet_disambiguations = dis[dis$snippet_id == snippets[i, "id"], ]
	num_corr_by_snippet[i, "num_correct"] = sum(snippet_disambiguations$correct)
}


#some global data that's useful
workers = unique(dis$mturk_worker_id)
W = length(workers)

n_dis = nrow(dis)

#comments table
comments = as.data.frame(matrix(NA, ncol = 4, nrow = 0))
for (i in 1 : n_dis){
	comment = dis$comments_text[i]
	if (comment != ""){
		comments = rbind(comments, matrix(c(dis$mturk_worker_id[i], dis$snippet_id[i],dis$comments_word_count[i], comment), nrow = 1))
	}
}
colnames(comments) = c("mturk_worker_id", "snippet_id", "comments_word_count", "comment")
comments$mturk_worker_id = as.character(comments$mturk_worker_id)
comments$comment = as.character(comments$comment)
comments$comments_word_count = as.numeric(comments$comments_word_count)

#worker summary table
worker_summ = as.data.frame(matrix(NA, ncol = 6, nrow = length(workers)))
for (i in 1 : length(workers)){
	worker = workers[i]
	worker_disambiguations = dis[worker == dis$mturk_worker_id, ]
	first_dis = worker_disambiguations[1, ]
	worker_summ[i, ] = c(first_dis$mturk_worker_id, first_dis$read_consent_at_time, sum(worker_disambiguations$comments_word_count), nrow(worker_disambiguations), sum(worker_disambiguations$correct), sum(worker_disambiguations$correct) / nrow(worker_disambiguations))
}
colnames(worker_summ) = c("mturk_worker_id", "read_consent_at_time", "total_words_in_comments", "num_disambiguations", "num_correct", "pct_correct")
worker_summ$mturk_worker_id = as.character(worker_summ$mturk_worker_id)
worker_summ$read_consent_at_time = as.numeric(worker_summ$read_consent_at_time)
worker_summ$total_words_in_comments = as.numeric(worker_summ$total_words_in_comments)
worker_summ$num_disambiguations = as.numeric(worker_summ$num_disambiguations)
worker_summ$num_correct = as.numeric(worker_summ$num_correct)
worker_summ$pct_correct = as.numeric(worker_summ$pct_correct)

#add num mini-defs in basic def to dis
correct_sense_def_num_rephrasings = array(NA, nrow(senses))

for (i in 1 : nrow(senses)){
	correct_sense_def_num_rephrasings[i] = length(strsplit(as.character(senses$definition_text[i]), "<com>")[[1]])
}

senses = cbind(senses, correct_sense_def_num_rephrasings)
correct_sense_def_num_rephrasings = array(1, nrow(dis))
for (i in 1 : nrow(dis)){
	num_rephrasings = senses[senses$id == dis$corresct_sense_id[i],]$correct_sense_def_num_rephrasings
	correct_sense_def_num_rephrasings[i] = num_rephrasings
}

dis = cbind(dis, correct_sense_def_num_rephrasings)


#how long did this study take in hours?
study_time_in_hrs = round((max(dis$started_at) - min(dis$started_at)) / 3600, 1)


#add a variable ordinal number of task
dis$task_ord_number = NA
for (worker_id in workers){
	dis_for_worker = dis[dis$mturk_worker_id == worker_id, ]
	for (i in 1 : nrow(dis_for_worker)){
		dis[dis$id == dis_for_worker$id[i], "task_ord_number"] = i
	}
}



