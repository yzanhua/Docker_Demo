# DEMO: MPI on ECP using DOCKER
## 1. General Goal
This demo shows how to set up an image on the ECP machine so that you can run MPI programs on it. 

Supported mpi programs include c programs and python programs (mpi4py). Note that Fortran is not installed/supported.

Section 4 also includes how to save/push an image to the Registry.


## 2. Setting Up the Image
You can choose to build such image from scratch, or download a pre-built image from `yzanhua/ecp-mpi`. The pre-built image is only tested on the ECP machine. 
### 2.1 Build the image from scratch:
The folder [Docker_Demo/demo_mpi_ecp/create_image](create_image) contains all the necessary files to build the image. It may take a long time to finish building this image.
```shell
# Assume the image name you want to build is "my_local_image", version is "latest"
% docker build -t my_local_image:latest path/to/create_image
```
### 2.2 Get a pre-built image:
You can find an already-built image from `yzanhua/ecp-mpi`. Python version is `3.9` and GCC version is `10.2.1`.
```shell
% docker pull yzanhua/ecp-mpi
```


## 3. How to use the image:
1. run a container from the image.
    ```shell
    # if you built your own image
    % docker run -it --rm my_local_image:latest /bin/bash
    # if yzanhua/ecp-mpi is used
    % docker run -it --rm yzanhua/ecp-mpi /bin/bash
    ```
2. In the container, MPICH is installed at `/mpich`
3. In the container, demo programs (c and python) are at `/mpich-demo`
3. In the container, run demo programs:
    ```shell
    # now we are inside the container
    root@a33744391777:/#

    # c program.
    root@a33744391777:/# cd /mpich-demo/c
    
    root@a33744391777:/mpich-demo/c# make
    mpicc -o hello_world_exec hello_world.c
    
    root@a33744391777:/mpich-demo/c# make run
    mpiexec -n 4 ./hello_world_exec
    hello world from processor a33744391777, rank 0 out of 4 processors.
    hello world from processor a33744391777, rank 1 out of 4 processors.
    hello world from processor a33744391777, rank 2 out of 4 processors.
    hello world from processor a33744391777, rank 3 out of 4 processors.

    root@a33744391777:/mpich-demo/c# make clean
    rm -f hello_world_exec

    # python program: using mpi4py
    root@a33744391777:/mpich-demo/c# cd /mpich-demo/py
    root@a33744391777:/mpich-demo/py# mpiexec -n 2 python send_rec.py
    I have rank 0, data is {'a': 7, 'b': 3.14}
    I have rank 1, data is {'a': 7, 'b': 3.14}

    # exit
    root@a33744391777:/mpich-demo/py# exit
    ```

## 4. Push your image to the Registry (Docker Hub)

0. [Official Tutorial](https://docs.docker.com/docker-hub/repos/)
1. Create an account at [Docker Hub](https://hub.docker.com/)
2. Create a repository on your Docker Hub. Free account only has one free private repo.
2. Login the docker account from your local/host machine:
    ```shell
    # if using podman (alias docker=podman)
    % docker login docker.io
    # enter username
    # enter password

    # if using docker
    % docker login -u [account user name]
    # enter your password
    ```
3. Push the image you built to the Docker Hub:
    ```shell
    # assume that: 
    #       your account name is "my_account_name"
    #       the loacl image you'd like to push to Docker hub is "my_local_image",version is "latest"
    #       repo created on the Docker Hub has name "first_repo_on_cloud"
    
    # first rename "my_local_image":
    % docker tag my_local_image:latest my_account_name/first_repo_on_cloud:latest

    # push to Docker Hub
    % docker push my_account_name/first_repo_on_cloud:latest
    ```