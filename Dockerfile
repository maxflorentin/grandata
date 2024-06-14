FROM openjdk:8-jdk

RUN apt-get update && apt-get install -y scala python3-pip

RUN pip3 install jupyter duckdb

RUN curl -o /tmp/spark-2.3.4-bin-hadoop2.7.tgz \
  https://archive.apache.org/dist/spark/spark-2.3.4/spark-2.3.4-bin-hadoop2.7.tgz && \
  tar zxvf /tmp/spark-2.3.4-bin-hadoop2.7.tgz -C /opt && \
  ln -s /opt/spark-2.3.4-bin-hadoop2.7 /opt/spark

ENV SPARK_HOME=/opt/spark
ENV PATH=$SPARK_HOME/bin:$PATH

RUN mkdir -p /home/jovyan/work/notebooks

WORKDIR /home/jovyan/work

EXPOSE 8888

CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--no-browser", "--allow-root", "--NotebookApp.token=''"]
