FROM alpine:latest
LABEL maintainer="Scott Evers"

RUN apk update

## Terraform Setup
## Note: credentials.tfrc.json must be mounted from the host OS
RUN apk add terraform
RUN export TF_WORKSPACE=pipeline-dashboard-backend-dev

## NodeJS Setup
RUN apk add npm
RUN npm i -g nodemon
EXPOSE 3000

## Git setup
RUN apk add git

## Miscellaneous tools
RUN apk add curl fish
