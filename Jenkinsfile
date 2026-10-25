
pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'jeneera/weather-dashboard'
        DOCKER_EXE = 'C:\\Users\\jenee\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe'
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'master',
                    url: 'https://github.com/jeneerars12/Weather-Dashboard.git'
            }
        }

        stage('Validate Files') {
            steps {
                bat '''
                    @echo off
                    if not exist "Dockerfile" (
                        echo ERROR: Dockerfile not found!
                        exit /b 1
                    )
                    if not exist "Jenkinsfile" (
                        echo ERROR: Jenkinsfile not found!
                        exit /b 1
                    )
                    if not exist "Live Weather Forecast Application.html" (
                        echo ERROR: HTML application file not found!
                        exit /b 1
                    )
                    echo All required files are present.
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                bat '''
                    @echo off
                    "%DOCKER_EXE%" build -t %DOCKER_IMAGE%:latest .
                    if errorlevel 1 exit /b 1
                '''
            }
        }

        stage('Verify Docker Image') {
            steps {
                bat '''
                    @echo off
                    "%DOCKER_EXE%" image inspect %DOCKER_IMAGE%:latest
                    if errorlevel 1 exit /b 1
                    echo Docker image verified successfully.
                '''
            }
        }

        stage('Docker Login') {
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
                        echo %DOCKERHUB_TOKEN%| "%DOCKER_EXE%" login -u "%DOCKERHUB_USER%" --password-stdin
                        if errorlevel 1 exit /b 1
                    '''
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                bat '''
                    @echo off
                    "%DOCKER_EXE%" push %DOCKER_IMAGE%:latest
                    if errorlevel 1 exit /b 1
                    echo Image pushed successfully to Docker Hub.
                '''
            }
        }
    }

    post {
        success {
            echo 'SUCCESS: Weather Dashboard image built, verified, and pushed to Docker Hub!'
        }

        failure {
            echo 'FAILED: Check the Jenkins Console Output for the stage that failed.'
        }

        always {
            echo 'Weather Dashboard CI pipeline finished.'
        }
    }
}
