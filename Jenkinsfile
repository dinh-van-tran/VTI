pipeline {
    agent any
    stages {
        stage('Get Latest Docker Image for Caching') {
            steps {
                script {
                    sh "docker pull dinhtranvan/simple-http-server:latest"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def gitSha = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
                    sh "docker build -t dinhtranvan/simple-http-server:${gitSha} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    script {
                        def gitSha = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
                        sh "docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}"
                        sh "docker push dinhtranvan/simple-http-server:${gitSha}"
                    }
                }
            }
        }

        stage('') {
            steps {
                script {
                    sh "docker pull dinhtranvan/simple-http-server:latest"
                }
            }
        }
    }
}