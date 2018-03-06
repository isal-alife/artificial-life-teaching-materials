

from random import randint, random
import copy


class Chromosome:

    def __init__(self, starting_data, fitness_function, mutation_function):
        self.data = starting_data
        self.fitness_function = fitness_function
        self.mutation_function = mutation_function
        self.fitness = 0.0
        self.evaluate_fitness()

    def __len__(self):
        return len(self.data)

    def mutate(self, at_point=0):
        if at_point == 0:
            at_point = randint(0, len(self.data)-1)
        self.data[at_point] = self.mutation_function(self.data[at_point])

    def crossover(self, other_chrom):
        crossover_point1 = randint(1, len(self.data)-1)
        crossover_point2 = randint(crossover_point1, len(self.data)-1)
        self.crossover_points(other_chrom, crossover_point1, crossover_point2)
        other_chrom.crossover_points(other_chrom, crossover_point1, crossover_point2)

    def crossover_points(self, other_chrom, pt1, pt2):
        tmp = self.data[:pt1] + other_chrom.data[pt1:pt2] + self.data[pt2:]
        self.data = tmp

    def evaluate_fitness(self):
        self.fitness = self.fitness_function(self.data)

    def __cmp__(self, other):
        return cmp(self.fitness, other.fitness)

    def __str__(self):
        return str(self.data)


    def get_copy(self):
        return Chromosome(copy.deepcopy(self.data), self.fitness_function, self.mutation_function)

