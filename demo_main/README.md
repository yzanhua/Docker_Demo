## Experiment 1:
**Goal:** pull an image from Registry, create some containers. Create files inside the containers.

```shell
# # list all local images
docker image ls

# # pull 'ubuntu' image from Registry
# # docker pull [iamge name]:[version/tag]
# # [version/tag] ddefaults to "latest", 
docker pull ubuntu
# # same as "docker pull ubuntu:latest"

# # list all local images
docker image ls

# # docker run [options] [image name]:[version] [commmand]
docker run -it ubuntu /bin/bash

# # now inside container
ls
touch /test_file_111111111
ls

# # exit from container
exit
```

1. The `docker run` command creates a new container, using image `ubuntu` (default tag: latest).
1. If you don't have this image locally, Docker will pull one from Registry.
3. Docker then starts the container and executes `/bin/bash`. 
4. The container is running interactively and attached to your terminal (due to the `-i` and `-t` flags), you can provide input using your keyboard while the output is logged to your terminal.
4. When you type `exit` to terminate the `/bin/bash` command, the container stops but is not removed. You can start it again or remove it.

## Experiment 1.1
Continue From Experiment 1. **Goal:** demo isolation
```shell
# # list all running containers
docker container ls

# # list all containers
docker container ls -a

# # restart stopped container
docker start -i [container-id]

# # inside container
ls # # test_file_111 is still there
exit

# # start another container
docker run -it ubuntu /bin/bash

# # inside container
# # test_file_111 is no more there
ls 
exit

# # docker ps <==> docker container ls
# # docker ps -a <==> docker container ls -a
docker ps -a 

# # rm container
docker container rm [container-id]
```

## Experiment 2

Goal: run print_list.py inside container:

```shell
# # see explaination below
docker run -it --rm -v $(pwd):/workspace -w /workspace  python:3.9 /bin/bash

# # inside container:
ls
python print_list.py
python print_list.py > out.txt
ls
exit

# # now at host machine
ls
docker ps -a
```
1. `--rm`: the container will be auto-removed.
2. `-v [host_folder]:[container_folder]`: mounts a folder `[host_folder]` from host machine to `[container_folder]` inside the container.
3.  `-w [container_folder]`: the initial working directory becomes `[container_folder]`.

## Experiment 3

Goal1: run print_list.py inside container

Goal2: no `-it`
```shell
# # docker run [options] [image name]:[version] [commmand]
docker run --rm -v $(pwd):/workspace -w /workspace python:3.9 python print_list.py > out2.txt

# # same instruction
docker run \
    --rm -v $(pwd):/workspace -w /workspace \ # [options]
    python:3.9 \ # [image name]:[version]
    python print_list.py > out2.txt # [command]

```

## Experiment 4
Goal1: run print_list.py inside container:
Goal2: Save a container as an image
```shell
# # no --rm
docker run -it -v $(pwd):/workspace -w /workspace ubuntu /bin/bash

# # now inside ubuntu container
python # # bash: python: command not found, need to install python
apt-get update # # already root, no need to do "sudo apt--get install"
apt-get install python3
python3 print_list.py
exit

# # now host machine:
docker ps -a
# # create image from container # docker commit [container-id] [image:version/tag]
docker commit [container-id] my_image:latest
docker container rm [container-id] # this step is not necessary
docker image ls
# # image size much smaller than python:3.9
# # python:3.9-slim the minimal package to run python 3.9
docker pull pyhton:3.9-slim

docker run -it --rm -v $(pwd):/workspace  my_image /bin/bash 

# # now inside container: /workspace
python3 print_list.py
exit

# # now host machine
docker image rm my_image
docker iamge ls
```

## Experiment 5
Goal1: run print_list.py inside container

Goal2: Create images from Dockerfile

```shell
# # build an image from Dockerfile
# # docker build -t [iamge name][version/tag] [folder containing Dockerfile]
docker build -t my_image2:2.4.4 ../demo_dockerfile/demo1

# # build another image from Dockerfile (using a different way)
docker build -t my_image2 ../demo_dockerfile/demo2 
docker image ls

docker run -it --rm -v $(pwd):/workspace -w /workspace my_image2:2.4.4 python3 print_list.py
docker run -it --rm -v $(pwd):/workspace -w /workspace my_image2 python3 print_list.py
```


 
