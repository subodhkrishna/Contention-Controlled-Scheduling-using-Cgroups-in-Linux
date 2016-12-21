#!/bin/bash
#This script implements gang scheduling by using the FREEZER subsystem of Cgroups filesystem

#Author : Phanikar Subodh Krishna Chereddi

#begin=$(date +%s%N) 
#beginns=$(date +%N)

rm -rf output
echo "deleted old output folder"
mkdir output
echo "created new output folder"
#for my convience not necessary to delete and create cgroups every time
#the cgroups tasks file will automatically empty as soon as the benchmark application finishes running
cgdelete freezer:app1
cgdelete freezer:app2
cgdelete freezer:app3
cgdelete freezer:app4
cgdelete freezer:app5
cgdelete freezer:app6
cgdelete freezer:app7
cgdelete freezer:app8

cgdelete cpuset:app1
cgdelete cpuset:app2
cgdelete cpuset:app3
cgdelete cpuset:app4
cgdelete cpuset:app5
cgdelete cpuset:app6
cgdelete cpuset:app7
cgdelete cpuset:app8
echo "deleted cgroups" 

cgcreate -g freezer:app1
cgcreate -g freezer:app2
cgcreate -g freezer:app3
cgcreate -g freezer:app4
cgcreate -g freezer:app5
cgcreate -g freezer:app6
cgcreate -g freezer:app7
cgcreate -g freezer:app8

cgcreate -g cpuset:app1
cgcreate -g cpuset:app2
cgcreate -g cpuset:app3
cgcreate -g cpuset:app4
cgcreate -g cpuset:app5
cgcreate -g cpuset:app6
cgcreate -g cpuset:app7
cgcreate -g cpuset:app8

cgset -r cpuset.cpus=0-5 app1
cgset -r cpuset.cpus=0-5 app2
cgset -r cpuset.cpus=0-5 app3
cgset -r cpuset.cpus=0-5 app4
cgset -r cpuset.cpus=0-5 app5
cgset -r cpuset.cpus=0-5 app6
cgset -r cpuset.cpus=6-7 app7
cgset -r cpuset.cpus=6-7 app8

# cgset -r cpuset.cpu_exclusive=1 app7
# cgset -r cpuset.cpu_exclusive=1 app8

cgset -r cpuset.mems=0 app1
cgset -r cpuset.mems=0 app2
cgset -r cpuset.mems=0 app3
cgset -r cpuset.mems=0 app4
cgset -r cpuset.mems=0 app5
cgset -r cpuset.mems=0 app6
cgset -r cpuset.mems=0 app7
cgset -r cpuset.mems=0 app8
echo "created new cgroups"


#global variable to select the process to be gang scheduled
typeset -i app_to_be_thawed
app_to_be_thawed=0

#if this set to 1 when all the process under this scheduling policy have finished execution
typeset -i stop_switching

# variables for checking if the process is still alive
typeset -i x1
typeset -i x2
typeset -i x3
typeset -i x4
typeset -i x5
typeset -i x6
typeset -i x7
typeset -i x8


#function implementing gang scheduling policy
#only one process is allowed to be scheduled at once
#if a process is frozen then it is no longer a schedulable entity with reference to the Linux scheduler
gang_schedule(){
case $app_to_be_thawed in
1)
  echo THAWED > /sys/fs/cgroup/freezer/app1/freezer.state
  echo FROZEN > /sys/fs/cgroup/freezer/app2/freezer.state
  echo FROZEN > /sys/fs/cgroup/freezer/app3/freezer.state
  echo FROZEN > /sys/fs/cgroup/freezer/app4/freezer.state
  echo FROZEN > /sys/fs/cgroup/freezer/app5/freezer.state
  echo FROZEN > /sys/fs/cgroup/freezer/app6/freezer.state
  #echo FROZEN > /sys/fs/cgroup/freezer/app7/freezer.state
 #echo FROZEN > /sys/fs/cgroup/freezer/app8/freezer.state
  ;;
2)
  echo FROZEN > /sys/fs/cgroup/freezer/app1/freezer.state
  echo THAWED > /sys/fs/cgroup/freezer/app2/freezer.state
  echo FROZEN > /sys/fs/cgroup/freezer/app3/freezer.state
  echo FROZEN > /sys/fs/cgroup/freezer/app4/freezer.state
  echo FROZEN > /sys/fs/cgroup/freezer/app5/freezer.state
  echo FROZEN > /sys/fs/cgroup/freezer/app6/freezer.state
 #echo FROZEN > /sys/fs/cgroup/freezer/app7/freezer.state
 #echo FROZEN > /sys/fs/cgroup/freezer/app8/freezer.state
  ;;
