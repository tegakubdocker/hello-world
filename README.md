# Download docker desktop

# Install homebrew for MacOS and kubectl
   Open terminal 
1. install homebrew 

   ```sh
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ``` 
2. Install kubectl 

   ```sh
   brew install kubectl
   ```
3. Verify version kubectl version 

   ```sh
   kubectl version
   ```

# Install VMware Fusion
Install VMware Fusion on your macOS machine. 
 1. Sign up create personal account.
 2. Go to all downloads and download VMware fusion
   ```sh
   https://www.vmware.com/products/fusion/fusion-evaluation.html 
   ```
 4. During installation go to vmware fusion website and pull licence key for personal use.

# Install Minikube
1. Install minikube 
   ```sh
   brew install minikube
   ```  
2. Start minikube 
  ```sh
  minikube start
  ```
3. Verify minikube is running 
  ```sh
  minikube status
  ```
# Install an ingress controller: 
We will use Nginx as the ingress controller. 
To install Nginx, run the following command: 
```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.0.0/deploy/static/provider/cloud/deploy.yaml 
```
This command will create a deployment for the Nginx ingress controller and a service that exposes it to the cluster
 deploy a simple Nginx server as follows: 
```sh
kubectl create deployment nginx --image=nginx 
```
```sh
kubectl expose deployment nginx --port=80 --type=NodePort
```

Install helm charts
```sh 
brew install helm 
```
Create kubernetes namespace
```sh 
kubectl create namespace everlyhealth 
```


# ArgoCD service in everlyhealth cluster
1. Deploy ArgoCD using Helm: ArgoCD is a continuous delivery tool that allows you to deploy applications to Kubernetes clusters. You can deploy ArgoCD to the everlyhealth namespace using the following command:
```sh
helm install argocd argo/argo-cd --namespace everlyhealth
```
2. To get argocd server name after deployment
```sh
kubectl get pods -n everlyhealth -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2 
```
3. Setup port fowarding for Argocd
```sh
kubectl port-forward service/argocd-server -n everlyhealth 8080:443
```
4. Get argoCD initial admin server password
```sh
kubectl -n everlyhealth get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```
# Gitea service in everyhealth cluster

1. Add gitea help repo
```sh
helm repo add gitea-charts https://dl.gitea.io/charts/
```

2. Install gitea in everlyhealth
```sh
helm install gitea gitea-charts/gitea --namespace everlyhealth
```
3. Setup port fowarding to reflect service config in ingress.yaml
```sh
 kubectl --namespace everlyhealth port-forward svc/gitea-http 3000:3000
 ```


## Installation

On systems with Homebrew package manager, the “Using Package Managers” method is recommended. On other systems, “Basic Git Checkout” might be the easiest way of ensuring that you are always installing the latest version of rbenv.

### Using Package Managers

1. Install rbenv using one of the following approaches.

   #### Homebrew
   
   On macOS or Linux, we recommend installing rbenv with [Homebrew](https://brew.sh).
   
   ```sh
   brew install rbenv ruby-build
   ```
   
   #### Debian, Ubuntu, and their derivatives
       
   Note that the version of rbenv that is packaged and maintained in the
   Debian and Ubuntu repositories is _out of date_. To install the latest
   version, it is recommended to [install rbenv using git](#basic-git-checkout).
   
   ```sh
   sudo apt install rbenv
   ```
   
   #### Arch Linux and its derivatives
   
   Archlinux has an [AUR Package](https://aur.archlinux.org/packages/rbenv/) for
   rbenv and you can install it from the AUR using the instructions from this
   [wiki page](https://wiki.archlinux.org/index.php/Arch_User_Repository#Installing_and_upgrading_packages).

2. Learn how to load rbenv in your shell.

    ```sh
    rbenv init
    ```

3. Close your Terminal window and open a new one so your changes take effect.

That's it! You are now ready to [install some Ruby versions](#installing-ruby-versions).

### Basic Git Checkout

> **Note**  
> For a more automated install, you can use [rbenv-installer](https://github.com/rbenv/rbenv-installer#rbenv-installer). If you do not want to execute scripts downloaded from a web URL or simply prefer a manual approach, follow the steps below.

This will get you going with the latest version of rbenv without needing a system-wide install.

1. Clone rbenv into `~/.rbenv`.

    ```sh
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    ```

2. Configure your shell to load rbenv:

   * For **bash**:
     
     _Ubuntu Desktop_ users should configure `~/.bashrc`:
     ```bash
     echo 'eval "$(~/.rbenv/bin/rbenv init - bash)"' >> ~/.bashrc
     ```

### Install rails

go to the .rbenv directory from command line

1. Upgrade to latest ruby version to be compatible with activesupport. do this in the project directory of .rbenv
```sh
rbenv install 3.1.2
```
2. to activate ruby version run 
```sh
rbenv global 3.1.2
```
3. go to rvm.io
```sh
www.rvm.io
```
4. install default ruby and rails in one command
```sh
\curl -sSL https://get.rvm.io | bash -s stable --rails
```

### Create a Hello-world rails application

1. creating rails hello world application on project directory everlyasagba
```sh
rails new hello-world
```
2. dockerize the rails application and create a dockerfile
3. create a .dockerignore in the same directory
4. Build the docker image 
```sh
docker build -t hello-world .
```
5. create the helm charts
```sh
helm create hello-world
```
6. create a new file in the templates directory called hello-world.yaml and configure this file accordingly to define any deployment and service for the rails application.

7. tag the docker image. note docker username is tegafreshest
```sh
docker tag hello-world:latest tegafreshest/hello-world:1.0.0
```
8. push docker image to docker hub. note docker username is tegafreshest
```sh
docker push tegafreshest/hello-world:1.0.0
```
9. deploy the rails application to the cluster using helm
```sh
helm install hello-world ./hello-world --namespace everlyhealth
```
10. verify the deployment 
```sh
kubectl get all -n dev
```
11. Get pod name for hello-world
```sh
kubectl get pods --namespace everlyhealth
```
12. export the pod name
```sh
export POD_NAME=hello-world-f9795b545-gztv7
```
13. Export container port
```sh
export CONTAINER_PORT=$(kubectl get pod --namespace everlyhealth $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
```

14. setup port fowarding
```sh
kubectl --namespace everlyhealth port-forward svc/hello-world 3000:80
```
15. access the app on 
```sh
127.0.0.1:3000
```

### Access Logs from ingress controller while accessing service

1. find the ingress controller pod name.
```sh
kubectl get pods -n everlyhealth
```
2. get ingress controller name set in ingress.yaml
```sh
kubectl get ingress -n everlyhealth
```
3. display logs from the ingress controller pod. using ArgoCd server pod
```sh
kubectl logs -n everlyhealth argocd-server-645c6ffcd8-zzfn2 
```




