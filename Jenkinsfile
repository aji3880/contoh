pipeline {
    agent any

    environment {
        REGISTRY = "image-registry.openshift-image-registry.svc:5000"
        PROJECT = "${OPENSHIFT_PROJECT}"
        IMAGE = "contoh"
        OPENSHIFT_TOKEN="ha256~z-H-0gekzAMz36knBoxHdJJLcLbzMRFmH6SW5WFqdDg"
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
                  oc login https://api.cluster-459j4.dynamic.redhatworkshops.io:6443 \
                    --token=$OPENSHIFT_TOKEN \
                    --insecure-skip-tls-verify=true
                  oc project $OPENSHIFT_PROJECT
                '''
            }
        }

        stage('Build Image') {
            steps {
                sh '''
                  podman build -t $REGISTRY/$PROJECT/$IMAGE:latest .
                  podman push $REGISTRY/$PROJECT/$IMAGE:latest
                '''
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                  oc apply -f hello-world.yaml -n $OPENSHIFT_PROJECT
                '''
            }
        }
    }
}
