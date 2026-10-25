
pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'jeneera/weather-dashboard'
        DOCKER_EXE = 'C:\\Users\\jenee\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe'
        EC2_HOST = '52.200.215.26'
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
                    if not exist "Dockerfile" exit /b 1
                    if not exist "Jenkinsfile" exit /b 1
                    if not exist "Live Weather Forecast Application.html" exit /b 1
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

        stage('Docker Login and Push') {
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
                        "%DOCKER_EXE%" push %DOCKER_IMAGE%:latest
                        if errorlevel 1 exit /b 1
                        echo Docker image pushed successfully.
                    '''
                }
            }
        }

        stage('Deploy to AWS EC2') {
            steps {
                withCredentials([
                    sshUserPrivateKey(
                        credentialsId: '6969592c-11cd-40a6-90d9-8c950e4ab623',
                        keyFileVariable: 'SSH_KEY',
                        usernameVariable: 'SSH_USER'
                    )
                ]) {
                    bat '''
                        @echo off
                        ssh -i "%SSH_KEY%" -o StrictHostKeyChecking=no -o ConnectTimeout=15 %SSH_USER%@%EC2_HOST% "sudo docker pull jeneera/weather-dashboard:latest && (sudo docker rm -f weather-dashboard || true) && sudo docker run -d --name weather-dashboard --restart unless-stopped -p 80:80 jeneera/weather-dashboard:latest"
                        if errorlevel 1 exit /b 1
                        echo Deployment to AWS EC2 completed.
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'SUCCESS: Weather Dashboard built, pushed, and deployed to AWS EC2!'
        }

        failure {
            echo 'FAILED: Check the Jenkins Console Output for the exact error.'
        }

        always {
            echo 'Weather Dashboard CI/CD pipeline finished.'
        }
    }
}
