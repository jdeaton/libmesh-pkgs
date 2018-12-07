docker rm libmesh-pkg-build-ubuntu-16.04
docker run -it --entrypoint /bin/bash --name libmesh-pkg-build-ubuntu-16.04 -v ${PWD}:/package ubuntu:16.04