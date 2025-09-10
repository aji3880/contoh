pipeline {
    agent any

    environment {
        REGISTRY = "image-registry.openshift-image-registry.svc:5000"
        PROJECT = "contoh" 
        IMAGE = "contoh"
        OPENSHIFT_TOKEN="sha256~z-H-0gekzAMz36knBoxHdJJLcLbzMRFmH6SW5WFqdDg"
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
