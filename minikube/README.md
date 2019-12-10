# Minikube

Basic minikube deployment

## Requirements

- virtualbox
- minikube
- kubectl

This is tested on minikube version 1.5.2 which comes with its own storage provisioner.

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
$ kubectl get secrets -n rook-minio --export -o yaml minio-my-store-access-keys | kubectl apply --namespace=default -f -
```

4. Deploy the Emptybox API service

```bash
$ kubectl apply -f emptybox-api.yaml
```

After one emptybox-api pod is running, get the pod name and run `flask init_bucket`
inside that pod to initialize the bucket.

```bash
$ kubectl get pods -l app=upload
NAME                           READY   STATUS    RESTARTS   AGE
emptybox-api-xxxxxxxxx-xxxxx   1/1     Running   0          15s
emptybox-api-xxxxxxxxx-yyyyy   1/1     Running   0          15s
emptybox-api-xxxxxxxxx-zzzzz   1/1     Running   0          15s
$ kubectl exec -it emptybox-api-xxxxxxxxx-xxxxx flask init_bucket
```

Or this fancier oneliner `kubectl exec -it deployments/emptybox-api flask init_bucket`

5. Deploy the Image Processing API service

```bash
$ kubectl apply -f image-processing.yaml
```

6. Deploy the Image Processing API service

```bash
$ kubectl apply -f emptybox-client.yaml
```

7. You can list the exposed service on minikube by running

```bash
$ minikube service list
```
