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
        
        /* stage('identifying mis-configurations in helm charts using datree plugin'){
            steps{
                script{

                    withEnv(['DATREE_TOKEN=g5CTVRHaY99hka6adEkxfo']){
                            sh 'helm datree test kubernetes/myapp/'
                    }
            }
        }
    } */

            stage("Pushing the helm charts to nexus"){
            steps{
                script{
                    withCredentials([string(credentialsId: 'docker_nexus_pass', variable: 'docker_nexus_passwd')]) {
                            dir('kubernetes/') {
                             sh '''
                                 helmversion=$( helm show chart myapp | grep version | cut -d: -f 2 | tr -d ' ')
                                 tar -czvf  myapp-${helmversion}.tgz myapp/
                                 curl -u admin:$docker_nexus_passwd http://34.93.115.30:8081/repository/hosting-helm/ --upload-file myapp-${helmversion}.tgz -v
                            '''
                          } 
                        }
                    }
                }
            }
	    
	    
	  stage('manual approval'){
            steps{
                script{
                    timeout(10) {
                        mail bcc: '', body: "<br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> Go to build url and approve the deployment request <br> URL de build: ${env.BUILD_URL}", cc: '', charset: 'UTF-8', from: '', mimeType: 'text/html', replyTo: '', subject: "${currentBuild.result} CI: Project name -> ${env.JOB_NAME}", to: "mailtomohanse@gmail.com";  
                        input(id: "", message: "Deploy ${params.project_name}?", ok: 'Deploy')
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
