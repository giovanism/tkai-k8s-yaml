# Minikube

Basic minikube deployment

## Requirements

- virtualbox
- minikube
- kubectl

## Setup

1. Make a new Kubernetes instance using minikube

```bash
$ minikube start
```

2. Deploy MinIO S3 service

```bash
$ kubectl apply -f operator.yaml
$ kubectl apply -f object-store.yaml
```

__WARNING__ Secret object is still saved in object-store.yaml file. Do not use
this approach on public deployment.

MinIO S3 service is configured on its own namesapce called rook-minio. You can
check over its deployment progress by running this command

```bash
$ watch kubectl get pods --all-namespaces
```

3. Copy over minio server access and secret key to default namespace

```bash
kubectl get secrets -n rook-minio --export -o yaml minio-my-store-access-keys | kubectl apply --namespace=default -f -
```

4. Deploy the Emptybox API service

```bash
kubectl apply -f emptybox-api.yaml
```

After one emptybox-api pods is running, you can initialize the bucket using this
command.

```bash
kubectl exec -it $podname flask init_bucket
```

5. You can list the exposed service on minikube by running

```bash
$ minikube service list
```
