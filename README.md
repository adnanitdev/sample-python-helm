# Directory Structure

I have followed sub-chart structure which has a parent chart and the dependencies are configured in python-app/Chart.yaml.  

All the values for dependencies can be configured from python-app/values for ease of use.

python-app service is exposed through Loadbalancer.  

Python-app connects to postgres database and will return current time.  

sample-python-helm/  
  ├─ python-app/  
  │  ├─ charts/  
  │  │  ├─ postgres/  
  │  │  │  ├─ charts/  
  │  │  │  ├─ templates/  
  │  │  │  │  ├─ postgres-deployment.yaml  
  │  │  │  │  ├─ postgres-pvc.yaml  
  │  │  │  │  ├─ postgres-secret.yaml  
  │  │  │  │  └─ postgres-service.yaml  
  │  │  │  ├─ .helmignore  
  │  │  │  ├─ Chart.yaml  
  │  │  │  └─ values.yaml  
  │  │  └─ python-app/  
  │  │     ├─ charts/  
  │  │     ├─ templates/  
  │  │     │  ├─ sample-app-deployment.yaml  
  │  │     │  └─ sample-app-service.yaml  
  │  │     ├─ .helmignore  
  │  │     ├─ Chart.yaml  
  │  │     └─ values.yaml  
  │  ├─ sample-python-app/  
  │  │  ├─ app.py  
  │  │  └─ Dockerfile  
  │  ├─ templates/  
  │  ├─ .helmignore  
  │  ├─ Chart.yaml  
  │  └─ values.yaml  
  ├─ install.sh  
  └─ README.md  

Just run `install.sh` script and you should be able to install the application and at the end, script will show the URLs to test the application through LoadBalancer.  

Example:

Accessing the load balancer through the URL: `curl http://192.x.x.x:3xxxx` will fetch the welcome message from python application.

Accessing the load balancer with `/data` endpoint will connect the python application to postgres database to fetch time: `curl http://192.x.x.x:3xxxx/data`

The script is also integrated to build minikube cluster if it does not exist and installs helm if does not exist.

All the pods are deployed on to default namespace.
