## Experiment 1:
**Goal:** pull an image from Registry, create some containers, create files inside the container.

```shell
# To list all local images
% docker image ls
REPOSITORY  TAG         IMAGE ID    CREATED     SIZE

# Add an image of ubuntu by pulling 'ubuntu' image from Registry
# Command: docker pull [iamge name]:[version/tag]
#     [version/tag] defaults to "latest", 
#     Command below is the same as "docker pull ubuntu:latest"
% docker pull ubuntu
Resolved "ubuntu" as an alias (/etc/containers/registries.conf.d/000-shortnames.conf)
Trying to pull docker.io/library/ubuntu:latest...
Getting image source signatures
Copying blob 7b1a6ab2e44d done  
Copying config ba6acccedd done  
Writing manifest to image destination
Storing signatures
ba6acccedd2923aee4c2acc6a23780b14ed4b8a5fa4e14e252a23b846df9b6c1

# To list all local images
% docker image ls
REPOSITORY                TAG         IMAGE ID      CREATED      SIZE
docker.io/library/ubuntu  latest      ba6acccedd29  4 weeks ago  75.2 MB

# Enter docker in the interactive mode to run some commands for testing
# docker run [options] [image name]:[version] [commmand]
# '-i': interactive mode, '-t': Allocate a pseudo-TTY
% docker run -it ubuntu /bin/bash
root@4a243d8ef5c8:/# 

# Now we are inside the container, running bash shell /bin/bash
root@4a243d8ef5c8:/# ls
bin   dev  home  lib32  libx32  mnt  proc  run   srv  tmp  var
boot  etc  lib   lib64  media   opt  root  sbin  sys  usr

# Create an empty new file named 'test_file_111111111'
root@4a243d8ef5c8:/# touch /test_file_111111111

root@4a243d8ef5c8:/# ls
bin   dev  home  lib32  libx32  mnt  proc  run   srv  test_file_111111111  usr
boot  etc  lib   lib64  media   opt  root  sbin  sys  tmp                  var

# exit from container
root@4a243d8ef5c8:/# exit
exit

% ls test_file_111111111
ls: cannot access 'test_file_111111111': No such file or directory

# Note file 'test_file_111111111' only exists inside of the docker image you created, 'ubuntu'.
```
### Command explanation:
1. The `docker run` command creates a new container, using image `ubuntu` (default tag: latest).
1. If you don't have this image (ubuntu in this example) locally, Docker will pull one from Registry.
3. Docker then starts the container and executes `/bin/bash` as given by the user. 
4. The container is running interactively and attached to your terminal (due to the `-i` and `-t` flags), you can provide input using your keyboard while the output is logged to your terminal.
4. When you type `exit` to terminate the `/bin/bash` command, the container stops but is not removed. You can start it again or remove it.
5. To remove an image, run command `docker image rm IMAGE_NAME`