3)
  echo FROZEN > /sys/fs/cgroup/freezer/app1/freezer.state
  echo FROZEN > /sys/fs/cgroup/freezer/app2/freezer.state
  echo THAWED > /sys/fs/cgroup/freezer/app3/freezer.state
  echo FROZEN > /sys/fs/cgroup/freezer/app4/freezer.state
  echo FROZEN > /sys/fs/cgroup/freezer/app5/freezer.state
  echo FROZEN > /sys/fs/cgroup/freezer/app6/freezer.state
 #echo FROZEN > /sys/fs/cgroup/freezer/app7/freezer.state
 #echo FROZEN > /sys/fs/cgroup/freezer/app8/freezer.state
  ;;
4)
  echo FROZEN > /sys/fs/cgroup/freezer/app1/freezer.state
  echo FROZEN > /sys/fs/cgroup/freezer/app2/freezer.state
  echo FROZEN > /sys/fs/cgroup/freezer/app3/freezer.state
  echo THAWED > /sys/fs/cgroup/freezer/app4/freezer.state
  echo FROZEN > /sys/fs/cgroup/freezer/app5/freezer.state
  echo FROZEN > /sys/fs/cgroup/freezer/app6/freezer.state
  #echo FROZEN > /sys/fs/cgroup/freezer/app7/freezer.state
  #echo THAWED > /sys/fs/cgroup/freezer/app8/freezer.state
  ;;
5)
  echo FROZEN > /sys/fs/cgroup/freezer/app1/freezer.state
  echo FROZEN > /sys/fs/cgroup/freezer/app2/freezer.state
  echo FROZEN > /sys/fs/cgroup/freezer/app3/freezer.state
  echo FROZEN > /sys/fs/cgroup/freezer/app4/freezer.state
  echo THAWED > /sys/fs/cgroup/freezer/app5/freezer.state
  echo FROZEN > /sys/fs/cgroup/freezer/app6/freezer.state
  #echo THAWED > /sys/fs/cgroup/freezer/app7/freezer.state
  #echo FROZEN > /sys/fs/cgroup/freezer/app8/freezer.state
  ;;  
6)
  echo FROZEN > /sys/fs/cgroup/freezer/app1/freezer.state
  echo FROZEN > /sys/fs/cgroup/freezer/app2/freezer.state
  echo FROZEN > /sys/fs/cgroup/freezer/app3/freezer.state
  echo FROZEN > /sys/fs/cgroup/freezer/app4/freezer.state
  echo FROZEN > /sys/fs/cgroup/freezer/app5/freezer.state
  echo THAWED > /sys/fs/cgroup/freezer/app6/freezer.state
  #echo THAWED > /sys/fs/cgroup/freezer/app7/freezer.state
  ##echo THAWED > /sys/fs/cgroup/freezer/app8/freezer.state
  ;;
# 7)
#   echo FROZEN > /sys/fs/cgroup/freezer/app1/freezer.state
#   echo FROZEN > /sys/fs/cgroup/freezer/app2/freezer.state
#   echo FROZEN > /sys/fs/cgroup/freezer/app3/freezer.state
#   echo FROZEN > /sys/fs/cgroup/freezer/app4/freezer.state
#   echo THAWED > /sys/fs/cgroup/freezer/app5/freezer.state
#   #echo FROZEN > /sys/fs/cgroup/freezer/app6/freezer.state
#   echo THAWED > /sys/fs/cgroup/freezer/app7/freezer.state
#   ##echo THAWED > /sys/fs/cgroup/freezer/app8/freezer.state
#   ;;
# 8)
#   echo FROZEN > /sys/fs/cgroup/freezer/app1/freezer.state
#   echo FROZEN > /sys/fs/cgroup/freezer/app2/freezer.state
#   echo FROZEN > /sys/fs/cgroup/freezer/app3/freezer.state
#   echo THAWED > /sys/fs/cgroup/freezer/app4/freezer.state
#   echo FROZEN > /sys/fs/cgroup/freezer/app5/freezer.state
#   #echo FROZEN > /sys/fs/cgroup/freezer/app6/freezer.state
#   echo THAWED > /sys/fs/cgroup/freezer/app7/freezer.state
#   #echo THAWED > /sys/fs/cgroup/freezer/app8/freezer.state
#   ;;
*)
  echo THAWED > /sys/fs/cgroup/freezer/app1/freezer.state
  echo THAWED > /sys/fs/cgroup/freezer/app2/freezer.state
  echo THAWED > /sys/fs/cgroup/freezer/app3/freezer.state
  echo THAWED > /sys/fs/cgroup/freezer/app4/freezer.state
  echo THAWED > /sys/fs/cgroup/freezer/app5/freezer.state
  echo THAWED > /sys/fs/cgroup/freezer/app6/freezer.state
  #echo THAWED > /sys/fs/cgroup/freezer/app7/freezer.state
  #echo THAWED > /sys/fs/cgroup/freezer/app8/freezer.state  
  ;;
