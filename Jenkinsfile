
pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'jeneera/weather-dashboard'
        DOCKER_EXE = 'C:\\Users\\jenee\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe'
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
                bat '"%DOCKER_EXE%" build -t %DOCKER_IMAGE%:latest .'
            }
        }

        stage('Verify Docker Image') {
            steps {
                bat '"%DOCKER_EXE%" image inspect %DOCKER_IMAGE%:latest'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-credentials',
                        usernameVariable: 'DOCKERHUB_USER',
                        passwordVariable: 'DOCKERHUB_TOKEN'
                    )
                ]) {
                    bat '''
                        @echo off
                        "%DOCKER_EXE%" login -u "%DOCKERHUB_USER%" --password-stdin < nul
                    '''
                    bat '''
                        @echo off
                        echo %DOCKERHUB_TOKEN% | "%DOCKER_EXE%" login -u "%DOCKERHUB_USER%" --password-stdin
                        if errorlevel 1 exit /b 1
                        "%DOCKER_EXE%" push %DOCKER_IMAGE%:latest
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'SUCCESS: Weather Dashboard image pushed to Docker Hub!'
        }

        failure {
            echo 'FAILED: Check Console Output for the error.'
        }

        always {
            echo 'Weather Dashboard CI pipeline finished.'
        }
    }
}
