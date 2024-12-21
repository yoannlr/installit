# installit - easy installation of some Debian programs

Current version: Debian 12

Usage

With curl: `curl https://raw.githubusercontent.com/yoannlr/installit/main/<script>.sh | sh`

With wget: `wget -q https://raw.githubusercontent.com/yoannlr/installit/main/<script>.sh -O - | sh`

## Variables

The following environment variables can be used to configure the installation:

- `JAVA_VERSION` with `java.sh`. The default value is `17`.
- `DOCKER_SUBNET_10` with `docker.sh`. When set, the docker daemon will use the 10.10.0.0/16 subnet.
