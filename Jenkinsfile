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
                                docker build -t 34.93.115.30:8083/springapp:$BUILD_ID .
                                docker login -u admin -p sonarqube 34.93.115.30:8083 
                                docker push  34.93.115.30:8083/springapp:$BUILD_ID
                                docker rmi 34.93.115.30:8083/springapp:$BUILD_ID
                            '''
                        }
                    }
                }
            }
        }
       post {
		always {
			mail bcc: '', body: "<br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> URL de build: ${env.BUILD_URL}", cc: '', charset: 'UTF-8', from: '', mimeType: 'text/html', replyTo: '', subject: "${currentBuild.result} CI: Project name -> ${env.JOB_NAME}", to: "mailtomohanse@gmail.com";  
		}
	}
}