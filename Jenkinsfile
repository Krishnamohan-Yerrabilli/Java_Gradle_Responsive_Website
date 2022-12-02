pipeline{
    agent any 
    stages{
        stage("sonar quality check"){
            
            steps{ 
                script{
                    withSonarQubeEnv(credentialsId: 'sonar_token_for_jenkins') {
                            sh 'chmod +x gradlew'
                            sh './gradlew sonarqube'
                    }
                }
            }
            

            
        }
    }
       
}