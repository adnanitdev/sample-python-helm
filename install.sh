#!/bin/bash

# Function to prompt the user for installation
prompt_install_minikube() {
    read -p "Minikube could not be found. Do you want to install Minikube? (yes/no): " response
    case "$response" in
        [yY][eE][sS]|[yY])
            echo "Installing Minikube..."
            curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
            chmod +x minikube
            sudo mv minikube /usr/local/bin/
            ;;
        *)
            echo "Minikube installation aborted. Exiting script."
            exit 1
            ;;
    esac
}

# Check if Minikube is installed
echo "Checking if Minikube is installed..."
if ! command -v minikube &> /dev/null
then
    prompt_install_minikube
fi

# Check if Minikube cluster is already running
if minikube status | grep -q "host: Running"
then
    echo "Minikube cluster is already running."
else
    echo "Starting Minikube..."
    sleep 10
    minikube start --force
fi

# Check if Helm is installed, if not install it
echo "Checking if Helm is installed..."
if ! command -v helm &> /dev/null
then
    echo "Helm could not be found. Installing..."
    curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

# Deploy the Helm chart
echo "Installing the python-sample Helm chart..."
helm install python-sample ./python-app

# Wait for the service to be available
echo "Waiting for the python-app service to be available..."
sleep 10
while ! kubectl get svc python-app &> /dev/null; do
    echo "Waiting..."
    sleep 5
done
echo "The python-app service is now available."


# Define color codes
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Get the Minikube IP
LOADBALANCER_URL=$(minikube service python-app --url)

# Output the IP and ports for the services
echo -e "${GREEN}Access the load balancer through the URL(PYTHON APPLICATION): curl $LOADBALANCER_URL${NC}"
echo -e "${GREEN}Access the load balancer URL to test if the app can access the database to fetch time(PYTHON APPLICATION): curl $LOADBALANCER_URL/data${NC}"
echo -e "${GREEN}Wait for all the pods to be up before accessing the services${NC}"