esac
}

PARSECDIR='/home/phanikar/Desktop/parsec-2.1/'
OUTPUTDIR='/home/phanikar/Desktop/output/'

#forking the Parsec 2.1 benchmark applications one by one
#all the threads of an application are pushed to respective cgroup
echo "starting apps"
cd "$PARSECDIR"pkgs/apps/blackscholes/inst/amd64-linux.gcc.pre/bin
#echo $PWD
cgexec -g cpuset,freezer:app1 time ./blackscholes 8 in_10M.txt prices.txt \
> "$OUTPUTDIR"blackscholes_log.txt \
2> "$OUTPUTDIR"blackscholes_time.txt &
#manually push pids insted of cgexec
#echo $! > /sys/fs/cgroup/freezer/app1/tasks

cd "$PARSECDIR"pkgs/apps/bodytrack/inst/amd64-linux.gcc.pre/bin
#echo $PWD
cgexec -g cpuset,freezer:app2 time ./bodytrack sequenceB_261 4 261 4000 5 0 8 \
> "$OUTPUTDIR"bodytrack_log.txt \
2> "$OUTPUTDIR"bodytrack_time.txt &
#echo $! > /sys/fs/cgroup/freezer/app2/tasks

cd "$PARSECDIR"pkgs/apps/fluidanimate/inst/amd64-linux.gcc.pre/bin
#echo $PWD
cgexec -g cpuset,freezer:app3 time ./fluidanimate 8 500 in_500K.fluid out.fluid \
> "$OUTPUTDIR"fluidanimate_log.txt \
2> "$OUTPUTDIR"fluidanimate_time.txt &
#echo $! > /sys/fs/cgroup/freezer/app3/tasks

cd "$PARSECDIR"pkgs/apps/swaptions/inst/amd64-linux.gcc.pre/bin
#echo $PWD
cgexec -g cpuset,freezer:app4 time ./swaptions -ns 128 -sm 1000000 -nt 8 \
> "$OUTPUTDIR"swaptions_log.txt \
2> "$OUTPUTDIR"swaptions_time.txt &
#echo $! > /sys/fs/cgroup/freezer/app4/tasks

cd "$PARSECDIR"pkgs/apps/x264/inst/amd64-linux.gcc.pre/bin
#echo $PWD
cgexec -g cpuset,freezer:app5 time ./x264 --quiet --qp 20 --partitions b8x8,i4x4 --ref 5 --direct auto --b-pyramid \
--weightb --mixed-refs --no-fast-pskip --me umh --subme 7 --analyse b8x8,i4x4 \
--threads 8 -o eledream.264 eledream_1920x1080_512.y4m \
> "$OUTPUTDIR"x264_log.txt \
2> "$OUTPUTDIR"x264_time.txt &
#echo $! > /sys/fs/cgroup/freezer/app5/tasks

cd "$PARSECDIR"pkgs/kernels/canneal/inst/amd64-linux.gcc.pre/bin
#echo $PWD
cgexec -g cpuset,freezer:app6 time ./canneal 8 15000 2000 2500000.nets 6000 \
> "$OUTPUTDIR"canneal_log.txt \
2> "$OUTPUTDIR"canneal_time.txt &
#echo $! > /sys/fs/cgroup/freezer/app6/tasks

cd "$PARSECDIR"pkgs/kernels/dedup/inst/amd64-linux.gcc.pre/bin
#echo $PWD
cgexec -g cpuset,freezer:app7 time ./dedup -c -p -f -t 8 -i FC-6-x86_64-disc1.iso -o output.dat.ddp \
> "$OUTPUTDIR"dedup_log.txt \
2> "$OUTPUTDIR"dedup_time.txt &
#echo $! > /sys/fs/cgroup/freezer/app7/tasks

cd "$PARSECDIR"pkgs/kernels/streamcluster/inst/amd64-linux.gcc.pre/bin
#echo $PWD
cgexec -g cpuset,freezer:app8 time ./streamcluster 10 20 128 1000000 200000 5000 none output.txt 8 \
> "$OUTPUTDIR"streamcluster_log.txt \
2> "$OUTPUTDIR"streamcluster_time.txt &
#echo $! > /sys/fs/cgroup/freezer/app8/tasks
echo "started all apps"

