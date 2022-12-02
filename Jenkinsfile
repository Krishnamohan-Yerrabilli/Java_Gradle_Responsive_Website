pipeline{
    agent any 
    stages{
        stage("sonar quality check"){
            agent{
            steps{
                docker {
                    image: "openJDK:11"
                }
            }
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
       
}