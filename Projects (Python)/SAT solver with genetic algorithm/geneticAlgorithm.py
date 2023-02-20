from scipy.stats import rankdata
import pandas as pd
import numpy as np
import random
import time

def createInitialPop(populationSize, chromSize):
    population = []

    # create a population of 'populationSize' chromosomes
    # each chromosome represent a single SAT solution for 'chromSize' number of variables
    for _ in range(populationSize):
        chromosome = [random.randint(0, 1) for _ in range(chromSize)]
        population.append(chromosome)

    return population

def evaluateClauses(chromosome, clauses):
    satisfiedClauses = []

    # check each clause if it is satisfied or no
    for clause in clauses:
        # get each variable value in clause: a XNOR b
        #                                    a:    0 for negated variable      1 for usual variable
        #                                    b:    variable value in chromosome
        variables = [int(not ((index > 0) ^ bool(chromosome[np.absolute(index)-1]))) for index in clause]
        # append 1 if there is at least one 'true' variable, else append 0 for unsatisfied clause
        satisfiedClauses.append(int(1 in variables))

    return satisfiedClauses

def evaluatePopulation(population, task):
    fitness = []

    # calculate fitness value for each chromosome in population
    for chromosome in population:
        # check how many clauses are satisfied
        satisfiedClauses = (np.array(evaluateClauses(chromosome, task.allClauses)) == 1).sum()
        isSatisfiedAllClauses = satisfiedClauses == task.numClauses

        # if all clauses are True
        if isSatisfiedAllClauses:
            # fitness of chromosome is the sum of each variable weight
            f = task.numClauses + 1
            for index in range(task.numVariables):
                f += chromosome[index] * task.variableWeights[index]
        else:
            # fitness of chromosome is the number of satisfied clauses
            f = satisfiedClauses + 1

        fitness.append(f)

    return fitness

def selectSolution(population, fitness, task):
    # find the chromosome with the biggest fitness value
    bestFitnessIndex = np.argmax(np.array(fitness))
    bestFitness = fitness[bestFitnessIndex]
    bestChromosome = population[bestFitnessIndex]

    # count actual weight of current solution
    bestWeight = 0
    # check if all clauses are satisfied
    satisfiedClauses = (np.array(evaluateClauses(bestChromosome, task.allClauses)) == 1).sum()
    isSatisfiedAllClauses = satisfiedClauses == task.numClauses
    # if all clauses are True
    if isSatisfiedAllClauses:
        for index in range(task.numVariables):
            bestWeight += bestChromosome[index] * task.variableWeights[index]

    return bestChromosome, bestWeight, bestFitness

def selectParent(population, populationSize, fitness, method):
    if method == "Tournament":  # Tournament Selection
        chromArray = []
        fitnessArray = []
        # choosing 3 random chromosomes and their fitness values
        for _ in range(0, 3):
            index = random.randint(0, populationSize - 1)
            chromArray.append(population[index])
            fitnessArray.append(fitness[index])

        # find the chromosome with the biggest fitness value
        bestFitnessIndex = np.argmax(np.array(fitnessArray))
        selectedChromosome = chromArray[bestFitnessIndex]

        return selectedChromosome

    elif method == "Roulette Wheel": # Roulette Wheel Selection
        # count the probabilities for each chromosome
        totalFitness = sum(fitness)
        chromosomeProbabilities = [f/totalFitness for f in fitness]

        selectedChromIndex = np.random.choice([index for index in range(populationSize)], p=chromosomeProbabilities)

        return population[selectedChromIndex]

    else: # Rank Selection
        # count rank value for each chromosome
        chromosomeRank = (rankdata(np.array(fitness)) - 1).astype(int)
        totalRank = sum(chromosomeRank)
        chromosomeProbabilities = [r/totalRank for r in chromosomeRank]

        selectedChromIndex = np.random.choice([index for index in range(populationSize)], p=chromosomeProbabilities)

        return population[selectedChromIndex]

def performCrossover(parent_1, parent_2, chromSize, method):
    chrom_1 = []
    chrom_2 = []

    if method == "Uniform": # Uniform Crossover
        # choosing 'the starting' parent
        parents = [parent_1, parent_2]
        parentChoice = random.randint(0, 1)

        # for each gene we decide if we swap it or no
        for index in range(chromSize):
            if random.random() < 0.5:
                chrom_1.append(parents[parentChoice][index])
                chrom_2.append(parents[1 - parentChoice][index])
            else:
                chrom_1.append(parents[1 - parentChoice][index])
                chrom_2.append(parents[parentChoice][index])

    else: # Single Point Crossover
        # choosing one breaking (crossover) point
        index = random.randrange(0, chromSize)

        chrom_1 = parent_1[:index] + parent_2[index:]
        chrom_2 = parent_2[:index] + parent_1[index:]

    return chrom_1, chrom_2

