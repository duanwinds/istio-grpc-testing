#!/bin/bash

if [ "" == "$NS" ]; then
   NS="default"
else
   NS="$NS" 
fi

if [ "" == "$NODE" ]; then
   echo "please provide the target node ip or name, e.g."
   echo "NODE=192.168.1.100 ./pressure.sh"
   exit
fi

if [ "" == "$THREAD" ]; then
   THREAD=16
fi

if [ "" == "$CC" ]; then
   CC=2500
fi

if [ "" == "$TIME" ]; then
   TIME=300
fi

ulimit -n 655350

FIRST=$(kubectl -n $NS get svc first-server -o jsonpath='{.spec.ports[0].nodePort}')
SECOND=$(kubectl -n $NS get svc second-server -o jsonpath='{.spec.ports[0].nodePort}')
THIRD=$(kubectl -n $NS get svc third-server -o jsonpath='{.spec.ports[0].nodePort}')
FORTH=$(kubectl -n $NS get svc forth-server -o jsonpath='{.spec.ports[0].nodePort}')
FRONTEND=$(kubectl -n $NS get svc frontend-server -o jsonpath='{.spec.ports[0].nodePort}')

echo "the testing to HTTP in first server in $NODE, wrk -> http"
wrk -t$THREAD -c$CC -d$TIME --latency --timeout 30s http://$NODE:$FIRST/

echo "the testing to GRPC in second server in $NODE, wrk -> http -> grpc"
wrk -t$THREAD -c$CC -d$TIME --latency --timeout 30s http://$NODE:$SECOND/grpc

echo "the testing to GRPC in third server in $NODE, wrk -> http -> grpc -> grpc"
wrk -t$THREAD -c$CC -d$TIME --latency --timeout 30s http://$NODE:$THIRD/grpc

echo "the testing to GRPC in forth server in $NODE, wrk -> http -> grpc -> grpc -> grpc"
wrk -t$THREAD -c$CC -d$TIME --latency --timeout 30s http://$NODE:$FORTH/grpc

echo "the testing to GRPC in frontend server in $NODE, wrk -> http -> grpc -> grpc -> grpc -> grpc"
wrk -t$THREAD -c$CC -d$TIME --latency --timeout 30s http://$NODE:$FRONTEND/grpc

echo "testing finished"
