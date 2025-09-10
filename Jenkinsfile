pipeline {
    agent any

    environment {
        REGISTRY = "image-registry.openshift-image-registry.svc:5000"
        PROJECT = "${OPENSHIFT_PROJECT}"
        IMAGE = "hello-world"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/YOUR_USERNAME/ocp-hello-world.git'
            }
        }

        stage('Login to OpenShift') {
            steps {
                sh '''
                  oc login https://api.cluster.example.com:6443 \
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
