pipeline {
    agent any

    environment {
        REGISTRY = "quay.io/yourrepo"
        IMAGE_NAME = "contoh"
        IMAGE_TAG = "latest"
        OPENSHIFT_PROJECT = "contoh"
        HELM_RELEASE = "go-ocp-app"
        OPENSHIFT_TOKEN = "sha256~ly1PoenMCC2cVqwCyYxnZf78vZasp4vWWZZjMiQFwVE"
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

        stage('Build Image') {
            steps {
                script {
                    sh """
                    oc start-build $IMAGE_NAME --from-dir=. --follow || oc new-build --binary=true --name=$IMAGE_NAME -l app=$IMAGE_NAME
                    oc start-build $IMAGE_NAME --from-dir=. --follow
                    """
                }
            }
        }

        stage('Deploy to OpenShift') {
            steps {
                script {
                    sh """
                    oc project $OPENSHIFT_PROJECT
                    helm upgrade --install $HELM_RELEASE ./helm-chart \
                        --set image.repository=$REGISTRY/$IMAGE_NAME \
                        --set image.tag=$IMAGE_TAG
                    """
                }
            }
        }
    }
}