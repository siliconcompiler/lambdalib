import glob, re, os

for filename in glob.glob('*.v'):
    new_name = re.sub('asic', 'la', filename)
    os.rename(filename, new_name)
