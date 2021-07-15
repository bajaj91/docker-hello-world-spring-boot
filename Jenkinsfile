
//podTemplate(containers: [containerTemplate(image: 'docker:17.12.0-ce-dind', name: 'docker', privileged: true, ttyEnabled: true)]){
//   podTemplate(containers: [containerTemplate(image: 'maven:3.8.1-jdk-8', name: 'maven', command: 'cat', ttyEnabled: true)]) {
//	podTemplate(containers: [containerTemplate(name: 'kubectl', image: 'lachlanevenson/k8s-kubectl:v1.19.11', command: 'cat', ttyEnabled: true)]){
//		podTemplate(containers: [containerTemplate(name: 'alpine', image: 'twistian/alpine:latest', command: 'cat', ttyEnabled: true)]){


pipeline {
  agent any {
     environment {
          def regUrl = "k8workshopregistry.azurecr.io"
          def appImage = "hello-world-java";
          def apiImage = "angular-ui"
          def latestTag = "latest";
          def buildTag = "Build-${BUILD_NUMBER}";
          def releaseTag = "qa";
     }
  }
    stages {
        stage('Get a Maven project') {
           steps {
            sh 'mvn -Dmaven.test.failure.ignore clean package'
            } 
          }
      
 
            stage('Build Docker Image') {
                steps {
                sh """ 
                docker build -t $regUrl/$appImage:$latestTag . 
                docker build -t $regUrl/$apiImage:$latestTag  UI/ 
                docker push $regUrl/$appImage:$latestTag
                docker push $regUrl/$apiImage:$latestTag
                """
                    }
            }
	    /*  stage('Vulnerability Scan w/Twistlock') {
		      steps {
      twistlock.scanImage("k8workshopregistry.azurecr.io/hello-world-java:latest")
    }
	      }	    */  

        
        stage('Scan') {
            steps {
                // Scan the image
                prismaCloudScanImage ca: '',
                cert: '',
                dockerAddress: 'unix:///var/run/docker.sock',
                image: 'k8workshopregistry.azurecr.io/hello-world-java:latest',
                key: '',
                logLevel: 'info',
                podmanPath: '',
                project: '',
                resultsFile: 'prisma-cloud-scan-results.json',
                ignoreImageBuildTime:true
            }
        }
             stage('Deploy image'){
		          steps {
                      sh """
        		      kubectl apply -f ./spring-boot-deployment.yaml
		              kubectl apply -f ./spring-angular-ui.yaml
		              kubectl get pods
                      """
		              }
	   	 }

        }
    }

