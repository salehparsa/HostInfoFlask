# Define variables for directories
KUBECTL = kubectl
PROMETHEUS_DIR = k8s/prometheus
GRAFANA_DIR = k8s/grafana
APP_DIR = k8s/app
APP_NAMESPACE = host-info-flask-namespace

# Define file paths
PROMETHEUS_YAML = $(PROMETHEUS_DIR)/deployment.yaml
PROMETHEUS_SERVICE_YAML = $(PROMETHEUS_DIR)/service.yaml
PROMETHEUS_CONFIGMAP_YAML = $(PROMETHEUS_DIR)/configmap.yaml
GRAFANA_YAML = $(GRAFANA_DIR)/deployment.yaml
GRAFANA_SERVICE_YAML = $(GRAFANA_DIR)/service.yaml
GRAFANA_INGRESS_YAML = $(GRAFANA_DIR)/ingress.yaml
APP_YAML = $(APP_DIR)/deployment.yaml
APP_SERVICE_YAML = $(APP_DIR)/service.yaml
APP_INGRESS_YAML = $(APP_DIR)/ingress.yaml

# Targets

.PHONY: all deploy-prometheus deploy-grafana deploy-app deploy-all clean-prometheus clean-grafana clean-app clean-all

# Deploy all components
all: deploy-all

# Deploy Prometheus components
deploy-prometheus:
	@echo "Deploying Prometheus components..."
	$(KUBECTL) apply -f $(PROMETHEUS_CONFIGMAP_YAML)
	$(KUBECTL) apply -f $(PROMETHEUS_YAML)
	$(KUBECTL) apply -f $(PROMETHEUS_SERVICE_YAML)

# Deploy Grafana components
deploy-grafana:
	@echo "Deploying Grafana components..."
	$(KUBECTL) apply -f $(GRAFANA_YAML)
	$(KUBECTL) apply -f $(GRAFANA_SERVICE_YAML)
	$(KUBECTL) apply -f $(GRAFANA_INGRESS_YAML)

# Deploy application components
deploy-app:
	@echo "Deploying application components..."
	$(KUBECTL) -n $(APP_NAMESPACE) apply -f $(APP_YAML)
	$(KUBECTL) -n $(APP_NAMESPACE) apply -f $(APP_SERVICE_YAML)
	$(KUBECTL) -n $(APP_NAMESPACE) apply -f $(APP_INGRESS_YAML)

# Deploy all components
deploy-all: deploy-prometheus deploy-grafana deploy-app

# Clean Prometheus components
clean-prometheus:
	@echo "Cleaning up Prometheus components..."
	$(KUBECTL) delete -f $(PROMETHEUS_YAML) || true
	$(KUBECTL) delete -f $(PROMETHEUS_SERVICE_YAML) || true
	$(KUBECTL) delete -f $(PROMETHEUS_CONFIGMAP_YAML) || true

# Clean Grafana components
clean-grafana:
	@echo "Cleaning up Grafana components..."
	$(KUBECTL) delete -f $(GRAFANA_YAML) || true
	$(KUBECTL) delete -f $(GRAFANA_SERVICE_YAML) || true
	$(KUBECTL) delete -f $(GRAFANA_INGRESS_YAML) || true

# Clean application components
clean-app:
	@echo "Cleaning up application components..."
	$(KUBECTL) -n $(APP_NAMESPACE) delete -f $(APP_YAML) || true
	$(KUBECTL) -n $(APP_NAMESPACE)  delete -f $(APP_SERVICE_YAML) || true
	$(KUBECTL) -n $(APP_NAMESPACE) delete -f $(APP_INGRESS_YAML) || true

# Clean all components
clean-all: clean-prometheus clean-grafana clean-app