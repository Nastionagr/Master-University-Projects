import os

class ProblemMWSAT:
    def __init__(self, fileName, numVariables, numClauses, optWeight, optSolution, variableWeights, allClauses):
        self.fileName = fileName
        self.numVariables = numVariables
        self.numClauses = numClauses
        self.optWeight = optWeight
        self.optSolution = optSolution
        self.variableWeights = variableWeights
        self.allClauses = allClauses

def define_single_task(task_path, solution_path):
    name = os.path.basename(task_path)
    v = 0
    c = 0
    optW = 0
    optS = []
    weights = []
    clauses = []

    with open(task_path, "r") as file:
        for line in file:
            if line.startswith("c"): # ignore comments
                continue
            elif line.startswith("p"): # number of variables and clauses
                v = line.split()[2]
                c = line.split()[3]
            elif line.startswith("w"): # variable weights
                weights = line.split()[1:-1]
            else: # clauses
                clauses.append(list(map(int, line.split()[:-1])))

        if v == 0 or c == 0 or len(weights) == 0 or len(clauses) == 0:
            print("Error during reading the file.")

    with open(solution_path, "r") as file:
        for line in file:
            if line.startswith(name.replace(".mwcnf", "").replace("w", "")): # checking the solutions
                optW = line.split()[1] # total weight
                optS = line.split()[2:-1] # total variables settings

        if optW == 0 or len(optS) == 0:
            print("No solution was found.")

    return ProblemMWSAT(name, int(v), int(c), int(optW), list(map(int, optS)), list(map(int, weights)), clauses)

def define_tasks(directory):
    tasks = []

    for filename in os.listdir(directory):
        # check each SAT problem
        task_path = os.path.join(directory, filename) # .replace("\\", "/")
        # find its solution
        solution_path = "C:/Users/Nastia/Desktop/FIT/KOP/ukol_2/data_solutions/" + str(os.path.basename(directory)) + "-opt.dat"
        tasks.append(define_single_task(task_path, solution_path))

    if len(tasks) == 0:
        print("There is no SAT problems to solve.")

    return tasks