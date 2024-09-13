pipeline {
  agent any
   tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "M2_HOME"
        git "git s/w"
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
           sh "echo $dockerpassword | docker login -u $dockerlogin --password-stdin"
           sh 'docker push poojapulivarthi39/healthcare-project:v1'
                              }
                        }
                }
     stage('Terraform Operations for test workspace') {
      steps {
        script {
          sh '''
            terraform workspace select test || terraform workspace new test
            terraform init
            terraform plan
            terraform destroy -auto-approve
            terraform apply -auto-approve
          '''
        }
      }
    }
    
     stage('Deploy to EKS') {
       steps {
                script {
                    // Set up AWS credentials
                    sh '/usr/local/bin/aws eks update-kubeconfig --name eks-healthcare-cluster --region ap-south-1'
                    
                    // Apply Kubernetes manifests to deploy the app
                    sh 'kubectl apply -f k8s-deploy.yaml'
                }
            }
        }

    
    
  }
}