## Experiment 1.1
**Goal:** demo container isolation, continuing from Experiment 1 above.
```shell
# List available images
% docker image ls
REPOSITORY                TAG         IMAGE ID      CREATED      SIZE
docker.io/library/ubuntu  latest      ba6acccedd29  4 weeks ago  75.2 MB

# List all running containers
% docker container ls
CONTAINER ID  IMAGE       COMMAND     CREATED     STATUS      PORTS       NAMES

# List all containers
% docker container ls -a
CONTAINER ID  IMAGE                            COMMAND     CREATED         STATUS                    PORTS       NAMES
4a243d8ef5c8  docker.io/library/ubuntu:latest  /bin/bash   11 minutes ago  Exited (0) 9 minutes ago              happy_goldstine

# Restart stopped container
# Command: docker start -ia [container-id]
% docker start -ia 4a243d8ef5c8
root@4a243d8ef5c8:/#

# Now we are inside container
# Check the file 'test_file_111111111' previously created 
root@b0ca08f117b4:/# ls
bin   dev  home  lib32  libx32  mnt  proc  run   srv  test_file_111111111  usr
boot  etc  lib   lib64  media   opt  root  sbin  sys  tmp                  var

# Leave the container
root@b0ca08f117b4:/# exit
exit

# Create another container
docker run -it ubuntu /bin/bash

# Now, we are inside the container
# File 'test_file_111111111' should not be in this container
root@c61901ef21bc:/# ls 
bin   dev  home  lib32  libx32  mnt  proc  run   srv  tmp  var
boot  etc  lib   lib64  media   opt  root  sbin  sys  usr

# Leave the container
root@b0ca08f117b4:/# exit
exit

# Command 'docker ps is the same as 'docker container ls'
# Command 'docker ps -a' is the same as 'docker container ls -a'
% docker ps -a 
CONTAINER ID  IMAGE                            COMMAND     CREATED             STATUS                         PORTS       NAMES
4a243d8ef5c8  docker.io/library/ubuntu:latest  /bin/bash   14 minutes ago      Exited (0) About a minute ago              happy_goldstine
c61901ef21bc  docker.io/library/ubuntu:latest  /bin/bash   About a minute ago  Exited (127) 8 seconds ago                 nostalgic_almeida

# Delete a container
# Command: docker container rm [container-id]
% docker container rm  c61901ef21bc
c61901ef21bc28a3d4559a01e64c605288c51e8c7c1b168f20ed725407bde98f
ecp/1::Docker(3:46pm) #1140 docker container ls -a
CONTAINER ID  IMAGE                            COMMAND     CREATED         STATUS                    PORTS       NAMES
4a243d8ef5c8  docker.io/library/ubuntu:latest  /bin/bash   17 minutes ago  Exited (0) 4 minutes ago              happy_goldstine
```

## Experiment 2
**Goal**: run a small python program 'print_list.py' inside a container.

```shell
# Create a folder on the host machine
% mkdir work_folder_on_host
% ls
work_folder_on_host

# Copy the test python program over.
% cp Docker_Demo/demo_main/print_list.py ./work_folder_on_host

# Create a new container, mount the work folder on the host machine at the root folder. 
% docker run -it --rm -v ${PWD}/work_folder_on_host:/work_folder_in_container -w /work_folder_in_container python:3.9 /bin/bash
Resolved "python" as an alias (/etc/containers/registries.conf.d/000-shortnames.conf)
Trying to pull docker.io/library/python:3.9...
Getting image source signatures
Copying blob e1ad2231829e done  
Copying blob a66b7f31b095 done  
Copying blob 647acf3d48c2 done  
Copying blob b02967ef0034 done  
Copying blob 05189b5b2762 done  
Copying blob 5576ce26bf1d done  
Copying blob 6152fd3f0c9a done  
Copying blob 7f52f09bfb2e done  
Copying blob ccac69d544ed done  
Copying config e9a56b8597 done  
Writing manifest to image destination
Storing signatures
root@f4cdd8b95e02:/work_folder_in_container#

# Check what is the current folder
root@f4cdd8b95e02:/work_folder_in_container# pwd
/work_folder_in_container

# # inside container:
root@00302efc24aa:/work_folder_in_container# ls
python print_list.py

# Run python program
root@00302efc24aa:/work_folder_in_container# python print_list.py > out.txt

# Check if the output is created
root@00302efc24aa:/work_folder_in_container# ls
out.txt  print_list.py

# exit the container
root@00302efc24aa:/work_folder_in_container# exit
exit

# Check if the output file appears on the host machine
% cd work_folder_on_host/
% ls
out.txt  print_list.py
% cat out.txt 
[1, 2, 3, 4]

# now at host machine
% docker ps -a
CONTAINER ID  IMAGE                            COMMAND     CREATED      STATUS                    PORTS       NAMES
4a243d8ef5c8  docker.io/library/ubuntu:latest  /bin/bash   2 hours ago  Exited (2) 4 minutes ago              happy_goldstine
```
### Command-line option explanation:
1. `--rm`: the container will be auto-removed once exits from it.
2. `-v [host_folder]:[container_folder]`: mounts a folder `[host_folder]` from host machine to `[container_folder]` inside the container.
3.  `-w [container_folder]`: the starting working directory once entering the container.

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


 
