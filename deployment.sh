apiVersion: apps/v1
kind: Deployment
metadata:
  name: azdo-agent
  namespace: selfhosted
spec:
  replicas: 1
  selector:
    matchLabels:
      app: azdo-agent
  template:
    metadata:
      labels:
        app: azdo-agent
    spec:
      restartPolicy: Always
      containers:
      - name: azdo-agent
        image: hardikpoc.azurecr.io/kaniko-build:latest
        env:
        - name: AZP_URL
          value: "https://dev.azure.com/hardikkumarchauhan0390"
        - name: AZP_TOKEN
          valueFrom:
            secretKeyRef:
              name: azure-devops-secret
              key: AZP_TOKEN
        - name: AZP_POOL
          value: "kaniko-agent"

