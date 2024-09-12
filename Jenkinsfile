pipeline {
  agent any
  environment {
    AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
    AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
  }
  stages {
    stage('build mvn project') {
      steps {
        git 'https://github.com/lax66/star-agile-health-care_CAP02.git'
        sh 'mvn clean package'
      }
    }
    stage('Build docker image') {
      steps {
        script {
          sh 'docker build -t poojapulivarthi39/healthcare-project:v1 .'
          sh 'docker images'
        }
      }
    }
    stage('Docker-Login') {
      steps {
           withCredentials([usernamePassword(credentialsId: 'docker-login', passwordVariable: 'dockerpassword', usernameVariable: 'dockerlogin')]) {
           sh 'docker login -u ${dockerlogin} -p ${dockerpassword}'
           sh 'docker push poojapulivarthi39/healthcare-project:v1'
                              }
                        }
                }
     stage('Config & Deployment') {
            steps {
                withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'AwsAccessKey', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    dir('terraform-files') {
                    sh 'sudo chmod 600 mumbaikey.pem'
                    sh 'terraform init'
                    sh 'terraform validate'
                    sh 'terraform apply --auto-approve'
                    }
                }   
            }
        }

    
  }
}
