

class Population:

    def __init__(self, maintain_div=0):
        self.ls = []
        self.maintain_diversity = maintain_div


    def add_chromosome(self, chrom):
        if self.maintain_diversity:
            if chrom in self.chromosomes():
                chrom = chrom.get_copy()
                chrom.mutate()
                self.ls.append(chrom)
            else:
                self.ls.append(chrom)
        else:
            self.ls.append(chrom)

    def __str__(self):
        result = ''
        for chrom in self.ls:
            result += str(chrom) + '\t' + str(chrom.fitness) + '\n'
        return result

    def __len__(self):
        return len(self.ls)

    def chromosomes(self):
        return self.ls
