#! /usr/bin/env python

# An attempted setup of the TSP


from random import randint
from Chromosome import Chromosome
from GA import *


MIN_VALUE = 0
MAX_VALUE = 4

travel_cost = [
    [4, 1, 2, 2, 1],
    [1, 4, 1, 2, 2],
    [2, 1, 4, 1, 2],
    [2, 2, 1, 4, 1],
    [1, 2, 2, 1, 4],
    ]


def ts_fitness(ls_cities):
    total_cost = 0
    curr_city = 0
    for city in ls_cities:
        total_cost += travel_cost[curr_city][city]
        curr_city = city
    return (2 * len(ls_cities) - total_cost)

def int_mutation(x):
    return randint(MIN_VALUE, MAX_VALUE)

def make_random_city_list(length):
    tmp_ls = []
    for i in range(MAX_VALUE):
        r = randint(MIN_VALUE, MAX_VALUE)
        while r in tmp_ls:
            r = randint(MIN_VALUE, MAX_VALUE)
        tmp_ls.append(r)
    return tmp_ls

def make_random_city_chromosome(fit_function, length):
    return Chromosome(make_random_city_list(length), fit_function, int_mutation)


def do_ts_run(pop_size=50, chrom_len=10, co_rate=0.6, mut_rate=0.01, num_gens=5000, fit_thresh=1000000, fit_fun=None):

    population = Population(0)
    for i in range(pop_size):
        population.add_chromosome(make_random_city_chromosome(fit_fun, chrom_len))

    myga = GA(population, num_gens, co_rate, mut_rate, fit_thresh, make_random_city_chromosome)
    return myga.evolve()



if __name__ == "__main__":

    import sys

    pop_size = 50
    chrom_len = 10
    co_rate = 0.6
    mut_rate = 0.01
    num_gens = 5000

    # sum
    fit_thresh = chrom_len * 2

    if len(sys.argv) < 1:
        print "USAGE: ./TS_GA.py"
        sys.exit(1)
    else:
        (pop, gen_num, avg_fit) = do_ts_run(pop_size, chrom_len, co_rate, mut_rate, num_gens, fit_thresh, ts_fitness)        

    print "Final generation: %d" % gen_num
    print "Ending avg. fitness: %d" % avg_fit
