#!/usr/bin/env python3

import sys

from fasta_iterator_class import FASTAReader

target_fname = sys.argv[1]
droyak_fname = sys.argv[2]
k = int(sys.argv[3])

target_seqs = FASTAReader(open(target_fname))
droyak_seqs = FASTAReader(open(droyak_fname))

#for seq_id, sequence in target_seqs:
#    print(seq_id)
#    print(sequence)

#for seq_id, sequence in droyak_seqs:
    #print(seq_id)
    #print(sequence)
    
kmers = {}

for seq_id, sequence in target_seqs:
    for i in range(0, len(sequence) - k+1):
        kmer = sequence[i:i + k]
        #kmers.setdefault(kmer, 0)
        if kmer in kmers:
            kmers[kmer].append(seq_id)
            kmers[kmer].append(i)
        else:
            kmers[kmer] = [seq_id, i]

#for key, value in kmers.items():
   # print(key, value)
                
for seq_id, sequence in droyak_seqs:
    for i in range(0, len(sequence) - k+1):
        kmer_q = sequence[i:i + k]
        if kmer_q in kmers:
            print("target sequence names and starts {}, query start: {}, kmer: {}".format(str(kmers[kmer_q]), i, kmer_q))
            #print('target sequence names and starts: {}, query start: {}, query start {}, kmer: {}'.format(kmers[kmer_q], i, kmer_q))