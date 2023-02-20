# G-SAT and Prob-SAT Comparison _(by Anastasiia Hrytsyna)_

## Content of the folder

-  **algorithms** - 2 main algorithms for a comparison
   -  Prob_SAT ([source to the original code](https://github.com/adrianopolus/probSAT "click here to open the source code in GitHub")) (\* don't forget to run `make` command to build an algorithm)
   -  gsat ([source from NI-KOP](https://courses.fit.cvut.cz/NI-KOP/download/index.html "click here to download gsat from Courses"))
-  **data** ([source](https://www.cs.ubc.ca/~hoos/SATLIB/benchm.html "click here to download some data")) - an input to the algorithms
   -  uf20-91.zip - 20 variables, 91 clauses
   -  uf50-218.zip
   -  uf75-325.zip
-  **results** - solutions of each algorithm to an exact set of problems
   -  20_g_sat_results.txt
   -  20_prob_sat_results.txt
   -  50_g_sat_results.txt
   -  50_prob_sat_results.txt
   -  75_g_sat_results.txt
   -  75_prob_sat_results.txt
-  **generate_results.sh** - short script to run both algorithms
-  probsat_data_cleaning.txt - bash commands that hepls to clean ProbSAT algorithm output
-  **results_comparison.ipynb** - the main code (practical part) for examination
-  rows_to_delete - helper for probsat_data_cleaning.txt
-  **hrytsyna_examination.pdf** - final report
