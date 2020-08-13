#!/bin/bash

if [ "" == "$NS" ]; then
   NS="default"
else
   NS="$NS" 
fi

helm delete first-server-$NS --purge
helm delete second-server-$NS --purge
helm delete third-server-$NS --purge
helm delete forth-server-$NS --purge
helm delete frontend-server-$NS --purge

