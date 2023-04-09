
FROM ubuntu:22.10

LABEL maintainer="Scott Evers"

RUN apt update
RUN apt upgrade
RUN apt install -y npm git curl
RUN apt install -y zip

# ## Install awscli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install


EXPOSE 3000
