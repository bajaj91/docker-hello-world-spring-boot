pipeline {
  agent any 
     environment {
          def regUrl = "k8workshopregistry.azurecr.io"
          def appImage = "hello-world-java";
          def apiImage = "angular-ui"
          def dockerRepo = "angular-ui"
          def latestTag = "latest";
          buildNumber = 'env.BUILD_ID'
          branchName = 'env.BRANCH_NAME'
          def buildTag = "Build-${BUILD_NUMBER}";
          def releaseTag = "qa";
     }
  
    stages {
        stage('Get a Maven project') {
           steps {
            echo "Git Branch Name Is ${env.GIT_BRANCH}"
            echo "Build ID Is ${env.BUILD_ID}"
            echo 'env.GIT_BRANCH'
            //sh "echo ${buildNumber}"
            sh 'printenv'
            sh 'mvn -Dmaven.test.failure.ignore clean package'
            } 
          }
      
 
            stage('Build Docker Image') {
                steps {
                sh """ 
                docker build -t $regUrl/$appImage:$latestTag . 
                docker build -t $regUrl/$apiImage:$latestTag  ${dockerRepo}/
                docker push $regUrl/$appImage:$latestTag
                docker push $regUrl/$apiImage:$latestTag
                """
                    }
            }
	    /*  stage('Vulnerability Scan w/Twistlock') {
		      steps {
                twistlock.scanImage("k8workshopregistry.azurecr.io/hello-world-java:latest")
    }
	      }	      

        
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
        }*/
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

