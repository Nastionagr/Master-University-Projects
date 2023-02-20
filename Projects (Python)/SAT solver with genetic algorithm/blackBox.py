import os
import sys
import warnings
warnings.filterwarnings("ignore")
import pandas as pd
from dataParser import define_tasks
from geneticAlgorithm import geneticAlgorithm

# path to the input data
INPUT_PATH = "C:/Users/Nastia/Desktop/FIT/KOP/ukol_2/data_black_box/"
RESULTS_PATH = "C:/Users/Nastia/Desktop/FIT/KOP/ukol_2/results/"

# the most optimal parameters
maxGenerations = 500
populationSize = 200
parentSelectionMethod = "Tournament"
crossoverMethod = "Uniform"
crossoverRate = 0.8
minMutationRate = 0.02
maxMutationRate = 0.3

# defining all SAT problems
tasks = []
for directory in os.listdir(INPUT_PATH)[int(sys.argv[1]) : int(sys.argv[1])+1]:
    directory = os.path.join(INPUT_PATH, directory)
    tasks += define_tasks(directory)
print("> All SAT problems were loaded.")

results = pd.DataFrame(columns=["Task", "numVariables", "numClauses", "endGeneration", "Duration", "isSolutionFound"])
for task in tasks:
    print()
    print("> Calculating the solution of " + task.fileName)

    progress, duration, isSolutionFound = geneticAlgorithm(task, maxGenerations, populationSize, parentSelectionMethod, crossoverMethod, crossoverRate, minMutationRate, maxMutationRate, False)
    endGeneration = progress["Generation"].iat[-1]
    # ["Generation", "maxFitness", "bestFitness", "avgFitness", "minFitness", "mutationRate"]

    # remember the results for a future comparison
    data = {"Task":[task.fileName], "numVariables":[task.numVariables], "numClauses":[task.numClauses], "Duration":[duration], "isSolutionFound":[isSolutionFound],
            "endGeneration":[endGeneration], "optWeight":[task.optWeight], "bestWeight":[progress["bestWeight"].max()],
            "maxMutation":[progress["mutationRate"].max()]}
    results = pd.concat([results, pd.DataFrame(data)], ignore_index=True)

    print("> Solution was found") if isSolutionFound else print("> Solution was NOT found")
    print('> endGeneration: %4d, duration: %4f' % (endGeneration, duration))

    results.to_csv(RESULTS_PATH + "big_results_" + sys.argv[1])