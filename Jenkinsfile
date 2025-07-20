pipeline {
    agent any

    environment {
        // GCP Service Account Credential ID stored in Jenkins
        GOOGLE_APPLICATION_CREDENTIALS = credentials('gcp-sa-key')

        // Your GCP project details
        PROJECT_ID = 'sylvan-hydra-464904-d9'
        REGION = 'asia-south1'

        // Docker image details
        IMAGE_NAME = 'flask-hello-world'

        // Target deployment VM details
        DEPLOY_VM = '34.56.51.194'
        DEPLOY_USER = 'praveen_a' // e.g., ubuntu
    }

    stages {

        stage('Clone Repo') {
            steps {
                git branch: 'main', url: 'https://github.com/Praveenarumugam07/flask-hello-world.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                docker build -t gcr.io/$PROJECT_ID/$IMAGE_NAME:latest .
                """
            }
        }

        stage('Push to GCR') {
            steps {
                withCredentials([file(credentialsId: 'gcp-sa-key', variable: 'GOOGLE_APPLICATION_CREDENTIALS_FILE')]) {
                    sh """
                    gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS_FILE
                    gcloud auth configure-docker
                    docker push gcr.io/$PROJECT_ID/$IMAGE_NAME:latest
                    """
                }
            }
        }

        stage('Deploy to VM') {
            steps {
                sh """
                gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
                gcloud compute ssh $DEPLOY_USER@$DEPLOY_VM --project=$PROJECT_ID --command="docker pull gcr.io/$PROJECT_ID/$IMAGE_NAME:latest && docker stop $IMAGE_NAME || true && docker rm $IMAGE_NAME || true && docker run -d --name $IMAGE_NAME -p 80:80 gcr.io/$PROJECT_ID/$IMAGE_NAME:latest"
                """
            }
        }
    }
}
