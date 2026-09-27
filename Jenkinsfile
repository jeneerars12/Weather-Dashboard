pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                echo 'Weather Dashboard source code is available in the Jenkins workspace.'
            }
        }

        stage('Build') {
            steps {
                bat 'if exist "Live Weather Forecast Application.html" (echo Weather Dashboard HTML file found.) else (exit /b 1)'
            }
        }

        stage('Test') {
            steps {
                bat 'if exist "Live Weather Forecast Application.html" (echo Weather Dashboard test passed.) else (exit /b 1)'
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