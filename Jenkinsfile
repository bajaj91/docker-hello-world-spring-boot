
//podTemplate(containers: [containerTemplate(image: 'docker:17.12.0-ce-dind', name: 'docker', privileged: true, ttyEnabled: true)]){
//   podTemplate(containers: [containerTemplate(image: 'maven:3.8.1-jdk-8', name: 'maven', command: 'cat', ttyEnabled: true)]) {
//	podTemplate(containers: [containerTemplate(name: 'kubectl', image: 'lachlanevenson/k8s-kubectl:v1.19.11', command: 'cat', ttyEnabled: true)]){
//		podTemplate(containers: [containerTemplate(name: 'alpine', image: 'twistian/alpine:latest', command: 'cat', ttyEnabled: true)]){
    pipeline {
       agent any 
      stages {
        stage('Get a Maven project') {
           steps {
             sh 'mvn -Dmaven.test.failure.ignore clean package'
            
          } 
        } 
            stage('Build Docker Image') {
                steps {
                sh """ 
                docker build -t k8workshopregistry.azurecr.io/hello-world-java . 
                docker build -t k8workshopregistry.azurecr.io/angular-ui UI/ 
                docker push k8workshopregistry.azurecr.io/hello-world-java
                docker push k8workshopregistry.azurecr.io/angular-ui
                """
                    }
            }
             stage('Deploy image'){
                      sh """
        		      kubectl apply -f ./spring-boot-deployment.yaml
		              kubectl apply -f ./spring-angular-ui.yaml
		              kubectl get pods
                      """
		              }
	   	 }

        }
     }
}
