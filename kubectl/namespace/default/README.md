# vbox-prek8-cluster

## Next steps:

I have included a lot of the dirty work here in the form of yaml files which you apply using kubectl.

Take a look at what is in them. Just don't blindly apply them.

First things first, we need to choose an container network interface. Let's role with Calico.

	$ kubectl create -f calico.yml

Let's wait for containers to be created... 

	$ kubectl get all --all-namespaces

When it's all settled down.. let's try to deploy a simple echoserver app.

	$ kubectl create -f echoserver.yaml

It will available at http://172.16.66.4:30080/ and http://172.16.66.3:30080/ since we specified 2 replicas in echoserver.yaml and we have 2 worker nodes.

Secondly let's get that kubernetes dashboard working.

	$ kubectl create -f kubernetes-dashboard.yaml

And set RBAC admin permissions

	$ kubectl create -f clusterrolebinding-dashboard.yaml

fire up kubectl proxy

	$ kubectl proxy

And you should be able to bring up http://127.0.0.1:8001/ui


## More:

To execute all of the above in one step, I've included run.sh. Execute it. If you have kubectl proxy running, check http://127.0.0.1:8001/ui to see when the containers have been created or...

	$ kubectl get all --all-namespaces -o wide


## Demo Calico policy:

	$ kubectl run busybox --rm -ti --image=busybox /bin/sh

	# wget -O - http://echo-svc.default.svc.cluster.local:8080

This should return you stuff. We are accessing the echo app from another kubernetes pod.
Now lets limit access from other pods by use of a label.

$ kubectl create -f echoserver-policy.yaml 

Now when you do the same...

	$ kubectl run busybox --rm -ti --image=busybox /bin/sh

	# wget -O - http://echo-svc.default.svc.cluster.local:8080

It will timeout.

Now lets use the label.

	$ kubectl run busybox --rm -ti --labels="access=true" --image=busybox /bin/sh

	# wget -O - http://echo-svc.default.svc.cluster.local:8080

And it works again. 