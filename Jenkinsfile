
pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'jeneera/weather-dashboard'
    }

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
                bat '"C:\\Users\\jenee\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe" build -t %DOCKER_IMAGE%:latest .'
            }
        }

        stage('Verify Docker Image') {
            steps {
                bat '"C:\\Users\\jenee\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe" image inspect %DOCKER_IMAGE%:latest'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKERHUB_USER',
                    passwordVariable: 'DOCKERHUB_TOKEN'
                )]) {
                    bat '"C:\\Users\\jenee\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe" login -u %DOCKERHUB_USER% --password-stdin < nul'
                    bat 'echo %DOCKERHUB_TOKEN% | "C:\\Users\\jenee\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe" login -u %DOCKERHUB_USER% --password-stdin'
                    bat '"C:\\Users\\jenee\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe" push %DOCKER_IMAGE%:latest'
                }
            }
        }
    }

    post {
        success {
            echo 'Weather Dashboard image pushed successfully to Docker Hub!'
        }
        failure {
            echo 'Pipeline failed. Check Console Output.'
        }
    }
}
