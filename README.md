
# Creating a basic S2I builder image  

## Getting started  

### Files and Directories  
| File                   | Required? | Description                                                  |
|------------------------|-----------|--------------------------------------------------------------|
| Dockerfile             | Yes       | Defines the base builder image                               |
| s2i/bin/assemble       | Yes       | Script that builds the application                           |
| s2i/bin/usage          | No        | Script that prints the usage of the builder                  |
| s2i/bin/run            | Yes       | Script that runs the application                             |
| s2i/bin/save-artifacts | No        | Script for incremental builds that saves the built artifacts |
| test/run               | No        | Test script for the builder image                            |
| test/test-app          | Yes       | Test application source code                                 |

#### Dockerfile
Create a *Dockerfile* that installs all of the necessary tools and libraries that are needed to build and run our application.  This file will also handle copying the s2i scripts into the created image.

#### S2I scripts

##### assemble
Create an *assemble* script that will build our application, e.g.:
- build python modules
- bundle install ruby gems
- setup application specific configuration

The script can also specify a way to restore any saved artifacts from the previous image.   

##### run
Create a *run* script that will start the application. 

##### save-artifacts (optional)
Create a *save-artifacts* script which allows a new build to reuse content from a previous version of the application image.

##### usage (optional) 
Create a *usage* script that will print out instructions on how to use the image.

#### Create the builder image and push
Alterar os parâmetros <USERNAME> e <PASSWORD> no arquivo Dockerfile antes do build

oc login https://tcm-ocp.tcmba.net:8443

podman login registry.redhat.io

OCP_REGISTRY=`oc get route docker-registry -n default -o 'jsonpath={.spec.host}{"\n"}'`

podman login -u $(oc whoami) -p $(oc whoami -t) ${OCP_REGISTRY} --tls-verify=false

podman build -t $OCP_REGISTRY/openshift/php:7.2-apache -f Dockerfile

podman push $OCP_REGISTRY/openshift/php:7.2-apache --tls-verify=false



