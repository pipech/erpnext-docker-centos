#  Dockerfile for building Self-contained ERPNext Image on CentOs

##### This is for development use only !!!
##### For production use please checkout > [pipech/docker-centos-erpnext-production](https://github.com/pipech/docker-centos-erpnext-production)

This repository contain Dockerfile use to build Docker Images in Docker Hub [**pipech/erpnext**](https://hub.docker.com/r/pipech/erpnext/)

**You might or might not be able to run docker images using this repository** because it's heavily base on other repository like [frappe/bench](https://github.com/frappe/bench), [frappe/frappe](https://github.com/frappe/frappe) and [frappe/erpnext](https://github.com/frappe/erpnext)

So I think it's best to run using image from Docker Hub [pipech/erpnext](https://hub.docker.com/r/pipech/erpnext/) there I already clone, install those repository into Docker Images

#### What Dockerfile does

Please see it for yourself [here](https://github.com/pipech/docker-centos-erpnext/blob/master/Dockerfile), it's self explanatory.

## Getting Started

### Prerequisites

* [Docker](https://www.docker.com/)

###  Usage

#### First time usage

1. Pull docker images from Docker Hub
    ```
    docker pull pipech/erpnext
    ```

2. Run docker container from pipech/erpnext images, expose port 8000 to host and set container name to erpnext_con
    ```
    docker run -d -t -p 8000:8000 --name erpnext_con pipech/erpnext bash
    ```
    
3. Access bash on erpnext_con container
    ```
    docker exec -it erpnext_con bash
    ```
    
4. Run mysql in that container
    ```
    sudo service mysql start
    ```
    
5. Start Bench
    ```
    bench start
    ```
    
6. Access ERPNext with Web Browser
    ```
    localhost:8000
    ```
    
#### Stop Using

1. Stop development server
    ```
    Press : Ctrl + C
    ```

2. Exit from bash on erpnext_con container
    ```
    exit
    ```
    
3. Stop erpnext_con container
    ```
    docker stop erpnext_con
    ```
    
#### Start Using (Again)

1. Start container (Existing container)
    ```
    docker start erpnext_con
    ```
    
2. Access bash on erpnext_con container
    ```
    docker exec -it erpnext_con bash
    ```
    
3. Run mysql in that container
    ```
    sudo service mysql start
    ```
    
4. Start Bench
    ```
    bench start
    ```
    
5. Access ERPNext with Web Browser
    ```
    localhost:8000
    ```
#### Stop Using (Forever and ever, Until you pull image again)

* Delete container
    ```
    docker rm -f erpnext_con
    ```
    
* Delete image
    ```
    docker rmi pipech/erpnext bash
    ```