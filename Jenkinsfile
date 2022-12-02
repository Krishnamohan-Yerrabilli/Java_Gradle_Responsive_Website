pipeline{
    agent any 
    stages{
        stage("sonar quality check"){
            
            steps{
                script{
                    //Gradle build 
                    withSonarQubeEnv(credentialsId: 'sonar_token_for_jenkins') {
                            sh 'chmod +x gradlew'
                            sh './gradlew sonarqube'
                    }
                    //quality gate status check
                    timeout(time: 10, unit: 'MINUTES') {
                      def qg = waitForQualityGate()
                      if (qg.status != 'OK') {
                           error "Pipeline aborted due to quality gate failure: ${qg.status}"
                      }
                    }
                }
            }
            
        }
    }
       
}