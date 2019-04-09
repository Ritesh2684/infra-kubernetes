# Kubernetes Assignment

## Part 1

We would like to deploy our Java application to K8s, it needs to run in Tomcat 8 and should be available for other pods in the cluster to use (via HTTP) after deployment.

### Environment
Docker Desktop Kubernetes for Windows

## Solution

As a solution to part 1, I have created, 
* dockerfile to convert sample.war into a docker image
* kubernetes script sample-k8s.yml to deploy the application into local Kubernetes Cluster
* test-image to test the component from other pods inside the cluster as a service via HTTP.

### Steps Executed to prepare the solution

1) Downloaded the Sample.war from the given link and placed in the webapps folder of tomcat. 
2) Start tomcat on local system
3) Access application using linke http://localhost:8080/sample , it works.
4) Created a <b> dockerfile </b> to convert Sample.war into a docker image. 
		* Base image is selcted as tomcat 8 version so that application could be deployed on tomcat 
		* Copied Sample.war into the webapps folder of the tomcat
		* Started tomcat as CMD along with the deployment of the image
5) execute below command to build the docker image from the location of docker file
		`docker build -t sample .` 
5) Created <b> sample-k8s.yml </b> for the deployment of the created docker image.
		


