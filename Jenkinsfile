
pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                echo 'Weather Dashboard source code is available.'
            }
        }

        stage('Validate Files') {
            steps {
                bat 'if exist "Live Weather Forecast Application.html" (echo HTML file found.) else (exit /b 1)'
                bat 'if exist "Dockerfile" (echo Dockerfile found.) else (exit /b 1)'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat '"C:\\Users\\jenee\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe" build -t weather-dashboard:latest .'
            }
        }

        stage('Verify Docker Image') {
            steps {
                bat '"C:\\Users\\jenee\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe" image inspect weather-dashboard:latest'
            }
        }
    }

    post {
        success {
            echo 'Weather Dashboard Docker CI pipeline completed successfully!'
        }
        failure {
            echo 'Weather Dashboard Docker pipeline failed. Check the Console Output.'
        }
    }
}
