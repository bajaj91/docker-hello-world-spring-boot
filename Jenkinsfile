podTemplate(containers: [
    containerTemplate(name: 'maven', image: 'maven:3.8.1-jdk-8', command: 'sleep', args: '99d')
    //containerTemplate(name: 'maven', image: 'docker.io/openshift/jenkins-2-centos7:latest', command: 'sleep', args: '99d')
  ]) {

    node(POD_LABEL) {
        stage('Get a Maven project') {
            git 'https://github.com/bajaj91/docker-hello-world-spring-boot'
            container('maven') {
                stage('Build a Maven project') {
               //     sh 'mvn -B -ntp clean install'
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
                stage('Build Docker Image') {
	      // build docker image
	      sh "whoami"
	    //  sh "ls -all /var/run/docker.sock"
             sh "ls -l ./target/"
	      sh "mv ./target/hello*.jar ./data"
           //   sh "kubectl  cluster-info"
              sh "whereis docker"

	      dockerImage = docker.build("hello-world-java")
	    }


            }
        }

    }
}
