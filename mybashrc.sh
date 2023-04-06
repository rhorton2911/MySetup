# Sample .bashrc for SuSE Linux
# Copyright (c) SuSE GmbH Nuernberg

# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.
#
# NOTE: It is recommended to make language settings in ~/.profile rather than
# here, since multilingual X sessions would not work properly if LANG is over-
# ridden in every subshell.

# Some applications read the EDITOR variable to determine your favourite text
# editor. So uncomment the line below and enter the editor of your choice :-)
export EDITOR=/usr/bin/vim
#export EDITOR=/usr/bin/mcedit

# For some news readers it makes sense to specify the NEWSSERVER variable here
#export NEWSSERVER=your.news.server

# If you want to use a Palm device with Linux, uncomment the two lines below.
# For some (older) Palm Pilots, you might need to set a lower baud rate
# e.g. 57600 or 38400; lowest is 9600 (very slow!)
#
#export PILOTPORT=/dev/pilot
#export PILOTRATE=115200

#Sets maximum size of core files that the user can create to zero. i.e. Prevent the user from creating core 
#files. This prevents core-dump files from segfaults being created to save memory. 
ulimit -c 0

HOSTNAME=$(hostname)
echo "$HOSTNAME"

#Cancel all currrently running jobs at once
#alias printIt='echo "$(squeue -u rhorton | cut -c14-18 | tail -n +2 )"'
if [[ "$HOSTNAME" == *"setonix"* ]]; then

   test -s ~/.alias && . ~/.alias || true
   #Use latest version of gcc, gnuplot and lapack
   module load gcc/11.2.0
   module load gnuplot/5.4.2
   module load netlib-lapack/3.9.1
   module load cray-mpich/8.1.19
   module load miniocli/2022-02-02T02-03-24Z

   alias sc='squeue -u rhorton | cut -c1-6 | tail -n +2 | xargs scancel'
   #Alias squeue command for ease of use.
   alias sq='squeue -u rhorton' 
   #Check how much of the group's allocation Liam has used
   alias liam='pawseyAccountBalance'
   #Alias to allow easy requesting of time on debug nodes
   alias debug='salloc --exclusive --cpus-per-task=24 --ntasks-per-node=1 --ntasks=1 --nodes=1 -p debug'
   #Compare soft and hard resource usage limits in two vim windows
   alias limComp='vimdiff <(ulimit -Sa) <(ulimit -Ha)'
   #-------------------------Setonix Navigation Custom Commands------------------
   alias mccode='cd $MYSOFTWARE/MCSimulation'
   alias hcode='cd $MYSOFTWARE/Triatomic'
   alias liamccc='cd $MYSOFTWARE/../lscarlett/MCCC-FN'
   alias soft='cd $MYSOFTWARE'
   alias scratch='cd $MYSCRATCH'
   alias plots='cd /software/projects/d35/rhorton/mcplots'
   #-----------------------Setonix custom bash functions
   set -a
   testPlots() {
      cd $MYSOFTWARE/testplotscripts
      cp plot* $MYSCRATCH/TESTPlots/
      cd $MYSCRATCH/TESTPlots
   }
   testCode() {
      #Used to easily test monte carlo code. test.sh sets up 'TEST' directory on SCRATCH
      bash $MYSOFTWARE/MCSimulation/setonixjobscripts/testMcCode.sh
      cd $MYSCRATCH/TEST/
      export OMP_NUM_THREADS=1 
      export OMP_STACKSIZE=3000m
   }
   
   runCode() {
      #Used to easily run monte carlo code. Calls all required scripts
      bash $MYSOFTWARE/MCSimulation/setonixjobscripts/runMcCode.sh
   }
   set +a
   #-------------------------minIo client (mc) customization--------------
   #Modified to make acacia's S3 style object storage seem as close as possible to 
   #a unix filesystem. 
   complete -C /software/setonix/2022.11/software/cray-sles15-zen3/gcc-12.1.0/miniocli-2022-02-02T02-03-24Z-xts6bt4x7cuzbvrmcaaw7wrnz736z36v/bin/mc mc
   #-------------------------Terminal Colour Customisation------------------
   #Calls synth-shell scripts to customise terminal prompt
   ## synth-shell-prompt.sh
   if [ -f /home/rhorton/.config/synth-shell/synth-shell-prompt.sh ] && [ -n "$( echo $- | grep i )" ]; then
   	source /home/rhorton/.config/synth-shell/synth-shell-prompt.sh
   fi
elif [[ "$HOSTNAME" == *"gadi"* ]]; then
	  echo "SETTING UP CONFIGURATIONS FOR GADI"
	  module load pbs
    module load intel-mkl/2023.0.0
		#module load intel-mkl/2022.0.2
    module load openmpi/4.1.4
    module load intel-compiler/2021.8.0
    #module load intel-compiler/2022.0.0

    alias scratch='cd ~/../../../scratch/d35/rh5686'
    alias soft='cd ~/../../../g/data/d35/rh5686'
    alias hcode='cd ~/../../../g/data/d35/rh5686/Triatomic'
		alias mccc='cd ~/../../../g/data/d35/rh5686/MCCC-FN-Triatomic'
		alias heh='cd /scratch/d35/rh5686/HeH+Code'
		alias workdir='cd /scratch/d35/rh5686/H3+WorkDir'

    #alias test='cp data.in ../TEST; cp input ../TEST; cp H3Plus ../TEST; cd ../TEST'
    alias debug='qsub -I -qexpress -lwalltime=01:00:00,ncpus=48,mem=190GB,jobfs=400GB,wd,storage=scratch/d35+gdata/d35 -P ${PROJECT}'
    alias debugiy='qsub -I -qexpress -lwalltime=01:00:00,ncpus=48,mem=190GB,jobfs=400GB,wd,storage=scratch/d35+gdata/d35 -P iy23'
		alias account='nci_account'
		
		alias sc='qstat | cut -c1-8 | tail -n +3 | xargs qdel'

		tm () {
			 #Test MCCC code 'tm'
       cp /g/data/d35/rh5686/MCCC-FN-Triatomic/debug.gadi.intel/main  /g/data/d35/rh5686/TESTMCCC/
			 cd /g/data/d35/rh5686/TESTMCCC/
		}


    ##-----------------------------------------------------
    ## synth-shell-prompt.sh
    if [ -f /home/573/rh5686/.config/synth-shell/synth-shell-prompt.sh ] && [ -n "$( echo $- | grep i )" ]; then
    	source /home/573/rh5686/.config/synth-shell/synth-shell-prompt.sh
    fi
fi 

#Set environment variables in case that bash script is being called from a debug node on gadi
if [[ "$HOSTNAME" == *"gadi"* ]] && [[ "$HOSTNAME" == *"cpu"* ]]; then
	 export OMP_NUM_THREADS=48
	 export OMP_STACKSIZE=1000m
fi


#Highlight directories for goodness' sake.
alias ls='ls --color=auto'  

#Export following functions for possible use in subshells executing scripts (equivalent to
#'export -f funcName' for each function.
set -a
mkcdir () {
        #Make and enter directory
        mkdir "$1"
        cd "$1"
}

cpcd () {
        #Copy file to given directory and then move there, accounts for directory name with spaces
        cp "$1" "${@:2}"
        cd "${@:2}"
}

set +a



