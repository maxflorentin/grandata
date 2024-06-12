SPARK_VERSION := 3.2.0
SCALA_VERSION := 2.12
DOCKER_IMAGE := bde2020/spark-master:$(SPARK_VERSION)-hadoop3.2
SPARK_MASTER_PORT := 7077
SPARK_WORKER_COUNT := 2
JUPYTER_PORT := 8888

.PHONY: all spark-master spark-workers start-jupyter stop-jupyter clean help

spark: spark-master spark-workers

spark-master:
	docker run -d -p $(SPARK_MASTER_PORT):$(SPARK_MASTER_PORT) \
		-e ENABLE_INIT_DAEMON=false \
		-e INIT_DAEMON_STEP=setup_spark \
		--name spark-master \
		$(DOCKER_IMAGE)

spark-workers:
	for i in $(shell seq 1 $(SPARK_WORKER_COUNT)); do \
		echo "Starting worker $$i"; \
		docker run -d \
			-e ENABLE_INIT_DAEMON=false \
			-e INIT_DAEMON_STEP=setup_spark \
			--name spark-worker-$$i \
			$(DOCKER_IMAGE) ;\
		done

start-jupyter: stop-jupyter
	docker run -d -p $(JUPYTER_PORT):8888 --name jupyter-notebook \
		-v $(PWD)/notebooks:/home/jovyan/work/notebooks \
		-v $(PWD)/output:/home/jovyan/work/output \
		jupyter/pyspark-notebook start-notebook.sh --NotebookApp.token=''

stop-jupyter:
	@docker stop jupyter-notebook >/dev/null 2>&1 || true
	@docker rm jupyter-notebook >/dev/null 2>&1 || true

install-kernel:
	poetry run python -m ipykernel install --user --name=gd

clean: stop-jupyter
	@docker stop spark-master $(shell docker ps -q --filter "name=spark-worker") >/dev/null 2>&1 || true
	@docker rm spark-master $(shell docker ps -aq --filter "name=spark-worker") >/dev/null 2>&1 || true

help:
	@echo "Use: make <target>"
	@echo "Available commands:"
	@echo "  spark          : Start spark master and workers"
	@echo "  spark-master   : Start spark master"
	@echo "  spark-workers  : Start spark workers"
	@echo "  start-jupyter  : Start Jupyter Notebook"
	@echo "  stop-jupyter   : Stop Jupyter Notebook"
	@echo "  clean          : Stop and remove all spark containers"

%:
	@echo "Target '$@' not found."
	@$(MAKE) help
	@exit 1
