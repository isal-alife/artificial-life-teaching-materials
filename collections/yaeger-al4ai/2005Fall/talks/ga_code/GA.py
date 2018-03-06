#! /usr/bin/env python


import math
from random import randint, random, choice
from Chromosome import Chromosome
from Population import Population


class GA:

    def __init__(self, start_pop, num_generations, crossover_rate, mutation_rate, total_fitness_threshold, chrom_init_func):
        self.population = start_pop
        self.population_size = len(self.population)
        self.num_generations = num_generations
        self.crossover_rate = crossover_rate
        self.mutation_rate = mutation_rate
        self.total_fitness_threshold = total_fitness_threshold
        self.chromosome_init = chrom_init_func
        self.recalculate_fitness()
   
    def recalculate_fitness(self):
        for p in self.population.chromosomes():
            p.evaluate_fitness()

    def pick_random(self):
        r = randint(0, self.population_size-1)
        return self.population.chromosomes()[r]

    def pick_best(self):
        self.population.chromosomes().sort()
        self.population.chromosomes().reverse()
        return self.population.chromosomes()[0]

    def tournament(self, size=8, choosebest=0.90):
        competitors = [choice(self.population.chromosomes()) for i in range(size)]
        competitors.sort()
        competitors.reverse()
        if random() < choosebest:
            return competitors[0]
        else:
            return choice(competitors)         

    def pick(self):
        return self.tournament()


    def do_crossover(self):
        new_pop = Population()
        new_pop.add_chromosome(self.pick_best().get_copy())
        for i in range((self.population_size / 2) + 1):
            a = self.pick()
            if random() < self.crossover_rate:
                b = self.pick()
                a.crossover(b)
                b.crossover(a)
                self.do_mutation(b)
                new_pop.add_chromosome(b.get_copy())
            self.do_mutation(a)
            new_pop.add_chromosome(a.get_copy())                            
        new_pop.ls = new_pop.ls[:self.population_size]
        self.population = new_pop

    def do_mutation(self, chrom):
        for i in range(len(chrom)):
            if random() < self.mutation_rate:
                chrom.mutate(i)
    
    def print_random_chromosomes(self, num):
        print 
        print "A selection of the population:"
        for i in range(num):
            print self.pick_random()
        print


    def print_info(self, generation_num, best):
        print "Generation: " + str(generation_num), "\tBest Fitness:" + str(best.fitness)
        r = randint(0, self.population_size-1)
        print "BEST: "
        print best

        
    def evolve(self):
        for i in range(self.num_generations):
            self.do_crossover()
            self.recalculate_fitness()

            b = self.pick_best()            
            if b.fitness >= self.total_fitness_threshold:
                break
            self.print_info(i, b)

        # Return the final population, the generation number, and the ave. fitness
        return (self.population, i, b.fitness / float(self.population_size))



    


