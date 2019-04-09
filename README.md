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
3) Access application using linke http://localhost:8080/sample , it works. Stop you local tomcat sever.
4) Created a <b> dockerfile </b> to convert Sample.war into a docker image. 
* Base image is selcted as tomcat 8 version so that application could be deployed on tomcat 
* Copied Sample.war into the webapps folder of the tomcat
* Started tomcat as CMD along with the deployment of the image
5) execute below command to build the docker image from the location of docker file
		`docker build -t sample .` 
6) Created <b> sample-k8s.yml </b> for the deployment of the created docker image.
* The yml file contains two parts, Kind : Deployment set to deploy the image and Kind : service to expose the application for other pods within the cluster.
7) Execute the below command for deployment of Deployment and Service,
         `kubectl apply -f sample-k8s.yml` 
Response should be 
deployment.apps "sample-app" created
service "sampleservice" created
8) Execute below command to get the list of deployed pods, it can take some time before pods are up and running depending on readiness probe.
          `kubectl get pods`
Output should be 
NAME                          READY     STATUS    RESTARTS   AGE
sample-app-789f8c5bb7-7c6dw   1/1       Running   0          36s

9) To test the application from local browser, execute the below command,and keep the console open
          `kubectl port-forward <pod-name> 8080:8080` example in this case:- kubectl port-forward sample-app-789f8c5bb7-7c6dw 8080:8080
10) Now trigger the url again from browser, it should work.
11) Also check the status of the service, with below command, service should be succesfully deployed. Service is exposed with name as "sampleservice".
          `kubectl get services`
12)To test the service from another pod in the same cluster, create a test image which supports curl command.
           `docker build -t test-image test-image/`
13)Deploy the test-image using below command, 
           `kubectl apply -f sample-test.yml` 
14)Test test-image pod should be up and running, `kubectl get pods`
15)To test, we need to ssh into test-image pod, use below command,
         `kubectl exec -it test-image sh`
16)Execute the curl command from within the test-image pod, we should get the successful response, which means we are able to reach the application from another pod on port 8080 via HTTP
         `curl http://sampleservice:8080/sample`
    
## Part 2

Our application is now ready for production and should be usable by the world. Deploy an ingress into the environment and let people access our service via port 8080.
   
## Solution

Using ingress, we should be able to access the service using localhost from the brower, without the need of kubectl port-forward as mentioned in step 7) above. 
To deploy ingress resource, I have created sample-ingress.yml, but Kubernetes doesn't support inbuild Ingress controller, hence we need to deploy an ingress controller such as nginx, Istio and others.

### Steps Executed to prepare the solution

1) Deploy nginx ingress controller on kubernetes on docker for windows, execute below commands 
             `kubectl apply -f nginx-mandatory-resources.yml`
             `kubectl apply -f nginx-service.yml`
2) Check the output, `kubectl get pods --all-namespaces`, you should be able to find the pod ingress-nginx
3) Deploy the ingress, `kubectl apply -f sample-ingress.yml`
4) Check the ingress, `kubectl get ingress` Output should be like, with no value in the ADDRESS Column. It takes ingress-controller some time to provision the address for the service.
NAME             HOSTS     ADDRESS   PORTS     AGE
sample-ingress   *                   80        15s
5) After couple of tries you should be able to see the output as,
NAME             HOSTS     ADDRESS   PORTS     AGE
sample-ingress   *         localhost 80        2m
6) Try to access the service, from browser, http://localhost:8080/sample it should work.


## Part 3

The world loves our app but its a little unstable and occasionally crashes under heavy load. What can you do to make the system more robust? Include code which implements your solution.
   
## Solution


To respond to heavy load, we should be able to auto scale the number of deployed pods, and in case if required we should also be able to auto scale number of nodes in the Kubernetes Cluster. For this, Kubernetes provides which two two autoscalers, which works in combination with each other. 
Horizontal Auto Scaler :- To scale number of Pods based on metrics
Cluster Auto Scaler :- To scale number of nodes in Kubernetes Cluster, which works with all the cloud provides.

Since we are using Kuberntes on docker for windows, I have only create Horizontal Auto scaler refer to file sample-app-autoscaler.yml

### Steps Executed to prepare the solution

1) Execute the below command to Horizontal Auto scaler.
       `kubectl apply -f sample-app-autoscaler.yml`
2) Check the output, `kubectl get hpa` , it should be created.
3) Create another pod to generate the load to the sample application pod, within this container I have added an infinite while loop to trigger the application.
       `kubectl apply -f sample-load-generator.yml`
4) To validate the utilization percentage, HPA check for the metrics. Since Kubernetes doesn't supports metrics api by default, Heapster needs to be deployed to make Autoscaling work, but i have not deployed the same.
       


            


		


