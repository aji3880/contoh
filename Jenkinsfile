pipeline {
    agent any

    environment {
        REGISTRY = "image-registry.openshift-image-registry.svc:5000"
        PROJECT = "contoh"
        IMAGE = "contoh"
        CHART_NAME = "contoh"
        RELEASE_NAME = "contoh"
        OPENSHIFT_TOKEN = "sha256~T1CjB8uU7nkZ2HFBPgMr9tRlCsaB9pE_BgWQw_34_BU"
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
                sh '''
                oc new-build --name=$IMAGE --binary --strategy=docker --to=$IMAGE:latest --to-docker=true --push-secret=builder-dockercfg \
                    || oc start-build $IMAGE --from-dir=. --follow --wait
                '''
            }
        }

        stage('Helm Deploy') {
            steps {
                sh '''
                  helm upgrade --install $RELEASE_NAME ./helm/$CHART_NAME \
                    --namespace $OPENSHIFT_PROJECT \
                    --set image.repository=$REGISTRY/$PROJECT/$IMAGE \
                    --set image.tag=latest
                '''
            }
        }
    }
}
