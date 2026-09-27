pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                echo 'Weather Dashboard source code checked out from GitHub.'
            }
        }

        stage('Build') {
            steps {
                echo 'Building Weather Dashboard application...'
            }
        }

        stage('Test') {
            steps {
                echo 'Testing Weather Dashboard application...'
            }
        }

    }

    post {
        success {
            echo 'Weather Dashboard CI pipeline completed successfully!'
        }

        failure {
            echo 'Weather Dashboard CI pipeline failed.'
        }
    }
}