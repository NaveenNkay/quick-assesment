pipeline {
    agent any
    environment {
        GOOGLE_APPLICATION_CREDENTIALS = credentials('GCP-SA') // Use credentials stored in Jenkins
        GIT_TOKEN = credentials('git-token')
    }
    stages {
        stage('Checkout') {
            steps {
                // Checkout code from the Git repository
                git url: "https://github.com/NaveenNkay/quick-assesment.git", 
		 credentialsId: 'git-token'
            }
        }
        stage('Terraform Init') {
            steps {
                script {
                    // Initialize Terraform and configure remote backend for state storage in GCS
                    sh 'terraform init'
                }
            }
        }
        stage('Terraform Validate') {
            steps {
                script {
                    // Validate Terraform configuration
                    sh 'terraform validate'
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                script {
                    // Generate a plan for Terraform deployment
                    sh 'terraform plan -out=tfplan'
                }
            }
        }
		 stage('Manual Approval for Apply') {
            steps {
                script {
                    // Pause and wait for manual approval
                    input message: 'Do you want to apply these changes to GCP?', ok: 'Yes, Apply', cancel: 'Cancel'
                }
            }
        }
    }
}
