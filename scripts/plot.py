import sys
import os

import matplotlib
matplotlib.use('Agg')

import matplotlib.pyplot as plt

# invoke as 
# combo, pims, islips
# $ python combo run.py  pim.results,slip.results,rr.results Scheduling_Performance

GRAPH_UPPER_BOUND = 1000.0

def process_args():
    return sys.argv[2].split(',')

def process_algo(file):
    loads = []
    lats = []
    for line in open(file).readlines():
        load, latency = line.split(',')
        if float(latency) <= GRAPH_UPPER_BOUND:
            loads.append(load)
            lats.append(latency)
        else:
            loads.append(load)
            lats.append(latency)
            return loads, lats 
    return loads, lats        

def plot_graph(plot_data, type):
    plt.xlabel('Offered Load (%)')
    plt.ylabel('Avg Cell Latency (Cells)')

    if type == "combo":
        plt.title("Comparative Scheduling Performance")
        plt.yscale("log")
        plt.ylim([.1, 1000])
    elif type == "pims":
        plt.title("PIM Iteration Performance")
        plt.ylim([0, 25])
    elif type == "islips":
        plt.title("ISLIP Iteration Performance")
        plt.yscale("log")
        plt.ylim([.1, 1000])

    for sim_run in plot_data:
        test_name = '.'.join(sim_run[2].split('.')[:-1])

        if type == "combo":
            test_name = test_name.split('_')[0]
        else:
            print test_name
            test_name = ''.join(test_name.split('_')) 

        plt.plot(sim_run[0], sim_run[1], label=test_name)
    legend = plt.legend(bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0)

    if type == "combo":
        plt.savefig(sys.argv[3] + ".png", bbox_extra_artists=(legend,), bbox_inches='tight')
    else:
        plt.savefig(sys.argv[3] + ".png", bbox_extra_artists=(legend,), bbox_inches='tight')
        plt.yscale("log")
        plt.ylim([.1, 1000])
        plt.savefig(sys.argv[3] + "log" + ".png", bbox_extra_artists=(legend,), bbox_inches='tight')

if __name__=='__main__':
    graph_option = sys.argv[1]

    algo_files = process_args()
    
    algo_results = []
    for file in algo_files:
        algo_x, algo_y = process_algo(file)
        file = file.split('/')[-1]
        algo_results.append((algo_x, algo_y, file))
    plot_graph(algo_results, graph_option)
