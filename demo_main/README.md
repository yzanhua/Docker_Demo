## Experiment 1:
**Goal:** pull an image from Registry, create some containers. Create files inside the containers.

```
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
### Further explanation:
1. The `docker run` command creates a new container, using image `ubuntu` (default tag: latest).
1. If you don't have this image (ubuntu in this example) locally, Docker will pull one from Registry.
3. Docker then starts the container and executes `/bin/bash` as given by the user. 
4. The container is running interactively and attached to your terminal (due to the `-i` and `-t` flags), you can provide input using your keyboard while the output is logged to your terminal.
4. When you type `exit` to terminate the `/bin/bash` command, the container stops but is not removed. You can start it again or remove it.
5. To remove an image, run command `docker image rm IMAGE_NAME`

## Experiment 1.1
Continue From Experiment 1. **Goal:** demo isolation
```shell
# list all running containers
% docker container ls
CONTAINER ID  IMAGE       COMMAND     CREATED     STATUS      PORTS       NAMES

# list all containers
% docker container ls -a
CONTAINER ID  IMAGE                            COMMAND     CREATED         STATUS                     PORTS       NAMES
b0ca08f117b4  docker.io/library/ubuntu:latest  /bin/bash   13 minutes ago  Exited (0) 12 minutes ago              dreamy_sutherland

# restart stopped container
# docker start -ia [container-id]
% docker start -ia b0ca08f117b4
root@b0ca08f117b4:/#

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


