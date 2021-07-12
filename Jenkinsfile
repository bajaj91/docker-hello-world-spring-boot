
podTemplate(containers: [containerTemplate(image: 'docker:17.12.0-ce-dind', name: 'docker', privileged: true, ttyEnabled: true)]){
   podTemplate(containers: [containerTemplate(image: 'maven:3.8.1-jdk-8', name: 'maven', command: 'cat', ttyEnabled: true)]) {
	podTemplate(containers: [containerTemplate(name: 'helm', image: 'lachlanevenson/k8s-kubectl:v1.19.11', command: 'cat', ttyEnabled: true)]){
     node (POD_LABEL) {
        stage('Get a Maven project') {
            git 'https://github.com/bajaj91/docker-hello-world-spring-boot'
            container('maven') {

                stage('Build a Maven project') {
               //   sh 'mvn -B -ntp clean install'
                    sh 'mvn -Dmaven.test.failure.ignore clean package'
                }

                stage('Publish Tests Results'){
	         parallel(
        	  publishJunitTestsResultsToJenkins: {
	          echo "Publish junit Tests Results"
                  junit '**/target/surefire-reports/TEST-*.xml'
                  archive 'target/*.jar'
        	},
	        publishJunitTestsResultsToSonar: {
        	  echo "This is branch b"
		      })
	    }
          }
               container('docker') {

                stage('Build Docker Image') {
                sh "docker build -t k8workshopregistry.azurecr.io/hello-world-java . "
                sh "ls -l && cd UI && ls -l"
                sh "docker login -u k8workshopregistry k8workshopregistry.azurecr.io -p RnQA8Y+AMxdNBT3jbNLINocGdCMGVd5R"
                sh "docker push k8workshopregistry.azurecr.io/hello-world-java"
//	      dockerImage = docker.build("hello-world-java")
		    }
	}
 	                

              container('helm'){
              stage('Deploy image'){
              sh "kubectl apply -f ./spring-boot-deployment.yaml"
              sh "kubectl get pods"
              }
	    }

            }
        }
    }
}
}