#for debugging only as initially only TGID are pushed into cgroup
#later when the threads are cloned they are automatically pushed to the cgroup by the kernel
#echo app1 >> /home/phanikar/Desktop/pids.txt
#cat /sys/fs/cgroup/freezer/app1/tasks >> /home/phanikar/Desktop/pids.txt
#echo app2 >> /home/phanikar/Desktop/pids.txt
#cat /sys/fs/cgroup/freezer/app2/tasks >> /home/phanikar/Desktop/pids.txt
#echo app3 >> /home/phanikar/Desktop/pids.txt
#cat /sys/fs/cgroup/freezer/app3/tasks >> /home/phanikar/Desktop/pids.txt
#echo app4 >> /home/phanikar/Desktop/pids.txt
#cat /sys/fs/cgroup/freezer/app4/tasks >> /home/phanikar/Desktop/pids.txt
#echo app5 >> /home/phanikar/Desktop/pids.txt
#cat /sys/fs/cgroup/freezer/app5/tasks >> /home/phanikar/Desktop/pids.txt
#echo app6 >> /home/phanikar/Desktop/pids.txt
#cat /sys/fs/cgroup/freezer/app6/tasks >> /home/phanikar/Desktop/pids.txt
#echo app7 >> /home/phanikar/Desktop/pids.txt
#cat /sys/fs/cgroup/freezer/app7/tasks >> /home/phanikar/Desktop/pids.txt
#echo app8 >> /home/phanikar/Desktop/pids.txt
#cat /sys/fs/cgroup/freezer/app8/tasks >> /home/phanikar/Desktop/pids.txt

x1_ended=false
x2_ended=false
x3_ended=false
x4_ended=false
x5_ended=false
x6_ended=false
x7_ended=false
x8_ended=false
stop_switching=0

sleep 1

until [ $stop_switching = 1 ];do 
echo "in loop"
x1=`cat /sys/fs/cgroup/freezer/app1/tasks | wc -l`
if [ $x1 = 0 ]
then
  x1_ended=true 
else
  #x1_ended=false
  app_to_be_thawed=1
  gang_schedule
  sleep 1
fi

x2=`cat /sys/fs/cgroup/freezer/app2/tasks | wc -l`
if [ $x2 = 0 ]
then
  x2_ended=true 
else
  #x2_ended=false
  app_to_be_thawed=2
  gang_schedule
  sleep 1
fi

x3=`cat /sys/fs/cgroup/freezer/app3/tasks | wc -l`
if [ $x3 = 0 ]
then
  x3_ended=true 
else
  #x3_ended=false
  app_to_be_thawed=3
  gang_schedule
  sleep 1
fi

x4=`cat /sys/fs/cgroup/freezer/app4/tasks | wc -l`
if [ $x4 = 0 ]
then
  x4_ended=true 
else
  #x4_ended=false
  app_to_be_thawed=4
  gang_schedule
  sleep 1
fi

x5=`cat /sys/fs/cgroup/freezer/app5/tasks | wc -l`
if [ $x5 = 0 ]
then
  x5_ended=true 
else
  #x5_ended=false
  app_to_be_thawed=5
  gang_schedule
  sleep 1
fi

x6=`cat /sys/fs/cgroup/freezer/app6/tasks | wc -l`
if [ $x6 = 0 ]
then
  x6_ended=true 
else
  #x6_ended=false
  app_to_be_thawed=6
  gang_schedule
  sleep 1
fi

x7=`cat /sys/fs/cgroup/freezer/app7/tasks | wc -l`
if [ $x7 = 0 ]
then
  x7_ended=true 
#else
  #x7_ended=false
  #app_to_be_thawed=7
  #gang_schedule
  #sleep 1
fi

x8=`cat /sys/fs/cgroup/freezer/app8/tasks | wc -l`
if [ $x8 = 0 ]
then
  x8_ended=true 
#else
#   #x8_ended=false
#   app_to_be_thawed=8
#   gang_schedule
#   sleep 1
fi

echo $x1 $x2 $x3 $x4 $x5 $x6 $x7 $x8
echo $x1_ended $x2_ended $x3_ended $x4_ended $x5_ended $x6_ended $x7_ended $x8_ended

if [ $x1_ended = true ] &&\
   [ $x2_ended = true ] &&\
   [ $x3_ended = true ] &&\
   [ $x4_ended = true ] &&\
   [ $x5_ended = true ] &&\
   [ $x6_ended = true ] ;then #&&\
   # [ $x7_ended = true ]  #&&\
   # [ $x8_ended = true ];then
  echo "all apps done"
  stop_switching=1
fi  
done
chown -R phanikar:adm /home/phanikar/Desktop/output/


#wait

#end=$(date +%s%N)
#totns=$(expr $endns - $ beginns) 
#tottime=$(expr $end - $begin)
#echo "($tottime) this is the time taken"
