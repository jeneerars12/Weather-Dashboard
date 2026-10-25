
pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'jeneera/weather-dashboard'
        DOCKER_EXE = 'C:\\Users\\jenee\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin\\docker.exe'

        // Replace with your current EC2 public IPv4 address
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
                    echo Docker image built successfully.
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
                credentialsId: 'ec2-ssh-key',
                keyFileVariable: 'SSH_KEY',
                usernameVariable: 'SSH_USER'
            )
        ]) {
            powershell '''
                $ErrorActionPreference = "Stop"

                $key = $env:SSH_KEY
                $hostIp = $env:EC2_HOST
                $user = $env:SSH_USER

                # Restrict the temporary private key to the Jenkins service account.
                $account = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

                & icacls.exe $key /inheritance:r
                if ($LASTEXITCODE -ne 0) {
                    throw "Could not disable key-file permission inheritance."
                }

                & icacls.exe $key /grant:r "${account}:(R)"
                if ($LASTEXITCODE -ne 0) {
                    throw "Could not grant the Jenkins account read access."
                }

                # Deploy the latest image to EC2.
                & ssh.exe -i $key `
                    -o StrictHostKeyChecking=yes `
                    -o ConnectTimeout=15 `
                    "$($user)@$($hostIp)" `
                    "sudo docker pull jeneera/weather-dashboard:latest && (sudo docker rm -f weather-dashboard || true) && sudo docker run -d --name weather-dashboard --restart unless-stopped -p 80:80 jeneera/weather-dashboard:latest"

                if ($LASTEXITCODE -ne 0) {
                    throw "SSH deployment failed. Check the SSH key, host key, and EC2 access."
                }

                Write-Host "Deployment to AWS EC2 completed successfully."
            '''
        }
    }
}

   

    post {
        success {
            echo 'SUCCESS: Weather Dashboard built, pushed, and deployed to AWS EC2!'
        }

        failure {
            echo 'FAILED: Check the Console Output for the exact error.'
        }

        always {
            echo 'Weather Dashboard CI/CD pipeline finished.'
        }
    }
}

