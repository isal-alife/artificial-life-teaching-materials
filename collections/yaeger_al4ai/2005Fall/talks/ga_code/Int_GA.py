#! /usr/bin/env python


from random import randint
from Chromosome import Chromosome
from Population import Population
from GA import *


MIN_VALUE = 0
MAX_VALUE = 10
SIZE_CHROMO = 10

def int_max_fitness(ls_ints):
    return sum(ls_ints)

def int_min_fitness(ls_ints):
    return MAX_VALUE * SIZE_CHROMO - sum(ls_ints)

def int_odd_fitness(ls_ints):
    odds = 0
    for i in ls_ints:
        if i % 2 == 1:
            odds += 1
    return odds

def int_mutation(x):
    return randint(MIN_VALUE, MAX_VALUE)

def make_random_int_list(length):
    tmp_ls = []
    for i in range(length):
        tmp_ls.append(randint(MIN_VALUE, MAX_VALUE))
    return tmp_ls

def make_random_int_chromosome(fit_function, length):

    return Chromosome(make_random_int_list(length), fit_function, int_mutation)


def do_int_run(pop_size=100, chrom_len=10, co_rate=0.6, mut_rate=0.01, num_gens=5000, fit_thresh=1000000, fit_fun=None):
    
    population = Population(0)
    for i in range(pop_size):
        population.add_chromosome(make_random_int_chromosome(fit_fun, chrom_len))

    myga = GA(population, num_gens, co_rate, mut_rate, fit_thresh, make_random_int_chromosome)
    return myga.evolve()


if __name__ == "__main__":

    import sys

    pop_size = 100
    chrom_len = SIZE_CHROMO
    co_rate = 0.9
    mut_rate = 0.1
    num_gens = 5000

    # sum
    sum_fit_thresh = (1 * (MAX_VALUE - MIN_VALUE)) * chrom_len    
    
    # odd
    odd_fit_thresh = chrom_len    

    if len(sys.argv) < 2:
        print "USAGE: ./Int_GA.py [max|min|odd]"
        sys.exit(1)
    elif sys.argv[1] == 'max':
        (pop, gen_num, avg_fit) = do_int_run(pop_size, chrom_len, co_rate, mut_rate, num_gens, sum_fit_thresh, int_max_fitness)
        print pop
    elif sys.argv[1] == 'min':
        (pop, gen_num, avg_fit) = do_int_run(pop_size, chrom_len, co_rate, mut_rate, num_gens, sum_fit_thresh, int_min_fitness)
        print pop
    elif sys.argv[1] == 'odd':        
        (pop, gen_num, avg_fit) = do_int_run(pop_size, chrom_len, co_rate, mut_rate, num_gens, odd_fit_thresh, int_odd_fitness)
        print pop

    elif sys.argv[1] == 'profile':
        (pop, gen_num, avg_fit) = do_int_run(pop_size, chrom_len, co_rate, mut_rate, num_gens, odd_fit_thresh, int_odd_fitness)
    else:
        print "USAGE: ./Int_GA.py [max|min|odd|profile]"
        sys.exit(1)

    print "Final generation: %d" % gen_num
    print "Ending avg. fitness: %d" % avg_fit




