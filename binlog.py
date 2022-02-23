#!/bin/python

import sys

maxi = 512

print('#define CAT(a, b) CAT_I(a, b)')
print('#define CAT_I(a, b) a ## b')

sys.stdout.write('#define COUNT(...) COUNT_I(__VA_ARGS__')
for i in reversed(range(maxi)):
    sys.stdout.write(f',{i}')
print(')')

sys.stdout.write('#define COUNT_I(')
for i in range(1, maxi+1):
    sys.stdout.write(f'a{i},')
print(f'...) a{maxi}')

print('#define FOREACH(F, ...) CAT(FOREACH_, COUNT(__VA_ARGS__)) (F, __VA_ARGS__)')

for i in range(1, maxi+1):
    sys.stdout.write(f'#define FOREACH_{i}(F')
    for j in range(i):
        sys.stdout.write(f',a{j}')
    sys.stdout.write(')')
    for j in range(i):
        sys.stdout.write(f' F(a{j})')
    sys.stdout.write("\n")
