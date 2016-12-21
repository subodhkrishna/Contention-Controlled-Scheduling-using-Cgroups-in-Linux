#/bin/bash!
#pin applications to cpus and run

rm -rf output_pin
echo "deleted old output_pin folder"
mkdir output_pin
echo "created new output_pin folder"

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

cgset -r cpuset.cpus=4-7 app1
cgset -r cpuset.cpus=0-3 app2
cgset -r cpuset.cpus=0-3 app3
cgset -r cpuset.cpus=4-7 app4
cgset -r cpuset.cpus=0-3 app5
cgset -r cpuset.cpus=0-3 app6
cgset -r cpuset.cpus=0-3 app7
cgset -r cpuset.cpus=4-7 app8

cgset -r cpuset.mems=0 app1
cgset -r cpuset.mems=0 app2
cgset -r cpuset.mems=0 app3
cgset -r cpuset.mems=0 app4
cgset -r cpuset.mems=0 app5
cgset -r cpuset.mems=0 app6
cgset -r cpuset.mems=0 app7
cgset -r cpuset.mems=0 app8
echo "created new cgroups"

PARSECDIR='/home/phanikar/Desktop/parsec-2.1/'
OUTPUTDIR='/home/phanikar/Desktop/output_pin/'

#forking the Parsec 2.1 benchmark applications one by one
#all the threads of an application are pushed to respective cgroup
echo "starting apps"
cd "$PARSECDIR"pkgs/apps/blackscholes/inst/amd64-linux.gcc.pre/bin
#echo $PWD
cgexec -g cpuset,freezer:app1 time ./blackscholes 6 in_10M.txt prices.txt \
> "$OUTPUTDIR"blackscholes_log.txt \
2> "$OUTPUTDIR"blackscholes_time.txt &
#manually push pids insted of cgexec
#echo $! > /sys/fs/cgroup/freezer/app1/tasks

cd "$PARSECDIR"/pkgs/apps/bodytrack/inst/amd64-linux.gcc.pre/bin
#echo $PWD
cgexec -g cpuset,freezer:app2 time ./bodytrack sequenceB_261 4 261 4000 5 0 1 \
> "$OUTPUTDIR"bodytrack_log.txt \
2> "$OUTPUTDIR"bodytrack_time.txt &
#echo $! > /sys/fs/cgroup/freezer/app2/tasks

cd "$PARSECDIR"/pkgs/apps/fluidanimate/inst/amd64-linux.gcc.pre/bin
#echo $PWD
cgexec -g cpuset,freezer:app3 time ./fluidanimate 2 500 in_500K.fluid out.fluid \
> "$OUTPUTDIR"fluidanimate_log.txt \
2> "$OUTPUTDIR"fluidanimate_time.txt &
#echo $! > /sys/fs/cgroup/freezer/app3/tasks

cd "$PARSECDIR"/pkgs/apps/swaptions/inst/amd64-linux.gcc.pre/bin
#echo $PWD
cgexec -g cpuset,freezer:app4 time ./swaptions -ns 128 -sm 1000000 -nt 4 \
> "$OUTPUTDIR"swaptions_log.txt \
2> "$OUTPUTDIR"swaptions_time.txt &
#echo $! > /sys/fs/cgroup/freezer/app4/tasks

cd "$PARSECDIR"/pkgs/apps/x264/inst/amd64-linux.gcc.pre/bin
#echo $PWD
cgexec -g cpuset,freezer:app5 time ./x264 --quiet --qp 20 --partitions b8x8,i4x4 --ref 5 --direct auto --b-pyramid \
--weightb --mixed-refs --no-fast-pskip --me umh --subme 7 --analyse b8x8,i4x4 \
--threads 4 -o eledream.264 eledream_1920x1080_512.y4m \
> "$OUTPUTDIR"x264_log.txt \
2> "$OUTPUTDIR"x264_time.txt &
#echo $! > /sys/fs/cgroup/freezer/app5/tasks

cd "$PARSECDIR"/pkgs/kernels/canneal/inst/amd64-linux.gcc.pre/bin
#echo $PWD
cgexec -g cpuset,freezer:app6 time ./canneal 2 15000 2000 2500000.nets 6000 \
> "$OUTPUTDIR"canneal_log.txt \
2> "$OUTPUTDIR"canneal_time.txt &
#echo $! > /sys/fs/cgroup/freezer/app6/tasks

cd "$PARSECDIR"/pkgs/kernels/dedup/inst/amd64-linux.gcc.pre/bin
#echo $PWD
cgexec -g cpuset,freezer:app7 time ./dedup -c -p -f -t 2 -i FC-6-x86_64-disc1.iso -o output_pin.dat.ddp \
> "$OUTPUTDIR"dedup_log.txt \
2> "$OUTPUTDIR"dedup_time.txt &
#echo $! > /sys/fs/cgroup/freezer/app7/tasks

cd "$PARSECDIR"/pkgs/kernels/streamcluster/inst/amd64-linux.gcc.pre/bin
#echo $PWD
cgexec -g cpuset,freezer:app4 time ./streamcluster 10 20 128 1000000 200000 5000 none output_pin.txt 2 \
> "$OUTPUTDIR"streamcluster_log.txt  \
2> "$OUTPUTDIR"streamcluster_time.txt &
#echo $! > /sys/fs/cgroup/freezer/app8/tasks
echo "started all apps"
wait
chown -R phanikar:adm /home/phanikar/Desktop/output_pin/