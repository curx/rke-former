# b1dod2020-kubernetes-deployment

a full stack of Deployments : Kubernetes on OpenStack with the help of terraform and rke - called rke-former

# Steps

1) Get needed binaries

- terraform (v0.12+) [Download](https://www.terraform.io/downloads.html)
- rke (1.0.1) [Download](https://github.com/rancher/rke/releases/tag/v1.0.1)
- kubernetes-cli (v1.16.3+) [Overview of KubeBinaries](https://downloadkubernetes.com)

2) Setup credentials for OpenStack

Populate the OpenStack files clouds.yaml, secure.yaml and export the clouds var

```bash=
export OS_CLOUD=<section>
```

3) Get the code

```bash=
git clone git@git.intern.b1-systems.de:schifferdecker/b1dod2020-kubernetes-deployments.git rke-former
cd $_
```

4) Start the terraforming

```
terraform init [<opts>]
terraform plan [<opts>]
```

5) Kubernetes Deployment via rke

```bash=
cd rke
rke up
# wait some minutes, a good chance to fetch a cup of coffee
```

6) Use the kubeconfig

```bash=
export KUBECONFIG=$PWD/k/kube_config_cluster.yml
kubectl get nodes --output wide
```

# Links

- RancherKubernetesEngine (rke) [Docs](https://rancher.com/docs/rke/latest/)
- K8spin - a Kubernetes Namespace for free, check it out [K8spin](https://k8spin.cloud/)


# Contribute

Fork -> Patch -> Pull request -> Merge

# Author

`Thorsten Schifferdecker <schifferdecker@b1-systems.de>`

# License

`GPL-3`

