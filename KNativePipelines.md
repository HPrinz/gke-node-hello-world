# Knative Pipelines

## Installieren

[Getting Started](https://github.com/knative/build-pipeline/blob/master/DEVELOPMENT.md) durchgehen - zusammengefasst:

- install [go](https://golang.org/doc/install), git, [dep](https://github.com/golang/dep), [ko](https://github.com/google/go-containerregistry/tree/master/cmd/ko), kubectl, gcloud, docker

- gcloud konfigurieren

  ```bash
  gcloud services enable \
    cloudapis.googleapis.com \
    container.googleapis.com \
    containerregistry.googleapis.com
    
  gcloud auth configure-docker
  ```

- Cluster erstellen

  ```bash
  gcloud container clusters create knative-pipelines-example \
    --zone=europe-west3-c \
    --cluster-version=latest \
    --machine-type=n1-standard-4 \
    --enable-autoscaling --min-nodes=1 --max-nodes=10 \
    --enable-autorepair \
    --scopes=service-control,service-management,compute-rw,storage-ro,cloud-platform,logging-write,monitoring-write,pubsub,datastore \
    --num-nodes=3
  ```

- Umgebungsvariablen in `.bashrc` oder `.zshrc` hinzufügen:

  ```bash
  export GOPATH="$HOME/go"
  export PATH="${PATH}:${GOPATH}/bin"
  export GKE_PROJECT='gcr.io/<my-gcloud-project-name>'
  ```

- fork oder clone [KNative Pipelines Repo](https://github.com/knative/build-pipeline)

  ```bash
  mkdir -p ${GOPATH}/src/github.com/knative
  cd ${GOPATH}/src/github.com/knative
  # if you use a fork, replace knative with your GitHub Username
  git clone git@github.com:knative/build-pipeline.git 
  cd build-pipeline
  ```

- Admin Clusterrolebinding hinzufügen

  ```bash
  kubectl create clusterrolebinding cluster-admin-binding \
      --clusterrole=cluster-admin \
      --user=$(gcloud config get-value core/account)
  ```

- KNative Pipeline mit CRDs installieren

  ```bash
  ko apply -f config/
  kubectl apply -f ./third_party/config/build/release.yaml
  ```





## Beispielpipeline für NodeJS Hello World

Umfang:

- pull des git repo
- kaniko multistage build 
- commit der images auf die Google Container Registry
- deploy auf das GKE-Cluster

Todo:

- Pipeline bei jedem commit triggern ([Knative Eventing](https://github.com/knative/docs/tree/master/eventing))
- Transparenz/Notifications

Schritte:

- ersetzte  `<your-project>` mit der Google Cloud Projekt ID in `knative-pipelines/02_resources.yaml` 

- installiere die Komponetenten der Pipeline

  ```bash
  cd <repo>
  kubectl apply -f knative-pipelines/
  ```

- Deployment prüfen

  ```bash
  kubectl get pods
  ```

  sollte etwa folgendes anzeigen:

  ```
  NAME                                                       READY     STATUS      RESTARTS   AGE
  build-push-run-pod-2a7fc9                                  0/1       Completed   0          33m
  hello-node-deployment-5c5f488c84-77hr8                     1/1       Running     0          29m
  hellonode-pipeline-run-1-build-hellonode-app-pod-f162f8    0/1       Completed   0          33m
  hellonode-pipeline-run-1-deploy-hellonode-app-pod-e95598   0/1       Completed   0          29m
  ```

- Hello KNative Pipelines

  ```bash    
  kubectl port-forward service/hellonode 8080:80
  curl localhost:8080
  ```

  sollte folgendes ausgeben:

  ```
  Hello World!
  ```



## Logs

```bash
  kubectl -n knative-build-pipeline logs $(kubectl -n knative-build-pipeline get pods -l app=build-pipeline-controller -o name)
```

```bash
  kubectl -n knative-build-pipeline logs $(kubectl -n knative-build-pipeline get pods -l app=build-pipeline-webhook -o name)
```

