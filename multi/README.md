# Multi/Local

This setup will extend the previous minikube setup to be used on multi node
local setup using [Vagrant/Kubespray].

## Requirements

- More than 4 GB of RAM
- libvirtd/KVM (required for local path provioner)
- vagrant
- kubectl
- ansible

## Setup

1. Clone Kubespray github repository
   [here](https://github.com/kubernetes-sigs/kubespray)

2. Apply the provided git diff patch to the repository. This is for configuring
   local registry (for development purpose so you wouldn't have to push your
   image to dockerhub all the time) and enabling the local path provisioner.

   ```bash
   kubespray $ git apply ~/path/to/tkai-k8s-yaml/multi/kubespray.diff
   ```

   You can furthermore configure the number of instances, cpu count, memory
   size, and disk sizes to allocate to the VMs via the Vagrantfile.

3. Then, start the cluster using this command.

   ```bash
   kubespray $ vagrant up --no-provision; vagrant provision;
   ```

   This takes around 30 minutes on a Thinkpad T450 with
   Intel i5-5300U (4) @ 2.900GHz, 16GB of RAM, and SSD. It also caches most of
   the kubernetes api server, etcd, and etc images to your host so it should be
   faster the next time you provision in.

4. After the cluster is ready, you can export the KUBECONFIG from the VM to use
   with your `kubectl` cli.

   ```bash
   kubespray $ vagrant ssh -c "sudo cat /etc/kubernetes/admin.conf" k8s-1 > kconfig
   kubespray $ export KUBECONFIG=$PWD/kconfig
   ```

   > Personally, I prefer setting my KUBECONFIG to point to each VMs cluster file.
   > There are also ways to switch between cluster context and flatten the
   > KUBECONFIG. However I wouldn't go further onto that topic.
   >
   > -- @giovanism

5. The enabled path provisioner is set but the StorageClass is not configured as
   default yet. Annotate the StorageClass to set it as the default StorageClass.

   ```bash
   $ kubectl annotate storageclasses.storage.k8s.io local-path storageclass.kubernetes.io/is-default-class=true
   ```

6. You can proceed into minikube's step by step setup no 2 to continue the
   deployment.
