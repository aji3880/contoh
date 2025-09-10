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

        stage('Deploy') {
            steps {
                sh '''
                  # kalau belum ada deployment, buat dari imagestream
                  oc get dc $IMAGE || oc new-app $IMAGE:latest

                  # rollout deployment
                  oc rollout latest dc/$IMAGE || true

                  # expose service kalau belum ada
                  oc get route $IMAGE || oc expose svc/$IMAGE
                '''
            }
        }
    }
}

