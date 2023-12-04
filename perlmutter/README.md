## Commands to run Python programs in parallel on Perlmutter at NERSC using a Docker Image

* Skip to [Using A Public Docker Image On Perlmutter](#using-a-public-docker-image-on-Perlmutter)
  at the bottom of this page, if you would like to use a pre-built Docker image on Perlmutter.
* Below provides a few simple steps to build, register, download, and use a docker image
  to run jobs on Perlmutter. For further information, please refer to the
  [Podman at NERSC](https://docs.nersc.gov/development/podman-hpc/overview/) on Perlmutter.

### To build a Docker image on a local machine for running Python on Perlmutter at NERSC
* Log into the local machine (not Perlmutter).
* Use file [./Dockerfile](Dockerfile) to build an Image on the local machine. The docker file installs mpi4py.
  ```
  % docker build -t perlmutter_img:latest .
  ```
* Test for running as a non-root user.
  ```
  % docker run -it --rm --user 500 perlmutter_img /bin/bash

  # inside docker
  I have no name!@b60245f40f8d:/app$ mpirun -n 2 python3 -c "from mpi4py import MPI; size = MPI.COMM_WORLD.Get_size(); rank = MPI.COMM_WORLD.Get_rank(); name = MPI.Get_processor_name(); print(f'Hello, World! I am process {rank} of {size} on {name}.', flush=True)"
  ```

### Upload the image built on the local machine to DockerHub registry
* Using a web browser to create an account on https://hub.docker.com
* On the local machine, log into https://hub.docker.com
  ```
  % docker login docker.io
  ```
* Tag the Docker image before upload it to the DockerHub repo.
  + Command usage: `docker tag SOURCE_IMAGE[:TAG] TARGET_IMAGE[:TAG]`
  ```
  % docker tag perlmutter_img:latest $DockerHubUserName/perlmutter_img:latest
  ```
* Upload the image to [DockerHub repo](https://hub.docker.com/repositories)
  ```
  % docker push $DockerHubUserName/perlmutter_img:latest
  ```


## Downloading the image stored on DockerHub To NERSC
  + Log into your DockerHub account on Perlmutter (only necessary if downloading a private img).
    ```
    podman-hpc login
    ```

  + Download
    ```
    % podman-hpc pull yzanhua/perlmutter_img:latest
    ✔ docker.io/yzanhua/perlmutter_img:latest
    Trying to pull docker.io/yzanhua/perlmutter_img:latest...
    Getting image source signatures
    Copying blob 50a773d43109 done
    Copying blob 2cb381d726d9 done
    Copying blob a4574681f84f done
    Copying blob 1b01329a28e0 done
    Copying blob 5e8117c0bd28 done
    Copying blob 0c7624895452 done
    Copying config 93ccf33278 done
    Writing manifest to image destination
    Storing signatures
    93ccf33278a990535c0c3e52007b13153351ee631f01f0671c18f2b5e2a3a6a7
    INFO: Migrating image to /pscratch/sd/z/zanhua/storage
    ```

## List the docker images created
  ```
  %  podman-hpc image list
  REPOSITORY                        TAG         IMAGE ID      CREATED            SIZE
  docker.io/yzanhua/perlmutter_img  latest      93ccf33278a9  About an hour ago  696 MB
  ```

