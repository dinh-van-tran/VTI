# VTI Devops
- This repository contains source code for my VTI DevOps course.

## Exercise 1: Docker
- I created a simple http server by golang.
- Build and run command
```sh
docker build -t dinhtranvan/simple-http-server .
docker run -p 8080:8080 dinhtranvan/simple-http-server
```

## Exercise 2: K8s
- I created 3 files.
  + `deployment.yaml`: for deploying pod.
  + `service.yaml`: for route.
  + `deploy-k8s.sh`: for deploying 2 above files to k8s.

## Exercise 3: K8s (continue)
- [X] Creating a secrect store in k8s.
  + Created a new file [secret.yaml](k8s/secret.yaml) to store data. The data is encoded by base64 format.
  ```yaml
  apiVersion: v1
  kind: Secret
  metadata:
    name: secret
  # `Opaque` means that the secret is not decoded by Kubernetes.
  type: Opaque
  data:
    username: ZGluaC10cmFu
    password: ZGluaDE5OTA=
  ```

- [X] Access value in the container.
  + Mount secret store as a volume in [deployment.yaml](k8s/deployment.yaml). K8s automatically decodes base64 value.
  ```yaml
  containers:
  - name: simple-http-server
    image: dinhtranvan/simple-http-server:v2
    ports:
    - containerPort: 8080
    volumeMounts:
    - name: secret-volume
      mountPath: /etc/secret-volume
      readOnly: true

  volumes:
  - name: secret-volume
    secret:
      secretName: secret
  ```

- Access the data by go to link http://localhost:8080/credential
