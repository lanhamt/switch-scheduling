# run.sh

# cleanup previous runs
rm -rf sim_configs
rm -rf sim_results


# make directories for sim config files with 16 and 8 port arrangements
mkdir sim_configs          2> /dev/null
mkdir sim_configs/16x16    2> /dev/null
mkdir sim_configs/8x8      2> /dev/null

mkdir sim_results          2> /dev/null
mkdir sim_results/16x16    2> /dev/null
mkdir sim_results/fig5     2> /dev/null

# fig 5
python scripts/config_generator.py 1 16x16 pim
python scripts/config_generator.py 1 16x16 slip
python scripts/config_generator.py 0 16x16 rr
python scripts/config_generator.py 0 16x16 fifo


# figure 5 sim runs to generate output files
for algo in sim_configs/16x16/*
do 
    ALGO_NAME=$(echo $algo | cut -d'/' -f3)
    mkdir sim_results/16x16/$ALGO_NAME  2> /dev/null
    for algo_load in $algo/*.u
    do
        echo "    running sim $algo_load"
        sim/bin/sim -l 100000 -f $algo_load > sim_results/16x16/$ALGO_NAME/$(echo $algo_load | cut -d'/' -f4).out
    done

    for f in sim_results/16x16/$ALGO_NAME/*
    do
        echo -n $(echo $f | cut -d'-' -f2 | cut -d'.' -f1) >> sim_results/fig5/$ALGO_NAME.txt
        echo -n "," >>  sim_results/fig5/$ALGO_NAME.txt
        grep "Total Latency over all cells" $f | awk '{print $6}' >> sim_results/fig5/$ALGO_NAME.txt
    done
done

DATA_FILES=$(echo $(find sim_results/fig5) | tr " " , | cut -d',' -f2-)
echo "Generating Figure 5 algorithm comparison graph."

python scripts/plot.py combo $DATA_FILES fig5 


# cleanup and generating graphs for islip iteration comparsion

rm -rf sim_results/
rm -rf sim_configs/

mkdir sim_configs          2> /dev/null
mkdir sim_configs/16x16    2> /dev/null

mkdir sim_results          2> /dev/null
mkdir sim_results/16x16    2> /dev/null
mkdir sim_results/pims     2> /dev/null

python scripts/config_generator.py 1 16x16 pim
python scripts/config_generator.py 2 16x16 pim
python scripts/config_generator.py 3 16x16 pim
python scripts/config_generator.py 4 16x16 pim

for algo in sim_configs/16x16/*
do 
    ALGO_NAME=$(echo $algo | cut -d'/' -f3)
    mkdir sim_results/16x16/$ALGO_NAME  2> /dev/null
    for algo_load in $algo/*.u
    do
        echo "    running sim $algo_load"
        sim/bin/sim -l 100000 -f $algo_load > sim_results/16x16/$ALGO_NAME/$(echo $algo_load | cut -d'/' -f4).out
    done

    for f in sim_results/16x16/$ALGO_NAME/*
    do
        echo -n $(echo $f | cut -d'-' -f2 | cut -d'.' -f1) >> sim_results/pims/$ALGO_NAME.txt
        echo -n "," >>  sim_results/pims/$ALGO_NAME.txt
        grep "Total Latency over all cells" $f | awk '{print $6}' >> sim_results/pims/$ALGO_NAME.txt
    done
done

DATA_FILES=$(echo $(find sim_results/pims) | tr " " , | cut -d',' -f2-)
echo "Generating PIM comparison graph."

python scripts/plot.py pims $DATA_FILES pims 


# generating graphs for islip iteration comparsion

rm -rf sim_results/
rm -rf sim_configs/

mkdir sim_configs          2> /dev/null
mkdir sim_configs/16x16    2> /dev/null

mkdir sim_results          2> /dev/null
mkdir sim_results/16x16    2> /dev/null
mkdir sim_results/slip     2> /dev/null

python scripts/config_generator.py 1 16x16 slip
python scripts/config_generator.py 2 16x16 slip
python scripts/config_generator.py 3 16x16 slip
python scripts/config_generator.py 4 16x16 slip

for algo in sim_configs/16x16/*
do 
    ALGO_NAME=$(echo $algo | cut -d'/' -f3)
    mkdir sim_results/16x16/$ALGO_NAME  2> /dev/null
    for algo_load in $algo/*.u
    do
        echo "    running sim $algo_load"
        sim/bin/sim -l 100000 -f $algo_load > sim_results/16x16/$ALGO_NAME/$(echo $algo_load | cut -d'/' -f4).out
    done

    for f in sim_results/16x16/$ALGO_NAME/*
    do
        echo -n $(echo $f | cut -d'-' -f2 | cut -d'.' -f1) >> sim_results/slip/$ALGO_NAME.txt
        echo -n "," >>  sim_results/slip/$ALGO_NAME.txt
        grep "Total Latency over all cells" $f | awk '{print $6}' >> sim_results/slip/$ALGO_NAME.txt
    done
done

DATA_FILES=$(echo $(find sim_results/slip) | tr " " , | cut -d',' -f2-)
echo "Generating ISLIP comparison graph."

python scripts/plot.py islips $DATA_FILES islips 


mkdir graphs  2> /dev/null 
mv *.png graphs/

cowsay "thanks for reproducing our reproduction of research!"
