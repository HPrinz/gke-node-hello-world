## CircleCI

1. [ServiceAccount erstellen](https://cloud.google.com/iam/docs/creating-managing-service-accounts): 

- Name: `circleCI`
- *Owner* auswählen
- *JSON-Schlüssel* auswählen
- nach Bestätigung wird eine JSON-Datei heruntergeladen

2. In CircleCI unter Einstellungen --> Enviroment Variables -> New

| Name        | Value                                                        |
| ----------- | ------------------------------------------------------------ |
| GCP_PROJECT | *dein Google Cloud Projektname*                              |
| GOOGLE_AUTH | *Inhalt der durch Google Cloud heruntergeladenen JSON-Datei* |
| IMAGE_NAME  | gke-node-hello-world                                         |

Details siehe [CircleCI & GKE Docker Registry Tutorial](https://vsupalov.com/build-docker-image-with-circle-ci-2-push-to-google-container-registry/)

