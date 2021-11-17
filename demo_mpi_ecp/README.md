## General
[create_image](create_image) contains all the necessary files to setup a docker image
that one can use to run MPI c/python programs on the ECP machine.

---
### Build the Image
I have built the image and is avaliable at "yzanhua/ecp-mpi" from Docker Hub. You can also build one using command:
```shell
# Assume the image name you want to build is "my_local_image", version is "latest"
docker build -t my_local_image:latest path/to/create_image
```

---

### How to use the image:
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
    mpiexec -n 2 python3 send_rec.py # use python3 instead of python.
    ```

### Push your image to the Registry (Docker Hub)

0. [Official Tutorial](https://docs.docker.com/docker-hub/repos/)
1. Create an account at [Docker Hub](https://hub.docker.com/)
2. Create a repository on your Docker Hub. Free account only has one free private repo.
2. Login the docker account on your local/host machine:
    ```shell
    docker login -u [account user name]
    # enter your password
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