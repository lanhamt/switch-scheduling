# Reproducing Switch Scheduling Research
Our project focuses on reproducing research related to switch scheduling. 
In particular, we focus on algorithms for input-queued switches that offer
solutions for the head-of-line blocking problem switch scheduling algorithms
contend with.

The main algorithm that we reproduce is the iSLIP algorithm but we also
reproduce

## Getting started
To get started with reproducing our project we recommend using an Ubuntu
16.04 LTS machine. You will need a single directory to install several
repos into so we recommend making a directory off your home directory 
(or wherever you choose) and then cloning this repo and the sim repo
into it. 

We have a convenient `run.sh` script in this repo that will create the
graphs that were the focus of our reproduction. Note that the simulator
takes a while to run - you should expect about 10 minutes depending on 
your machine. 

## Tour of the Repo

- `scrips/` holds scripts for generating config files and graphing test results
- `master_configs/` holds templates that are used to generate custom sim config files


