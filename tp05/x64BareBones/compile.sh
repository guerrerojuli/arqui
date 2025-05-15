#!/bin/bash
docker start arqui-tpe
docker exec -it arqui-tpe make clean -C /root/Toolchain
docker exec -it arqui-tpe make clean -C /root/
docker exec -it arqui-tpe make -C /root/Toolchain
docker exec -it arqui-tpe make -C /root/
docker stop arqui-tpe
