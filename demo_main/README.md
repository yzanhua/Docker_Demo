## Experiment 1:
**Goal:** pull an image from Registry, create some containers, create files inside the container.

```shell
# To list all local images
% docker image ls
REPOSITORY  TAG         IMAGE ID    CREATED     SIZE

# Add an image of ubuntu by pulling 'ubuntu' image from Registry
# Command: docker pull [image name]:[version/tag]
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

# Create a new container in just-now created image 'ubuntu'
# Enter the container in the interactive mode and run test commands
# docker run [options] [image name]:[version] [command]
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
# A container has been created in Experiment 1 when running command 'docker run'
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
**Goal**: run print_list.py in batch mode (i.e. without command-line options `-it`,
preventing from entering the container in interactive mode)

```shell
# docker run [options] [image name]:[version] [command]
% docker run --rm \
         -v ${PWD}/work_folder_on_host:/work_folder_in_container \
         -w /work_folder_in_container \
         python:3.9 \  # [image name]:[version]
         python print_list.py > out2.txt  # [run command]
% ls
out2.txt  work_folder_on_host
% cat out2.txt 
[1, 2, 3, 4]
```

## Experiment 4
**Goal**: Save a container as an image
```shell
# Create a container, but do not delete it once exit it
# Do not use command-line option "--rm"
% docker run -it -v ${PWD}/work_folder_on_host:/work_folder_in_container -w /work_folder_in_container ubuntu /bin/bash 
Resolved "ubuntu" as an alias (/etc/containers/registries.conf.d/000-shortnames.conf)
Trying to pull docker.io/library/ubuntu:latest...
Getting image source signatures
Copying blob 7b1a6ab2e44d done  
Copying config ba6acccedd done  
Writing manifest to image destination
Storing signatures

# Now inside ubuntu container
# Check if python is available. It should not.
root@1af821d3f7e7:/work_folder_in_container# python
bash: python: command not found

# Update Ubuntu packages
root@1af821d3f7e7:/work_folder_in_container# apt-get update
Get:1 http://archive.ubuntu.com/ubuntu focal InRelease [265 kB]
Get:2 http://security.ubuntu.com/ubuntu focal-security InRelease [114 kB]
...
Fetched 19.7 MB in 2s (8962 kB/s)                           
Reading package lists... Done

# Install python package
root@1af821d3f7e7:/work_folder_in_container# apt-get install python3 
Reading package lists... Done
Building dependency tree       
...
Do you want to continue? [Y/n] Y
...
Processing triggers for libc-bin (2.31-0ubuntu9.2) ...

# Run example python program
root@1af821d3f7e7:/work_folder_in_container# python3 print_list.py
[1, 2, 3, 4]

# leave the container
root@1af821d3f7e7:/work_folder_in_container# exit
exit

# now on host machine:
% docker ps -a
CONTAINER ID  IMAGE                            COMMAND     CREATED             STATUS                    PORTS       NAMES
1af821d3f7e7  docker.io/library/ubuntu:latest  /bin/bash   About a minute ago  Exited (0) 8 seconds ago              laughing_swartz

# create image from container
# Command: docker commit [container-id] [image:version/tag]
% docker commit 1af821d3f7e7 my_image:latest
Getting image source signatures
Copying blob 9f54eef41275 skipped: already exists  
Copying blob b5810b1b0929 done  
Copying config ebb2a6ed1d done  
Writing manifest to image destination
Storing signatures
ebb2a6ed1d45365dcccdbf5c4b0e2f4b4fdcf2efb51d0558bd781ed93a98ce68

% docker image ls -a
REPOSITORY                TAG         IMAGE ID      CREATED         SIZE
localhost/my_image        latest      ebb2a6ed1d45  22 seconds ago  147 MB
docker.io/library/ubuntu  latest      ba6acccedd29  4 weeks ago     75.2 MB

% docker container ls -a
CONTAINER ID  IMAGE                            COMMAND     CREATED        STATUS                    PORTS       NAMES
1af821d3f7e7  docker.io/library/ubuntu:latest  /bin/bash   6 minutes ago  Exited (0) 5 minutes ago              laughing_swartz

# Now an image is created. We can delete the container if it is no longer used.
# This step is optional.
% docker container rm 1af821d3f7e7

# Note the image size of my_image is 147 MB
# python:3.9-slim the minimal package to run python 3.9
% docker pull python:3.9-slim
Resolved "python" as an alias (/etc/containers/registries.conf.d/000-shortnames.conf)
Trying to pull docker.io/library/python:3.9-slim...
Getting image source signatures
Copying blob ba03a8977ca9 done  
...
Writing manifest to image destination
Storing signatures
3ba8c1c68e98756449f6bba3ee34dc7343fea0dc399baaa51c663d34e1682146

% docker image ls -a
REPOSITORY                TAG         IMAGE ID      CREATED         SIZE
localhost/my_image        latest      ebb2a6ed1d45  19 minutes ago  147 MB
docker.io/library/python  3.9-slim    3ba8c1c68e98  26 hours ago    128 MB
docker.io/library/ubuntu  latest      ba6acccedd29  4 weeks ago     75.2 MB

# Now try the slim version
% docker run -it -v ${PWD}/work_folder_on_host:/work_folder_in_container -w /work_folder_in_container python /bin/bash 

# Now we are inside of container that installs python:3.9-slim
# Run the example python program
root@3dbe50733485:/work_folder_in_container# python3 print_list.py
[1, 2, 3, 4]

