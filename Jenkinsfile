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

     stage("docker build & docker push"){
            steps{
                script{
                    withCredentials([string(credentialsId: 'docker_nexus_pass', variable: 'docker_nexus_passwd')]) {
                                
                                sh '''
                                docker build -t 34.93.115.30:8083/springapp:$v1.$BUILD_ID .
                                docker login -u admin -p sonarqube 34.93.115.30:8083 
                                docker push  34.93.115.30:8083/springapp:$v1.$BUILD_ID
                                docker rmi 34.93.115.30:8083/springapp:$v1.$BUILD_ID
                            '''
                        }
                    }
                }
            }
        }
       
}