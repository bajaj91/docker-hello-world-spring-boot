
podTemplate(containers: [containerTemplate(image: 'docker:17.12.0-ce-dind', name: 'docker', privileged: true, ttyEnabled: true)]){
   podTemplate(containers: [containerTemplate(image: 'maven:3.8.1-jdk-8', name: 'maven', command: 'cat', ttyEnabled: true)]) {
     agent {
     node {

        stage('Get a Maven project') {
            sh "kubectl cluster-info"
            git 'https://github.com/bajaj91/docker-hello-world-spring-boot'
            container('maven') {

                stage('Build a Maven project') {
               //   sh 'mvn -B -ntp clean install'
                    sh 'mvn -Dmaven.test.failure.ignore clean package'
                    sh 'pwd && ls -l'
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
	      // build docker image
           //   sh "service start docker & service status docker"
	    //  sh "whoami & cat /etc/issue & touch /var/run/docker.sock"
               
	      // sh "ls -all /var/run/docker.sock"
             sh "pwd & ls -l  &  ls -l ./target/"
	      //sh "sudo mv ./target/hello*.jar ./data"
              
           //   sh "kubectl  cluster-info"
              sh "docker build -t k8workshopregistry.azurecr.io/hello-world-java . "
              sh "docker login -u k8workshopregistry k8workshopregistry.azurecr.io -p RnQA8Y+AMxdNBT3jbNLINocGdCMGVd5R"
              sh "docker push k8workshopregistry.azurecr.io/hello-world-java"
               
//	      dockerImage = docker.build("hello-world-java")
		    }
	}

            }
        }
    }
}
}