# Leave the container
root@3dbe50733485:/work_folder_in_container# exit
exit

# now on host machine
% docker image ls -a
REPOSITORY                TAG         IMAGE ID      CREATED         SIZE
localhost/my_image        latest      ebb2a6ed1d45  22 minutes ago  147 MB
docker.io/library/python  3.9-slim    3ba8c1c68e98  26 hours ago    128 MB
docker.io/library/ubuntu  latest      ba6acccedd29  4 weeks ago     75.2 MB

# We can delete the newly created toy image
% docker image rm my_image
Untagged: localhost/my_image:latest
Deleted: ebb2a6ed1d45365dcccdbf5c4b0e2f4b4fdcf2efb51d0558bd781ed93a98ce68

# Check if the image has been deleted.
% docker image ls -a
REPOSITORY                TAG         IMAGE ID      CREATED       SIZE
docker.io/library/python  3.9-slim    3ba8c1c68e98  26 hours ago  128 MB
docker.io/library/ubuntu  latest      ba6acccedd29  4 weeks ago   75.2 MB
```

## Experiment 5
*Goal**: Create an image from Dockerfile

```shell
# An example Dockerfile is available in folder 'demo_dockerfile/demo1'

% docker image ls -a
REPOSITORY                TAG         IMAGE ID      CREATED       SIZE
docker.io/library/python  3.9-slim    3ba8c1c68e98  26 hours ago  128 MB
docker.io/library/ubuntu  latest      ba6acccedd29  4 weeks ago   75.2 MB

# Build an image from Dockerfile
# Command: docker build -t [image name][version/tag] [folder containing Dockerfile]
% docker build -t my_image1:2.4.4 ../demo_dockerfile/demo1
STEP 1/3: FROM ubuntu
STEP 2/3: RUN apt-get -qq update
--> 37180e2f10f
STEP 3/3: RUN apt-get install -qqy python3
debconf: delaying package configuration, since apt-utils is not installed
...
Processing triggers for libc-bin (2.31-0ubuntu9.2) ...
COMMIT my_image1:2.4.4
--> 997533709c7
Successfully tagged localhost/my_image1:2.4.4
997533709c73868ef91b79bbd7a1435ec9ca118a1c8c560b1561f66a5ebcff41

# check if the new image, my_image1, has been created
% docker image ls -a
REPOSITORY                TAG         IMAGE ID      CREATED             SIZE
localhost/my_image1       2.4.4       997533709c73  31 seconds ago  147 MB
<none>                    <none>      37180e2f10f2  35 seconds ago  107 MB
docker.io/library/python  3.9-slim    3ba8c1c68e98  26 hours ago        128 MB
docker.io/library/ubuntu  latest      ba6acccedd29  4 weeks ago         75.2 MB

# build another image from Dockerfile (using a different way)
% docker build -t my_image2 ../demo_dockerfile/demo2 
STEP 1/4: FROM ubuntu
STEP 2/4: COPY install.sh .
--> 06c9d473f79
STEP 3/4: RUN chmod +x ./install.sh
--> 4bdb422b920
STEP 4/4: RUN ./install.sh
debconf: delaying package configuration, since apt-utils is not installed
...
Processing triggers for libc-bin (2.31-0ubuntu9.2) ...
COMMIT my_image2
--> bc998ddeb66
Successfully tagged localhost/my_image2:latest
bc998ddeb66ea287b95321681b90a00c34fd0f57c7a7c304a9924e0312b6ca54

# check if the new image, my_image2, has been created
% docker image ls -a
REPOSITORY                TAG         IMAGE ID      CREATED             SIZE
localhost/my_image2       latest      bc998ddeb66e  About a minute ago  147 MB
<none>                    <none>      4bdb422b920b  About a minute ago  75.2 MB
<none>                    <none>      06c9d473f795  About a minute ago  75.2 MB
localhost/my_image1       2.4.4       997533709c73  2 minutes ago       147 MB
<none>                    <none>      37180e2f10f2  2 minutes ago       107 MB
docker.io/library/python  3.9-slim    3ba8c1c68e98  26 hours ago        128 MB
docker.io/library/ubuntu  latest      ba6acccedd29  4 weeks ago         75.2 MB

# Test the images (in either batch or interavctive mode)
% docker run --rm \
         -v ${PWD}/work_folder_on_host:/work_folder_in_container \
         -w /work_folder_in_container \
         my_image1:2.4.4 \
         python3 print_list.py

% docker run --rm \
         -v ${PWD}/work_folder_on_host:/work_folder_in_container \
         -w /work_folder_in_container \
         my_image2 \
         python3 print_list.py

# To delete dangling images
% docker image rm 4bdb422b920b 06c9d473f795 37180e2f10f2
Deleted: 06c9d473f7952bde658bc37a17f679c6a98c61e4dd8e0f2c0c35f59fb6c51ef7

% docker image ls -a
REPOSITORY                TAG         IMAGE ID      CREATED         SIZE
localhost/my_image2       latest      bc998ddeb66e  13 minutes ago  147 MB
localhost/my_image1       2.4.4       997533709c73  15 minutes ago  147 MB
docker.io/library/python  3.9-slim    3ba8c1c68e98  26 hours ago    128 MB
docker.io/library/ubuntu  latest      ba6acccedd29  4 weeks ago     75.2 MB
```
