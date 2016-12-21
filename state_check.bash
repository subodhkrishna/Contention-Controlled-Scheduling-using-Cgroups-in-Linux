declare -i time1
time1=0


until [ ];do


cat /sys/fs/cgroup/freezer/app1/freezer.state
cat /sys/fs/cgroup/freezer/app2/freezer.state
cat /sys/fs/cgroup/freezer/app3/freezer.state
cat /sys/fs/cgroup/freezer/app4/freezer.state
cat /sys/fs/cgroup/freezer/app5/freezer.state
cat /sys/fs/cgroup/freezer/app6/freezer.state
cat /sys/fs/cgroup/freezer/app7/freezer.state
cat /sys/fs/cgroup/freezer/app8/freezer.state
time1+=5
echo "$time1"

sleep 5
done