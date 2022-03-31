### Exercise Content



## 1. Create an automation that will deploy AWS infrastructure that will include the following items: 

* VPC with 
  * Internet Gateway 
  * Internet access

* 4 Subnets
  * 2 public - internet access via the Internet Gateway
  * 2 private - internet access via NAT Gateway

* anything that is not mentioned is at your full discretion
* Any automation framework.
* Regions
* CIDR ranges
* tags .



 ## 2. Deploying a simple “Hello World” container on an ECS cluster

### You should deploy it with: 

* Service Autoscaling 
  * 2 running tasks (containers)
* Application Load Balancer
  * Internet access
* Tasks (Containers) - On private subnets 
* The application load balancer (ALB) should be exposed the application to the Internet.



## 3. Create a CD pipeline

* Automatically be rolling new changes update on the "Hello World" application



## 4. Create a CD pipeline

* Use CodeBuild and CodePipeline 
* Connect to the source code repository 
* Push the changes to a new container deployment (docker image) on ECS


## Do's and Don'ts

- [x] Use any service and any resource in AWS that you find helpful to achieve your goals.
- [x] Do use Google or any knowledge publicly available to achieve your goals.

- [] Do'nt use friend's help to achieve goals.

- [] Don't use scripts that were created by others.