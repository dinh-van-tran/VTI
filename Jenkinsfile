pipeline {
    agent any
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    def gitSha = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
                    sh "docker build -t dinhvantran/simple-http-server:${gitSha} ."
                }
            }
        }
        stage('Test') {
            steps {
                echo 'Test'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploy'
            }
        }
    }
}
