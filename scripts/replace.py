import glob, re, os

old = "asic"
new = "la"

for filename in glob.glob('*.v'):

    with open(filename, 'r') as f:
        newlines = []
        for line in f.readlines():
            line = line.replace(f"module {old}", f"module {new}")
            newlines.append(line)

    with open(filename, 'w') as f:
        for line in newlines:
            f.write(line)
