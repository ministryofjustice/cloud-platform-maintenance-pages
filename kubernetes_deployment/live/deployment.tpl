apiVersion: apps/v1
kind: Deployment
metadata:
  name: maintenance-pages-app
  namespace: maintenance-pages
spec:
  replicas: 4
  selector:
    matchLabels:
      app: maintenance-pages-app
  template:
    metadata:
      labels:
        app: maintenance-pages-app
    spec:
      containers:
        - name: sinatra-app
          image: 754256621582.dkr.ecr.eu-west-2.amazonaws.com/${ECR_REPOSITORY}:${IMAGE_TAG}
          ports:
          - containerPort: 4567
