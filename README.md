Banner9 Base Image
==================

This is used to build a base image for running Banner XE self-service, but isn't
especially useful by itself.

The resulting image is designed to work as a base image for Banner 9 war files
running in a Docker Swarm cluster. The setup here is designed to be used with
war files built by ESM without any modification to the source code.

Resulting images should be portable across different banner tiers (production,
test, development, etc.)

## Docker Swarm Setup

### Networking

On the Docker Swarm cluster, we create a load balancer network with encryption
enabled. All services that will be accessed over the web should be attached
to this network.

### Reverse Proxy

[Traefik](https://traefik.io/) is used to route requests to specific services.
Be sure to turn on session persistence and set your frontend rules correctly.

The Traefik service should also be connected to the load balancer network. SSL
termination should be done in your Traefik configuration even if you are using
another load balancer for end to end encryption.

### Secrets and Configuration

Docker [secrets](https://docs.docker.com/engine/swarm/secrets/) and
[configs](https://docs.docker.com/engine/swarm/configs/) are used to make an
instance specific container.

Secrets should be setup in your swarm cluster, and config files are typically
deployed as part of versioned controlled stack/compose files.

Secrets will automatically be appended to catalina.properties where the secret
name is the key and the contents are the value.

Configs should be mapped into the running container as appropriate. For
application navigator the docker compose file should end up containing something
like
```yaml
services:
  application_navigator:
    environment:
      CONFIG_FILE: /usr/local/tomcat/conf/upgr.properties
    configs:
      - source: upgr
        target: /usr/local/tomcat/conf/upgr.properties
        mode: 0444
      - source: applicationNavigator_configuration.groovy
        target: /banner_config/applicationNavigator_configuration.groovy
        mode: 0444
      - source: applicationNavigator_configuration.groovy
        target: /usr/local/tomcat/webapps/applicationNavigator/WEB-INF/classes/applicationNavigator_configuration.groovy
        mode: 0444
```
