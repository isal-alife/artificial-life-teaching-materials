#! /usr/bin/env python


# NOT YET WORKING!!!
#

# Preliminary setup for genetic programming in Python


import os
from random import randint
from Chromosome import Chromosome
from GA import *

# Programming GA params are integers
# representing simple mathematical operators, loops, conditionals

# value := [0-100] 
# expr := value
# expr := expr op expr

# 0 = add
# 1 = sub
# 2 = pass
# 3 = ifequal
# 4 = ifless
# 5 = ifgreater
# 6 = for


class Prog_Block:

    def __init__(self, value='', children=[], blocks=[]):
        self.value = value
        self.children = children
        self.blocks = blocks

    def __str__(self):
        if self.value == 'pass':
            return 'pass'
        elif self.value == '==':
            return str(self.children[0]) + ' == ' + str(self.children[1]) 
        elif self.value == '<':
            return str(self.children[0]) + ' < ' + str(self.children[1])
        elif self.value == '>':
            return str(self.children[0]) + ' > ' + str(self.children[1])        
        elif self.value == '=':
            return str(self.children[0]) + ' = ' + str(self.children[1]) + '\n'
        elif self.value == '+':
            return str(self.children[0]) + ' + ' + str(self.children[1])
        elif self.value == '-':
            return str(self.children[0]) + ' - ' + str(self.children[1])
        elif self.value == '*':
            return str(self.children[0]) + ' * ' + str(self.children[1])
        elif self.value == '/':
            return str(self.children[0]) + ' / ' + str(self.children[1])
        elif self.value == 'if':
            ans = 'if ' + str(self.children[0]) + ":\n"
            for block in self.blocks[0]:
                ans += '  ' + str(block)
            ans += '\n'
            if len(self.blocks) > 1:
                ans += 'else:\n'
                for block in self.blocks[1]:
                    ans += '  ' + str(block)
                ans += '\n'
            return ans
        elif self.value == 'while':
            ans = 'while ' + str(self.children[0]) + ":\n"
            for block in self.blocks[0]:
                ans += '  ' + str(block)
            ans += '\n'
            return ans


        
        else:
            return self.value
        

MIN_VALUE = 0
MAX_VALUE = 6

def mult_fitness(ls_instructions):
    f = open('tmp.py', 'w')
    f.write(get_prog_string(ls_instructions))
    f.close()
    import tmp

    a = randint(0, 100)
    b = randint(0, 100)    

    fake_answer = tmp.test(a, b)
    return 10000 - abs((a * b) - fake_answer)

def prog_mutation(x):
    return randint(MIN_VALUE, MAX_VALUE)

def make_random_prog_list(length):
    tmp_ls = []
    for i in range(length):
        tmp_ls.append(randint(MIN_VALUE, MAX_VALUE))
    return tmp_ls

def make_random_prog_chromosome(fit_fun, length):
    return Chromosome(make_random_prog_list(length), fit_fun, prog_mutation)

def get_prog_string(ls_instructions):
    answer = 'def test(a, b):\n  z = 0\n'
    for expr in ls_instructions:
        answer += '  ' + str(expr)
    answer += '\n  return z'
    return answer

def do_prog_run(pop_size=10, chrom_len=10, co_rate=0.8, mut_rate=0.01, num_gens=5000):

    fit_threshold = (MAX_VALUE - 2) * pop_size * chrom_len

    pop = make_population(make_random_prog_chromosome, mult_fitness, pop_size, chrom_len)
    return main_loop(pop, num_gens, co_rate, mut_rate, fit_threshold)


if __name__ == "__main__":
    #(pop, gen_num, avg_fit) = do_prog_run()
    #print "Final generation: %d" % gen_num
    #print "Ending avg. fitness: %d" % avg_fit
    #print pop[0]

    one = Prog_Block(value='1')
    two = Prog_Block(value='2')
    a = Prog_Block(value='a')

    add = Prog_Block(value='+', children=[one, two])
    sub = Prog_Block(value='-', children=[add, two])

    ass1 = Prog_Block(value='=', children=[a, add])
    ass2 = Prog_Block(value='=', children=[a, sub])    

    cond1 = Prog_Block(value='==', children=[a, a])
    
    if_block = Prog_Block(value='if', children=[one], blocks=[[ass1, ass2]])
    while_block = Prog_Block(value='while', children=[cond1], blocks=[[ass1, ass2]])    
    print ass1
    print if_block
    print while_block



