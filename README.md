# Flask Application on Kubernetes with Minikube

## Overview

This repository contains a Flask application that returns the current timestamp and hostnames. It shows the result in a webpage and also it returns the `json` value via `/api`. It is configured to run in a Kubernetes cluster and is exposed via Ingress. This README provides instructions for setting up and deploying the application using Minikube.

## Prerequisites

Before you begin, ensure you have the following installed:

- [Docker](https://docs.docker.com/get-docker/)
- [Minikube](https://minikube.sigs.k8s.io/docs/start/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Local Kubernetes Setup with Minikube

### Start Minikube

To start Minikube, use the following command:

```sh
minikube start
```

Above command initializes a local Kubernetes cluster.

### Enable Ingress Addon
The Ingress addon allows you to configure Ingress resources to route traffic to services within your cluster. Enable the Ingress addon with:


```sh
minikube addons enable ingress
```

### Set Up Ingress Tunnel

To access your application via Ingress, you need to create a local tunnel. Run the following command:

```sh
minikube tunnel
```

Above comment sets up a network route to your Minikube cluster, allowing access to services exposed via Ingress resources.


## Deployment

### Applying Kubernetes Manifests via Makefile

This repository contains a `Makefile` with some predefined target that helps you deploy the applications in your local cluster (Example : `Make deploy-all`
). Following is the list of target:

```sh
deploy-all      # Deploy all
deploy-prometheus   # Only Deploy Prometheus
deploy-grafana  #Only Deploy Grafana
deploy-app  #Only Deploy Application
clean-prometheus    #Delete Prometheus
clean-grafana   #Delete Grafana
clean-app   #Delete Application
clean-all   #Delete All
```

### Applying Kubernetes Manifests via kubectl

To deploy the application, grafana or prometheus, apply the Kubernetes manifests using kubectl. You just need to navigate to the desired directory and run following:

```sh
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f ingress.yaml
```

Please note that as a best practice, it's better that you run the appplication in dedicated `namespace`. Thus, in `app` directory there is a `namespace.yaml` file that helps you to create a `namespace` for the application. To deploy the application in this namespace you need to run following:

```sh
kubectl -n host-info-flask-namespace apply -f deployment.yaml
kubectl -n host-info-flask-namespace apply -f service.yaml
kubectl -n host-info-flask-namespace apply -f ingress.yaml
```

### Access the Application

Once deployed, you can access the application via your web browser:

Local Setup with Ingress: Navigate to `http://localhost` in your browser. Or `curl http://localhost/api` from your terminal if you want to get the `json` result.

If you encounter any issues accessing the application, verify that the Ingress controller is routing traffic correctly and that your resources are properly configured.

### Troubleshooting

If you run into issues, consider the following troubleshooting steps:

* Check Pod Status: Verify that the application pods are running:
```sh
kubectl get pods
```
* Check Service Status: Ensure the service is correctly exposed:
```sh
kubectl get svc
```
* Check Ingress Status: Confirm that the Ingress is properly routing traffic:
```sh
kubectl get ingress
```
* View Logs: For detailed debugging, check the logs of the Ingress controller:
```sh
kubectl logs kube-controller-manager-minikube  --namespace kube-system
```

### Documentations

- [Minikube Documentation](https://minikube.sigs.k8s.io/docs/handbook/)
- [Kubernetes Ingress Documentation](https://kubernetes.io/docs/concepts/services-networking/ingress/)
- [Kubectl Documentation](https://kubernetes.io/docs/reference/kubectl/)
- [Grafana](https://grafana.com/docs/grafana/latest/)
- [Prometheus](https://prometheus.io/docs/introduction/overview/)