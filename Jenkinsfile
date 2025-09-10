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
                  oc new-project $OPENSHIFT_PROJECT
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
                # apply deployment, service, and route from yaml
                oc apply -f contoh.yaml -n $OPENSHIFT_PROJECT

                # restart deployment to use new image
                oc rollout restart deployment/$IMAGE -n $OPENSHIFT_PROJECT

                # wait until rollout is complete
                oc rollout status deployment/$IMAGE -n $OPENSHIFT_PROJECT
                '''
            }
        }
    }
}