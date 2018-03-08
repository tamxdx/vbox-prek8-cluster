# vbox-prek8-cluster

Next steps:

I have included a lot of the dirty work here in the form of yaml files which you apply using kubectl.

Take a look at what is in them. Just don't blindly apply them.

First things first, we need to choose an container network interface. Let's role with Calico.

$ kubectl create -f calico.yml

Let's wait for containers to be created... 

$ kubectl get all --all-namespaces

When it's all settled down.. let's try to deploy a simple echoserver app.

$ kubectl create -f echoserver.yaml

It will available either at http://172.16.66.4:30080/ or http://172.16.66.3:30080/ since we only specified 1 replica and we have 2 worker nodes.

Secondly let's get that kubernetes dashboard working.

$ kubectl create -f kubernetes-dashboard.yaml

And set RBAC admin permissions

$  kubectl create -f clusterrolebinding-dashboard.yaml

fire up kubectl proxy

$ kubectl proxy

And you should be able to bring up http://127.0.0.1:8001/ui