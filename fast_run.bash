echo "starting apps"
cd /home/phanikar/Desktop/parsec-2.1/pkgs/apps/blackscholes/inst/amd64-linux.gcc.pre/bin
#echo $PWD
{ time ./blackscholes 8 in_10M.txt prices.txt \
> /home/phanikar/Desktop/output/blackscholes_log.txt & } \
2> /home/phanikar/Desktop/output/blackscholes_time.txt
echo $! > /sys/fs/cgroup/freezer/app1/tasks

cd /home/phanikar/Desktop/parsec-2.1/pkgs/apps/bodytrack/inst/amd64-linux.gcc.pre/bin
#echo $PWD
{ time ./bodytrack sequenceB_261 4 261 4000 5 0 8 \
> /home/phanikar/Desktop/output/bodytrack_log.txt & } \
2> /home/phanikar/Desktop/output/bodytrack_time.txt
echo $! > /sys/fs/cgroup/freezer/app2/tasks

cd /home/phanikar/Desktop/parsec-2.1/pkgs/apps/fluidanimate/inst/amd64-linux.gcc.pre/bin
#echo $PWD
{ time ./fluidanimate 8 500 in_500K.fluid out.fluid \
> /home/phanikar/Desktop/output/fluidanimate_log.txt & } \
2> /home/phanikar/Desktop/output/fluidanimate_time.txt
echo $! > /sys/fs/cgroup/freezer/app3/tasks

cd /home/phanikar/Desktop/parsec-2.1/pkgs/apps/swaptions/inst/amd64-linux.gcc.pre/bin
#echo $PWD
{ time ./swaptions -ns 128 -sm 1000000 -nt 8 \
> /home/phanikar/Desktop/output/swaptions_log.txt & } \
2> /home/phanikar/Desktop/output/swaptions_time.txt
echo $! > /sys/fs/cgroup/freezer/app4/tasks

cd /home/phanikar/Desktop/parsec-2.1/pkgs/apps/x264/inst/amd64-linux.gcc.pre/bin
#echo $PWD
{ time ./x264 --quiet --qp 20 --partitions b8x8,i4x4 --ref 5 --direct auto --b-pyramid \
--weightb --mixed-refs --no-fast-pskip --me umh --subme 7 --analyse b8x8,i4x4 \
--threads 8 -o eledream.264 eledream_1920x1080_512.y4m \
> /home/phanikar/Desktop/output/x264_log.txt & } \
2> /home/phanikar/Desktop/output/x264_time.txt
echo $! > /sys/fs/cgroup/freezer/app5/tasks

cd /home/phanikar/Desktop/parsec-2.1/pkgs/kernels/canneal/inst/amd64-linux.gcc.pre/bin
#echo $PWD
{ time ./canneal 8 15000 2000 2500000.nets 6000 \
> /home/phanikar/Desktop/output/canneal_log.txt & } \
2> /home/phanikar/Desktop/output/canneal_time.txt
echo $! > /sys/fs/cgroup/freezer/app6/tasks

cd /home/phanikar/Desktop/parsec-2.1/pkgs/kernels/dedup/inst/amd64-linux.gcc.pre/bin
#echo $PWD
{ time ./dedup -c -p -f -t 8 -i FC-6-x86_64-disc1.iso -o output.dat.ddp \
> /home/phanikar/Desktop/output/dedup_log.txt & } \
2> /home/phanikar/Desktop/output/dedup_time.txt
echo $! > /sys/fs/cgroup/freezer/app7/tasks

cd /home/phanikar/Desktop/parsec-2.1/pkgs/kernels/streamcluster/inst/amd64-linux.gcc.pre/bin
#echo $PWD
{ time ./streamcluster 10 20 128 1000000 200000 5000 none output.txt 8 > /home/phanikar/Desktop/output/streamcluster_log.txt  & } 2> /home/phanikar/Desktop/output/streamcluster_time.txt
echo $! > /sys/fs/cgroup/freezer/app8/tasks
echo "started all apps"
wait
chown -R phanikar:adm /home/phanikar/Desktop/output/