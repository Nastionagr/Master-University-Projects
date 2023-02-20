import os
import numpy as np
import pandas as pd
from dataParser import define_tasks
from geneticAlgorithm import geneticAlgorithm

# define path to the necessary folders
INPUT_PATH = "C:/Users/Nastia/Desktop/FIT/KOP/ukol_2/data_white_box/"
RESULTS_PATH = "C:/Users/Nastia/Desktop/FIT/KOP/ukol_2/results/"

# defining all SAT problems
tasks = []
for directory in os.listdir(INPUT_PATH):
    directory = os.path.join(INPUT_PATH, directory)
    tasks += define_tasks(directory)
print("> All SAT problems were loaded.")



#                                                      PARAMETERS                                                      #
#                                                                                                                      #
#     NAME                      TYPE                            RANGE                            TRIED VALUES          #
#                                                                                                                      #
# maxGenerations             int number           (1...)                                       500                     #
# populationSize             int number           (1...)                                       [50, 200]               #
# parentSelectionMethod      category             ("Tournament", "Roulette Wheel", "Rank")     all                     #
# crossoverMethod            category             ("Uniform", "Single Point")                  all                     #
# crossoverRate              float number         (0...1)                                      [0.8, 0.99]             #
# minMutationRate            float number         (0...1)                                      [0.01, 0.02]            #
# maxMutationRate            float number         (0...1)                                      [0, 0.3, 0.9]           #
#                                                                                                                      #

# number of test repetition
testSize = 3
# check all possible combinations of different parameters
maxGenerations = 500
paramCombination = np.array(np.meshgrid([50, 200], ["Tournament", "Roulette Wheel", "Rank"], ["Uniform", "Single Point"], [0.8, 0.99], [0.01, 0.02], [0, 0.3, 0.9])).T.reshape(-1, 6)

results = pd.DataFrame(columns=["Parameters", "Task", "numFoundedSolutions", "avgEndGeneration", "minEndGeneration", "maxEndGeneration", "avgDuration", "minDuration", "maxDuration"])
for num, parameters in enumerate(paramCombination):
    populationSize, parentSelectionMethod, crossoverMethod, crossoverRate, minMutationRate, maxMutationRate = parameters
    populationSize = int(populationSize.plot())
    crossoverRate, minMutationRate, maxMutationRate = [float(v) for v in [crossoverRate, minMutationRate, maxMutationRate]]

    print()
    print("> " + str(num / len(paramCombination) * 100) + " %")
    print("> Selected parameter combination:\t" + str(parameters))

    # for each SAT problem run the algorithm 3 times
    for task in tasks:
        generations = []
        durations = []
        mutations = []
        foundedSolutions = []

        print()
        print("> Calculating the solution of " + task.fileName)
        for _ in range(testSize):
            print()
            progress, duration, isSolutionFound = geneticAlgorithm(task, maxGenerations, populationSize, parentSelectionMethod, crossoverMethod, crossoverRate, minMutationRate, maxMutationRate, True)
            endGeneration = progress["Generation"].iat[-1]

            generations.append(endGeneration)
            durations.append(duration)
            foundedSolutions.append(int(isSolutionFound))
            mutations.extend(progress["mutationRate"].tolist())

        generations = np.array(generations)
        durations = np.array(durations)
        foundedSolutions = np.array(foundedSolutions)
        mutations = np.array(mutations)

        # remember the results for a future comparison
        data = {"Parameters":[parameters], "Task":[task.fileName], "numFoundedSolutions":[np.sum(foundedSolutions)],
                "avgEndGeneration":[np.mean(generations)], "minEndGeneration":[np.min(generations)], "maxEndGeneration":[np.max(generations)],
                "avgDuration":[np.mean(durations)], "minDuration":[np.min(durations)], "maxDuration":[np.max(durations)],
                "minMutationRate":[np.min(mutations)], "maxMutationRate":[np.max(mutations)]}
        results = pd.concat([results, pd.DataFrame(data)], ignore_index=True)

results.to_csv(RESULTS_PATH + "results")