#!/bin/bash
cp Dockerfile-1.9.3 Dockerfile
docker build -t cyberdojo/ruby-1.9.3  .

cp Dockerfile-1.9.3_test_unit Dockerfile
docker build -t cyberdojo/ruby-1.9.3_test_unit  .

docker push cyberdojo/ruby-1.9.3
docker push cyberdojo/ruby-1.9.3_test_unit