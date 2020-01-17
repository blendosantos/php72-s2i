#!/bin/bash

# Como usar
# 
# 1 - Clonar artefatos da imagem customizada
#
# 	git clone http://git.tcmba.net/server/php72-s2i.git
# 
# 2 - Efetuar login no OpenShift via linha de comando com um usuário que tenha permissão de "edit" nos projetos "default" e "openshift"
# 
# 	oc login https://tcm-ocp.tcmba.net:8443
# 
# 3 - Efetuar login no registry da Red Hat (esse passo só é necessário na primeira execução na máquina o qual a imagem oficial da Red Hat ainda não foi baixada)
#
#	podman login registry.redhat.io
# 
# 4 - Executar o script dentro da pasta clonada do git
# 
# 	cd TCMSEARCH/
#
# 	./build_image_openshift.sh

#Obtendo a URL do Docker Registry do OpenShift
OCP_REGISTRY=`oc get route docker-registry -n default -o 'jsonpath={.spec.host}{"\n"}'`

#Efetuando login no Registry do OpenShift usando as credenciais do OpenShift
podman login -u $(oc whoami) -p $(oc whoami -t) ${OCP_REGISTRY} --tls-verify=false

#Executando build local da imagem customizada do JBoss EAP
podman build -t $OCP_REGISTRY/openshift/php:7.2-apache -f Dockerfile

#Enviando imagem local customizada do JBoss EAP para o Registry do OpenShift
podman push $OCP_REGISTRY/openshift/php:7.2-apache --tls-verify=false
