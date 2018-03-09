#!/bin/bash

kubectl create -f calico.yaml;

kubectl create -f kubernetes-dashboard.yaml;

kubectl create -f clusterrolebinding-dashboard.yaml;

kubectl create -f echoserver.yaml;

kubectl create -f app-deployment.yaml -f app-service.yaml -f app-ingress.yaml;

kubectl proxy;