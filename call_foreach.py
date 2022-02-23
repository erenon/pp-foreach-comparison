#!/bin/python

import sys

numargs = int(sys.argv[1])
numcalls = 32

for i in range(numcalls):
    sys.stdout.write('FOREACH(G')
    for j in range(numargs):
        sys.stdout.write(f',b{j}')
    print(')')
