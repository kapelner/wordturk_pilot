#now investigate inter-annotator agreement (ITA)

#use Kripp alpha
irr_matrix = matrix(NA, nrow = W, ncol = S)
rownames(irr_matrix) = as.character(workers)
colnames(irr_matrix) = as.character(snippets$id)
#now fill it in
for (i in 1 : nrow(dis)){
	single_dis = dis[i, ]
	irr_matrix[as.character(single_dis$mturk_worker_id), as.character(single_dis$snippet_id)] = single_dis$response_sense_id
}


#warning: takes a long time, so I've left it commented out...
#kripp_alpha = kripp.alpha(irr_matrix, method = "nominal")

#use naive sampling
N_sim = 100 #change this to 100000 to really measure it
ita_agreements = array(NA, N_sim)
for (n_sim in 1 : N_sim){
	#pick a random snippet
	snippet_id = sample(snippets$id, 1)
	diss = dis[dis$snippet_id == snippet_id, ]
	#pick two random disambiguation answers
	responses = sample(diss$response_sense_id, 2)
	ita_agreements[n_sim] = (responses[1] == responses[2])
}
sum(ita_agreements) / N_sim



#use Kripp alpha for separate nouns / verbs
irr_matrix_n = matrix(NA, nrow = W, ncol = S)
rownames(irr_matrix_n) = as.character(workers)
colnames(irr_matrix_n) = as.character(snippets$id)
irr_matrix_v = matrix(NA, nrow = W, ncol = S)
rownames(irr_matrix_v) = as.character(workers)
colnames(irr_matrix_v) = as.character(snippets$id)
#now fill it in
for (i in 1 : nrow(dis)){
	single_dis = dis[i, ]
	if (single_dis$target_word_is_noun == 1){
		irr_matrix_n[as.character(single_dis$mturk_worker_id), as.character(single_dis$snippet_id)] = single_dis$response_sense_id
	}
	else {
		irr_matrix_v[as.character(single_dis$mturk_worker_id), as.character(single_dis$snippet_id)] = single_dis$response_sense_id
	}
}

kripp_alpha_n = kripp.alpha(irr_matrix_n, method = "nominal")
kripp_alpha_v = kripp.alpha(irr_matrix_v, method = "nominal")

