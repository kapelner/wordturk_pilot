### build table 1  
# NOTE: these are random strategies and hence numbers will vary from simulation-simulation

simulate_voting_strat_for_snippet = function(snippet_id) {
    Nsim = 2
    results = c()
    correct_sense_id = snippets[snippets$id == snippet_id, "correct_sense_id"]
    answers = dis[dis$snippet_id == snippet_id, "response_sense_id"]
    N = length(answers)
    
    for (i in 1:Nsim) {

        #randomize order
        sampled_answers = sample(answers, N, replace=FALSE) #we could make this true
        chosen_answer = sampled_answers[1]
        flag = 0
        answers_prev_seen = c(chosen_answer)
        
        for (i in 2:N) { #won't work if we only have one disambiguation
            if(sampled_answers[i] %in% answers_prev_seen && flag == 0) {
                chosen_answer = sampled_answers[i]
                flag = 1
            }
            
            else {
                answers_prev_seen = c(answers_prev_seen, sampled_answers[i])
            }
        }

        if(chosen_answer ==  correct_sense_id) {
            results = c(results, 1)
        }
        
        else {
            results = c(results, 0)
        }
    
    }
    sum(results)/length(results)
}

voting_strat_housing_object = function(n) {
    snippets_pct_correct = c()

    for (s in 1:S) {
        word = snippets[s, "word"]
        numSenses = length(senses[senses$word==word,]$id)

        if(numSenses == n) {
            snippets_pct_correct = c(snippets_pct_correct, simulate_voting_strat_for_snippet(snippets[s, "id"]))
            }
            
    }

    mean(snippets_pct_correct)
}

#####################

### my code here
#n \in {1,2, ..., 10}
simulate_pct_correct_for_snippet = function(snippet_id, n, Nsim = 1000){
	correct_sense_id = snippets[snippets$id == snippet_id, "correct_sense_id"]
	answers = dis[dis$snippet_id == snippet_id, "response_sense_id"]
	correct_sims = array(NA, Nsim)
	for (i in 1 : Nsim){
		sampled_answers = sample(answers, n)
		correct_sims[i] = plurality_vote(sampled_answers) == correct_sense_id
	}
	sum(correct_sims) / Nsim
}

plurality_vote = function(sampled_answers){
	#mapping from sense_id => count for that sense_id
	#we want to find the maximum count
	#we want to get a random sense_id that has that count
    
    #Added by Krishna 1/17:
    #I visulaize sampled_answers as = [264, 264, 25, 264, 264]
    #Would then return 264
    #flaw is in expected value calculation - but okay for Monte Carlo simulation

    to_return = sampled_answers[1]
    numTimes = sum(sampled_answers == sampled_answers[1])
    
    for (i in 1 : length(sampled_answers)){
        tempTimes = sum(sampled_answers == sampled_answers[i])
        if (tempTimes > numTimes) {
            to_return = sampled_answers[i]
            numTimes = tempTimes
        }
    }
    
    to_return    
}


#build housing object to hold results of simulation
results_of_correct_by_num_workers = matrix(NA, nrow = S, ncol = 9)
colnames(results_of_correct_by_num_workers) = paste("num_workers_", seq(from = 1, to = 9), sep = "")

for (s in 1 : S){
	for (num_workers in 1 : 9){
#		print(paste("num_workers =", num_workers, " s = ", s))
		results_of_correct_by_num_workers[s, num_workers] = 
				simulate_pct_correct_for_snippet(snippets[s, "id"], num_workers)
	}
}

prop_correct_by_num_workers = colSums(results_of_correct_by_num_workers) / S

#if you want to see this as a plot (not included in paper)
#plot(1 : 9, prop_correct_by_num_workers, main = "prop of snippets correct by num workers", xlab = "num workers", ylab = "prop snippets correct")




simulate_voting_strat_for_snippet = function(snippet_id) {
	Nsim = 100
	sim_correct = array(NA, Nsim)
	correct_sense_id = snippets[snippets$id == snippet_id, "correct_sense_id"]
	answers = dis[dis$snippet_id == snippet_id, "response_sense_id"]
	N = length(answers)
    
    numWorkersUsed = array(NA, Nsim)
	
	for (sim in 1 : Nsim) {
		
		#randomize order
		sampled_answers = sample(answers, N, replace=FALSE) #we could make this true
		chosen_answer = sampled_answers[1]
		flag = 0
		answers_prev_seen = c(chosen_answer)
		
		for (i in 2 : N) { #won't work if we only have one disambiguation
			if (sampled_answers[i] %in% answers_prev_seen && flag == 0) {
				chosen_answer = sampled_answers[i]
				flag = 1
                break
			}
			
			else {
                if (flag == 0) {
                    answers_prev_seen = c(answers_prev_seen, sampled_answers[i])
                }
            }
		}
		
		if (chosen_answer == correct_sense_id) {
			sim_correct[sim] = 1
		}
		
		else {
			sim_correct[sim] = 0
		}
        
        numWorkersUsed[sim] = length(answers_prev_seen) + 1
		
	}
	c(sum(sim_correct) / length(sim_correct), mean(numWorkersUsed))
}

snippets_pct_correct = array(NA, S)
num_workers_used = array(NA, S)

for (s in 1 : S) {
	snippets_pct_correct[s] = simulate_voting_strat_for_snippet(snippets[s, "id"])[1]
    num_workers_used[s] = simulate_voting_strat_for_snippet(snippets[s, "id"])[2]
}

#numbers for last column of table 4
mean(snippets_pct_correct)  #accuracy
mean(num_workers_used)		#avg num workers
sd(num_workers_used)		#sd


#numbers for table 4, col 2-9, 10th column comes from "total_pct_corr"
prop_correct_by_num_workers
total_pct_corr = sum(dis$correct) / n_dis
total_pct_corr