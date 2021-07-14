
//podTemplate(containers: [containerTemplate(image: 'docker:17.12.0-ce-dind', name: 'docker', privileged: true, ttyEnabled: true)]){
//   podTemplate(containers: [containerTemplate(image: 'maven:3.8.1-jdk-8', name: 'maven', command: 'cat', ttyEnabled: true)]) {
//	podTemplate(containers: [containerTemplate(name: 'kubectl', image: 'lachlanevenson/k8s-kubectl:v1.19.11', command: 'cat', ttyEnabled: true)]){
//		podTemplate(containers: [containerTemplate(name: 'alpine', image: 'twistian/alpine:latest', command: 'cat', ttyEnabled: true)]){
    pipeline {
       agent none 
      stages {
        stage('Get a Maven project') {
           steps {
            git 'https://github.com/bajajamit09/docker-hello-world-spring-boot.git'
             sh 'mvn -Dmaven.test.failure.ignore clean package'
            
          }               


            }
        }
    }
