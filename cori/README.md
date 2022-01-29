## Commands to run Python programs in parallel on Cori at NERSC using a Docker Image

* Skip to [Using A Public Docker Image On Cori](#using-a-public-docker-image-on-cori)
  at the bottom of this page, if you would like to use a pre-built Docker image on Cori.
* Below provides a few simple steps to build, register, download, and use a docker image
  to run jobs on Cori. For further information, please refer to the
  [Shifter User guide](https://docs.nersc.gov/development/shifter/how-to-use/) on Cori.

### To build a Docker image on a local machine for running Python on Cori at NERSC
* Log into the local machine (not Cori).
* Use file [./Dockerfile](Dockerfile) to build an Image on the local machine.
  ```
  % docker build -t cori_image:latest .
  ```
* Test the image on the local machine.
  ```
  % docker run -it cori_image /bin/bash
  ```
* Test for running as a non-root user.
  ```
  % docker run -it --user 500 cori_image /bin/bash
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
  % docker tag cori_image:latest $USER/cori_image:latest
  ```
* Upload the image to [DockerHub repo](https://hub.docker.com/repositories)
  ```
  % docker push $USER/cori_image:latest
  ```
### A public repo on DockerHub has been created with this procedure.
* One can search public docker images in DockerHub registry
  ```
  % docker search cori_image
  INDEX       NAME                         DESCRIPTION  STARS       OFFICIAL    AUTOMATED
  docker.io   docker.io/wkliao/cori_image               0                       
  ```

## Downloading the image stored on DockerHub To NERSC
  + Log into your account on Cori.
  + Command usage: `shifterimg pull docker:image_name:latest`
  ```
  % shifterimg pull docker:wkliao/cori_image:latest
  2021-11-18T16:45:09 Pulling Image: docker:wkliao/cori_image:latest, status: READY
  ```
  + Check if the image has been downloaded.
  ```
  % shifterimg lookup wkliao/cori_image:latest
  ```

## List the docker images created by a user
  ```
  % shifterimg images | grep wkliao
  cori       docker     READY    4302aabace   2022-01-27T13:18:57 wkliao/cori_image:latest
  
  % shifterimg images | grep jhewes
  cori       docker     READY    529e9366b9   2022-01-28T14:47:51 jhewes/neutrinoml:pytorch1.10.0-cuda11.3-devel
  cori       docker     READY    01a2720842   2021-07-14T15:02:57 jhewes/pytorch-neutrinoml:1.9
  ```

## Using a public docker image on Cori
  + Users can use any public docker image downloaed in shifterimg at NERSC.
  + Command to list all images at NERSC
    ```
    % shifterimg images
    ```
  + The one created by the Dockerfile described above is available at NERSC.
    It can be used to run [pynuml](https://github.com/jethewes/pynuml)
    in a batch job. An example SLURM batch script file is given in
    [./slurm.sh](./slurm.sh).

