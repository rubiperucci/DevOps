docker pull postgres

docker pull sonarqube

docker pull jenkins/jenkins

docker pull sonatype/nexus3

docker pull mongo

docker run -p 8080:8080 --name=jenkins -d jenkins/jenkins

docker run -d -p 8081:8081 --name nexus sonatype/nexus3

mkdir ~/mongo_data

docker run -d --name mongodb -v ~/mongo_data:/data/db mongo

docker volume create mongo_data

docker run -d --name db --mount src=mongo_data,dst=/data/db mongo

docker network create --attachable atnet

docker network connect atnet jenkins

mkdir ~/postgresql && mkdir ~/postgresql_data

docker run -d --name sonardb \
--network atnet --restart always \
-e POSTGRES_USER=sonar -e POSTGRES_PASSWORD=sonar \
-v ~/postgresql:/var/lib/postgresql
-v ~/postgresql_data:/var/lib/postgresql/data \
postgres

docker volume create sonarqube_data

docker volume create sonarqube_extensions

docker volume create sonarqube_logs

docker run -d --name sonarqube \
--network atnet -p 9000:9000 \
-e SONARQUBE_JDBC_URL=jdbc:postgresql://sonardb:5432/sonar \
-e SONAR_JDBC_USERNAME=sonar \
-e SONAR_JDBC_PASSWORD=sonar \
-v sonarqube_data:/opt/sonarqube/data \
-v sonarqube_extensions:/opt/sonarqube/extensions \
-v sonarqube_logs:/opt/sonarqube/logs \
sonarqube