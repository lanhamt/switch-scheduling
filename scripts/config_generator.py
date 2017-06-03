import sys
import os.path
import shutil

# preconditions 
# - must have master_configs dir that has template for config
# - must have directory to put new config files in
#   sim_configs/port_config/algo_dir
#   sim_configs/16x16/

# run instructions
# $ python config_generator.py [iteration count] [port config directory] [algo name]
# $ python config_generator.py 4 16x16 pim

LOAD_LOWER_BOUND = 19
LOAD_UPPER_BOUND = 100

CONFIG_DIR = "sim_configs"

ITER_COUNT = sys.argv[1]
PORT_DIR = sys.argv[2]
ALGO_NAME = sys.argv[3]

ALGO_ITER_DIR = ALGO_NAME + "_" + ITER_COUNT

if len(sys.argv) < 4:
  sys.stderr.write("too few arguments\n")
  sys.exit(0);

if not os.path.isfile("master_configs/" + PORT_DIR + "." + ALGO_NAME + ".u"):
  sys.stderr.write('could not find algorithm\n')
  exit(0)

GEN_CONFIG_DIR = CONFIG_DIR + "/" + PORT_DIR + "/" + ALGO_ITER_DIR

#Creat directory:
try:
    os.mkdir(GEN_CONFIG_DIR) 
except:
    pass

#Create files:
for i in range(LOAD_LOWER_BOUND, LOAD_UPPER_BOUND):
    with open("master_configs/" + PORT_DIR + "." + ALGO_NAME + '.u', 'r') as file:
        new_file = open(GEN_CONFIG_DIR + "/" + PORT_DIR + "-" + str(i) + "." + ALGO_NAME + '.u', 'w+')
        switch = 0
        for line in file:
            if ('bernoulli' in line):
                new_file.write('  ' + str(switch) + ' bernoulli_iid_uniform  -u 0.' + str(i) + '\n')
                switch += 1
            elif ('Algorithm' in line and not int(ITER_COUNT)==0):
                l = line.split(' ')
                index = l.index('-n')
                good = l[:index + 1]
                good.append(str(ITER_COUNT))
                new_file.write('  ' + ' '.join(good) + '\n')
            else:
                new_file.write(line)

