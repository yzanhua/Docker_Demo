## Commands to run Python programs in parallel on Cori at NERSC using a Docker Image

* Skip to [Using A Public Docker Image On Cori](#using-a-public-docker-image-on-cori)
  at the bottom of this page, if you would like to use a pre-built Docker image on Cori.
* Below provides a few simple steps to build, register, download, and use a docker image
  to run jobs on Cori. For further information, please refer to the
  [Shifter User guide](https://docs.nersc.gov/development/shifter/how-to-use/) on Cori.

### To build a Docker image for running Python on Cori at NERSC
* Use the Dockerfile to build an Image on the local machine.
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

### Upload the image to DockerHub registry
* Create an account on https://hub.docker.com
* Log into https://hub.docker.com
  ```
  % docker login docker.io
  ```
* Tag the Docker image before push to the DockerHub repo.
  + Command usage: `docker tag SOURCE_IMAGE[:TAG] TARGET_IMAGE[:TAG]`
  ```
  % docker tag cori_image:latest $USER/cori_image:latest
  ```

* Push to the [DockerHub repo](https://hub.docker.com/repositories)
  ```
  % docker push $USER/cori_image:latest
  ```
### A public repo has been created with this procedure.
* One can search public docker images in DockerHub registry
  ```
  % docker search cori_image
  INDEX       NAME                         DESCRIPTION  STARS       OFFICIAL    AUTOMATED
  docker.io   docker.io/wkliao/cori_image               0                       
  ```

## Downloading the image To NERSC
  + Command usage: `shifterimg pull docker:image_name:latest`
  ```
  % shifterimg pull docker:wkliao/cori_image:latest
  2021-11-18T16:45:09 Pulling Image: docker:wkliao/cori_image:latest, status: READY
  ```
  + Check if the image has been downloaded.
  ```
  % shifterimg lookup wkliao/cori_image:latest
  ```

## Using A Public Docker Image On Cori
  + Users can use any public docker image downloaed in shifterimg at NERSC.
  + The one created by the Dockerfile described above is available at NERSC.
    It can be used to run [pynuml](https://github.com/jethewes/pynuml)
    in a batch job. An example SLURM batch script file is given in
    [./slurm.sh](./slurm.sh).

