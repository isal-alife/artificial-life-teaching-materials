#! /usr/bin/env python


import os
from random import randint
from Chromosome import Chromosome
from Population import Population
from GA import *



# Music GA params are integers representing notes in a chromatic scale
#

notes = ["c'", "cis'", "d'", "ees'", "e'", "f'", "fis'", "g'", "gis'", "a'", "bes'", "b'", "c''"]

key_C = [0, 2, 4, 5, 7, 9, 11, 12]

MIN_VALUE = 0
MAX_VALUE = 12

def in_key_fitness(ls_notes):
    in_key = 0
    for note in ls_notes:
        if note in key_C:
            in_key += 1
    return in_key

def scale_fitness(ls_notes):
    points = 0
    for i in range(len(ls_notes[1:-1])):
        points += abs(ls_notes[i] - ls_notes[i-1])
        points += abs(ls_notes[i] - ls_notes[i+1])         
    return (len(ls_notes) * (MAX_VALUE - MIN_VALUE)) - points


def in_key_scale_fitness(ls_notes):
    in_key = 0
    for note in ls_notes:
        if note in key_C:
            in_key += 1
    points = 0
    for i in range(len(ls_notes[1:-1])):
        points += abs(ls_notes[i] - ls_notes[i-1])
        points += abs(ls_notes[i] - ls_notes[i+1])         

    return (in_key * 100) + ((len(ls_notes) * (MAX_VALUE - MIN_VALUE)) - points)



def music_mutation(x):
    return randint(MIN_VALUE, MAX_VALUE)

def make_random_notes_list(length):
    tmp_ls = []
    for i in range(length):
        tmp_ls.append(randint(MIN_VALUE, MAX_VALUE))
    return tmp_ls

def make_random_music_chromosome(fit_fun, length):
    return Chromosome(make_random_notes_list(length), fit_fun, music_mutation)


def play_song(chrom):
    print "*" * 60    
    print "Playing Song...[make sure Lilypond and Timidity are installed]"
    print "*" * 60
    f = open('song.ly.txt', 'w')
    header = '''%% A genetically produced melody
    \\score {
    {
    \n'''
    f.write(header)
    for note in chrom.data:
        f.write(notes[note] + " ")
    footer = '''
    }
    \\midi { \\tempo 4=100 }
    }
    \\version "2.4.0"\n'''
    f.write(footer)
    f.close()
    os.system('lilypond song.ly.txt') # Make a MIDI file
    os.system('timidity song.midi')


def produce_score(chrom):
    print "*" * 60    
    print "Generating Score...[make sure Lilypond and gpdf are installed]"
    print "*" * 60    
    f = open('song.ly.txt', 'w')
    header = '''%% A genetically produced melody
    \header {
    title = "A Genetic Song"
    composer = "IBM X40"
    }
    \\score {
    %%\\relative{
    {
    \n'''
    f.write(header)
    for note in chrom.data:
        f.write(notes[note] + " ")

    footer = '''
    }
    }

    %% Helper for automatic updating by convert-ly. 
    \\version "2.4.0"\n'''
    f.write(footer)
    f.close()
    os.system('lilypond song.ly.txt') # Make a nice score
    os.system('gpdf song.ly.pdf')


def do_music_run(pop_size=100, chrom_len=10, co_rate=0.8, mut_rate=0.01, num_gens=5000, thresh=1000000, fit_fun=None):

    population = Population(0)
    for i in range(pop_size):
        population.add_chromosome(make_random_music_chromosome(fit_fun, chrom_len))

    myga = GA(population, num_gens, co_rate, mut_rate, thresh, make_random_music_chromosome)
    return myga.evolve()


if __name__ == "__main__":
    import sys

    pop_size = 50
    chrom_len = 10
    co_rate = 0.6
    mut_rate = 0.01
    num_gens = 5000

    key_fit_thresh = chrom_len  # For in_key fitness
    scale_fit_thresh = chrom_len * 9  # For scale fitness
    both_fit_thresh = chrom_len * 105  # For both fitness  

    if len(sys.argv) < 3:
        print "USAGE: ./Music_GA.py [key|scale] [midi|score]"
        sys.exit(1)
    elif sys.argv[1] == 'key':
        (pop, gen_num, avg_fit) = do_music_run(pop_size, chrom_len, co_rate, mut_rate, num_gens, key_fit_thresh, in_key_fitness)        
    elif sys.argv[1] == 'scale':
        (pop, gen_num, avg_fit) = do_music_run(pop_size, chrom_len, co_rate, mut_rate, num_gens, scale_fit_thresh, scale_fitness)        
    else:
        print "USAGE: ./Music_GA.py [key|scale] [midi|score]"
        sys.exit(1)

    if sys.argv[2] == 'midi':
        play_song(pop.chromosomes()[0])
    elif sys.argv[2] == 'score':
        produce_score(pop.chromosomes()[0])    


    print "Final generation: %d" % gen_num
    print "Ending avg. fitness: %d" % avg_fit





