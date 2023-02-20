#! /bin/bash

dir_with_problems="./uf20-91/*"; # ./uf50-218/* ./uf75-325/*

num_of_tries=10000;

gsat_p=0.4;

sat_cm=0;
sat_cb=2.3;
sat_seeder=$(date +%N);

for ((num_of_repeat=1; num_of_repeat<=10000; num_of_repeat++))
do
	for FILE in $dir_with_problems
	do
	./algorithms/Prob_SAT/probSAT --runs $num_of_tries --fct $sat_cm --cb $sat_cb "$FILE" $sat_seeder >> "results/prob_sat_results.txt";
	./algorithms/gsat "$FILE" -i $num_of_tries -r time -p $gsat_p 2>> "results/g_sat_results.txt" 1>/dev/null;
	done
	echo ">>> executing $num_of_repeat/10000";
done
