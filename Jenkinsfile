node {
    // reference to maven
    // ** NOTE: This 'maven-3.6.1' Maven tool must be configured in the Jenkins Global Configuration.   
//    def mvnHome = tool 'maven-3.6.1'

    // holds reference to docker image
//    def dockerImage
    // ip address of the docker private repository(nexus)
    
  //  def dockerRepoUrl = "localhost:8083"
  //  def dockerImageName = "hello-world-java"
 //   def dockerImageTag = "${dockerRepoUrl}/${dockerImageName}:${env.BUILD_NUMBER}"
    
    stage('Clone Repo') { // for display purposes
      // Get some code from a GitHub repository
      git 'https://github.com/dstar55/docker-hello-world-spring-boot.git'
      // Get the Maven tool.
      // ** NOTE: This 'maven-3.6.1' Maven tool must be configured
      // **       in the global configuration.           
  //    mvnHome = tool 'maven-3.6.1'
    }    
  
    stage('Build Project') {
      // build project via maven
      echo "Welcome to build stage"
      sh "whereis mvn"
      sh "'${mvnHome}/bin/mvn' -Dmaven.test.failure.ignore clean package"
    }

}	
