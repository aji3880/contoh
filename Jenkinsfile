pipeline {
    agent any

    environment {
        PROJECT = "contoh"
        IMAGE = "contoh"
        OPENSHIFT_PROJECT = "contoh" 
        OPENSHIFT_TOKEN = "sha256~z-H-0gekzAMz36knBoxHdJJLcLbzMRFmH6SW5WFqdDg"
        OPENSHIFT_SERVER = "https://api.cluster-459j4.dynamic.redhatworkshops.io:6443"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/aji3880/contoh.git'
            }
        }

        stage('Login to OpenShift') {
            steps {
                sh '''
                  oc login $OPENSHIFT_SERVER \
                     --token=$OPENSHIFT_TOKEN \
                     --insecure-skip-tls-verify=true
                  oc project $OPENSHIFT_PROJECT
                '''
            }
        }

        stage('Generate Deployment YAML') {
    steps {
                writeFile file: 'contoh.yaml', text: '''
        apiVersion: apps/v1
        kind: Deployment
        metadata:
        name: contoh
        labels:
            app: contoh
        spec:
        replicas: 1
        selector:
            matchLabels:
            app: contoh
        template:
            metadata:
            labels:
                app: contoh
            spec:
            containers:
                - name: contoh
                image: image-registry.openshift-image-registry.svc:5000/contoh/contoh:latest
                ports:
                    - containerPort: 8080
        ---
        apiVersion: v1
        kind: Service
        metadata:
        name: contoh
        spec:
        selector:
            app: contoh
        ports:
            - port: 80
            targetPort: 8080
        ---
        apiVersion: route.openshift.io/v1
        kind: Route
        metadata:
        name: contoh
        spec:
        to:
            kind: Service
            name: contoh
        port:
            targetPort: 80
        '''
            }
        }
                stage('Build in OpenShift') {
            steps {
                sh '''
                  # kalau build config belum ada, buat dulu
                  oc get bc $IMAGE || oc new-build --binary --name=$IMAGE -l app=$IMAGE

                  # trigger build dari source code di workspace Jenkins
                  oc start-build $IMAGE --from-dir=. --follow --wait
                '''
            }
        }

    }
}