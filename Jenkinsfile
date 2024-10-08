pipeline {
  agent any
  
  stages {
    stage('build the project') {
      steps {
        git 'https://github.com/PoojaPulivarthi/Healthcare-project.git'
        sh 'mvn clean package'
      }
    }
    stage('Building docker image') {
      steps {
        script {
          sh 'docker build -t poojapulivarthi39/healthcare-project:v1 .'
          sh 'docker images'
        }
      }
    }
    stage('push to docker-hub') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'docker-login', passwordVariable: 'dockerpassword', usernameVariable: 'dockerlogin')]) {
          sh "echo $dockerpassword | docker login -u $dockerlogin --password-stdin"
          sh 'docker push poojapulivarthi39/healthcare-project:v1'
        }
      }
    }
    stage('Terraform Operations for test workspace') {
      steps {
        script {
          withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                                       accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                                       credentialsId: 'aws-access-key-id', 
                                       secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
          sh '''
            terraform workspace select test || terraform workspace new test
            terraform init
            terraform plan
            terraform destroy -auto-approve
          '''
        }
        }
      }
    }
    stage('Terraform destroy & apply for test workspace') {
      steps {
        sh 'terraform apply -auto-approve'
      }
    }
    stage('get kubeconfig') {
      steps {
        sh 'aws eks update-kubeconfig --region ap-south-1 --name test-cluster'
        sh 'kubectl get nodes'
      }
    }
    stage('Deploying the application') {
      steps {
        sh 'kubectl apply -f k8s-deploy.yml'
        sh 'kubectl get svc'
      }
    }
    stage('Terraform Operations for Production workspace') {
      when {
        expression {
          return currentBuild.currentResult == 'SUCCESS'
        }
      }
      steps {
        script {
          withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                                       accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                                       credentialsId: 'aws-access-key-id', 
                                       secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]){
          sh '''
            terraform workspace select prod || terraform workspace new prod
            terraform init
            terraform plan
            terraform destroy -auto-approve
          '''
        }
        }
      }
    }
    stage('Terraform destroy & apply for production workspace') {
      steps {
        sh 'terraform apply -auto-approve'
      }
    }
    stage('get kubeconfig for production') {
      steps {
        sh 'aws eks update-kubeconfig --region ap-south-1 --name prod-cluster'
        sh 'kubectl get nodes'
      }
    }
    stage('Deploying the application to production') {
      steps {
        sh 'kubectl apply -f k8s-deploy.yml'
        sh 'kubectl get svc'
      }
    }
  }
}
