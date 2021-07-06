podTemplate(containers: [
    containerTemplate(name: 'maven', image: 'maven:3.8.1-jdk-8', command: 'sleep', args: '99d')
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


            }
        }

    }
}
