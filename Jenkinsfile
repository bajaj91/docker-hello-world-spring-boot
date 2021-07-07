
podTemplate(containers: [containerTemplate(image: 'docker', name: 'docker', command: 'cat', ttyEnabled: true)]){
   podTemplate(containers: [containerTemplate(image: 'maven:3.8.1-jdk-8', name: 'maven', command: 'cat', ttyEnabled: true)]) {
     node(POD_LABEL) {

        stage('Get a Maven project') {
            sh "find / -iname 'docker*' "
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
             //  sh "docker version"
	      sh "whoami & cat /etc/issue & touch /var/run/docker.sock"
               
	      // sh "ls -all /var/run/docker.sock"
             sh "pwd & ls -l  &  ls -l ./target/"
	      //sh "sudo mv ./target/hello*.jar ./data"
              
           //   sh "kubectl  cluster-info"
              sh "docker build -t hello-world-java . "
//	      dockerImage = docker.build("hello-world-java")
		    }
	}

            }
        }
    }
}
