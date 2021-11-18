# DEMO: MPI on ECP using DOCKER
## 1. General Goal
This demo shows how to set up an image on the ECP machine so that you can run MPI programs on it. Supported mpi programs include c programs and python programs (mpi4py). Note that Fortran is not installed/supported.



---
## 2. Setting Up the Image
You can choose to build such image from scratch, or download a pre-built image from `yzanhua/ecp-mpi`.
### 2.1 Build the image from scratch:
The folder [create_image](create_image) contains all the necessary files to build the image. However, it may take a long time to finish.
```shell
# Assume the image name you want to build is "my_local_image", version is "latest"
docker build -t my_local_image:latest path/to/create_image
```
### 2.2 Get a pre-built image:
You can find an already-built image from `yzanhua/ecp-mpi`. Python version is `3.9` and GCC version is `10.2.1`.
```shell
docker pull yzanhua/ecp-mpi
```

---

## 3. How to use the image:
1. run a container from the image.
    ```shell
    # if you built your own image
    docker run -it my_local_image:latest /bin/bash
    # if decide to use yzanhua/ecp-mpi
    docker run -it yzanhua/ecp-mpi /bin/bash
    ```
2. mpich is installed at `/mpich`
3. Demo programs (c and python) are at `/mpich-demo`
3. Run demo programs:
    ```shell
    # c program:
    cd /mpich-demo/c 
    make # compile c program using mpicc
    make run # run using 4 process
    make clean

    # python program: mpi4py
    cd /mpich-demo/py
    mpiexec -n 2 python send_rec.py
    ```
---

## Push your image to the Registry (Docker Hub)

0. [Official Tutorial](https://docs.docker.com/docker-hub/repos/)
1. Create an account at [Docker Hub](https://hub.docker.com/)
2. Create a repository on your Docker Hub. Free account only has one free private repo.
2. Login the docker account on your local/host machine:
    ```shell
    # if using docker
    docker login -u [account user name]
    # enter your password

    # if using podman
    docker login docker.io -u [account user name]
    ```
3. Push the image you built to the Docker Hub:
    ```shell
    # assume that: 
    #       your account name is "my_account_name"
    #       the loacl image you'd like to push to Docker hub is "my_local_image",version is "latest"
    #       repo created on the Docker Hub has name "first_repo_on_cloud"
    
    # first rename "my_local_image":
    docker tag my_local_image:latest my_account_name/first_repo_on_cloud:latest

    # push to Docker Hub
    docker push my_account_name/first_repo_on_cloud:latest
    ```