def performMutation(chromosome, chromSize, mutationRate):
    # try with 25% of genes
    for _ in range(chromSize // 4):
        # perform mutation in chromosome with the probability of mutationRate
        if (random.random() < mutationRate):
            # choosing the gene to be mutated
            index = random.randrange(0, chromSize)

            chance = random.random()
            # bit flip mutation
            if chance < 0.3:
                chromosome[index] = 1 - chromosome[index]

            # swap mutation
            elif chance < 0.7:
                index_2 = random.randrange(0, chromSize)
                while index_2 == index:
                    index_2 = random.randrange(0, chromSize)
                temp = chromosome[index_2]
                chromosome[index_2] = chromosome[index]
                chromosome[index] = temp

            # scramble mutation
            else:
                left = random.randrange(0, chromSize)
                right = random.randrange(left, chromSize)
                temp = chromosome[left:right]
                random.shuffle(temp)
                chromosome[left:right] = temp

def geneticAlgorithm(task, maxGenerations, populationSize, parentSelectionMethod, crossoverMethod, crossoverRate, minMutationRate, maxMutationRate, DEBUG=True):
    chromSize = task.numVariables
    mutationRate = minMutationRate
    optChromosome = [int(variable > 0) for variable in task.optSolution] # binarize optimal solution
    maxFitness = evaluatePopulation([optChromosome], task)[0]
    maxWeight = task.optWeight
    progress = pd.DataFrame(columns=["Generation", "maxFitness", "maxWeight", "bestFitness", "bestWeight", "avgFitness", "minFitness", "mutationRate"])
    generation = 1

    # initializing
    start = time.time()
    population = createInitialPop(populationSize, chromSize)

    # calculate how good our population is
    fitness = evaluatePopulation(population, task)

    # get the best population chromosome
    bestChromosome, bestWeight, bestFitness = selectSolution(population, fitness, task)
    # other population metrics
    minFitness = min(fitness)
    avgFitness = np.mean(np.array(fitness))

    # find a solution till it doesn't satisfies our task or till the maximum number of tries
    while (generation < maxGenerations) and ((bestWeight < maxWeight) or (bestFitness < maxFitness)):
        if DEBUG:
            print('> %4d GENERATION\t\tmax fitness: %7.2f, best fitness: %7.2f, max weight: %6d, best weight: %6d, avg fitness: %7.2f, min fitness: %7.2f, mutation rate: %4.2f' % (generation, maxFitness, bestFitness, maxWeight, bestWeight, avgFitness, minFitness, mutationRate))
        data = {"Generation": [generation], "maxFitness": [maxFitness], "maxWeight": [maxWeight], "bestFitness": [bestFitness], "bestWeight": [bestWeight], "avgFitness": [avgFitness], "minFitness": [minFitness], "mutationRate": [mutationRate]}
        progress = pd.concat([progress, pd.DataFrame(data)], ignore_index=True)

        # initializing new population
        newPopulation = []

        # adding top 3 chromosomes to the new population
        popArray = population[:]
        fitArray = fitness[:]
        numTop = 3
        for _ in range(numTop):
            bestFitnessIndex = np.argmax(np.array(fitArray))
            selectedChromosome = popArray[bestFitnessIndex]

            newPopulation.append(selectedChromosome)

            fitArray.pop(bestFitnessIndex)
            popArray.pop(bestFitnessIndex)

        # creating new children
        for _ in range((populationSize - numTop) // 2):
            # if we want to perform crossover
            if random.random() < crossoverRate:
                # select parents
                parent_1 = selectParent(population, populationSize, fitness, parentSelectionMethod)
                parent_2 = selectParent(population, populationSize, fitness, parentSelectionMethod)

                # create children
                child_1, child_2 = performCrossover(parent_1, parent_2, chromSize, crossoverMethod)

                # perform mutation with some mutationRate
                performMutation(child_1, chromSize, mutationRate)
                performMutation(child_2, chromSize, mutationRate)

                # add new children to the population
                newPopulation.append(child_1)
                newPopulation.append(child_2)

        # if the size of newPopulation is smaller
        while len(newPopulation) < populationSize:
            # add random chromosome from the previous population
            newPopulation.append(selectParent(population, populationSize, fitness, parentSelectionMethod))

        # recalculating our results
        population = newPopulation
        fitness = evaluatePopulation(population, task)

        prevAvgFitness = avgFitness
        bestChromosome, bestWeight, bestFitness = selectSolution(population, fitness, task)
        minFitness = min(fitness)
        avgFitness = np.mean(np.array(fitness))

        # in case avgFitness value is not changing for too long - increase mutationRate
        if abs((prevAvgFitness - avgFitness) / prevAvgFitness) < 0.02:
            if mutationRate < maxMutationRate:
                mutationRate += 0.01
            elif minMutationRate < maxMutationRate:
                # reset mutation rate
                mutationRate = minMutationRate

                # reset the whole population
                population = createInitialPop(populationSize, chromSize)
                fitness = evaluatePopulation(population, task)
                bestChromosome, bestWeight, bestFitness = selectSolution(population, fitness, task)
                minFitness = min(fitness)
                avgFitness = np.mean(np.array(fitness))
        else:
            mutationRate = minMutationRate

        # next generation
        generation += 1

    if DEBUG:
        print('> %4d GENERATION\t\tmax fitness: %7.2f, best fitness: %7.2f, max weight: %6d, best weight: %6d, avg fitness: %7.2f, min fitness: %7.2f, mutation rate: %4.2f' % (generation, maxFitness, bestFitness, maxWeight, bestWeight, avgFitness, minFitness, mutationRate))
    data = {"Generation": [generation], "maxFitness": [maxFitness], "maxWeight": [maxWeight], "bestFitness": [bestFitness], "bestWeight": [bestWeight], "avgFitness": [avgFitness], "minFitness": [minFitness], "mutationRate": [mutationRate]}
    progress = pd.concat([progress, pd.DataFrame(data)], ignore_index=True)

    end = time.time()
    duration = end - start
    isSolutionFound = bestWeight >= maxWeight

    if DEBUG:
        print("\n\n> SOLUTION WAS FOUND") if isSolutionFound else print("\n\n> SOLUTION WAS NOT FOUND")
        print("> TOTAL TIME: %.4f (s)\t\tNUMBER OF GENERATIONS: %d" % (duration, generation))

    return progress, duration, isSolutionFound