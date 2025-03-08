# 5.4 2048 Alejandro Martinez Uceda
## En esta práctica vamos a crear un docker con el juego 2048 y subirlo a nuestro perfil de docker hub
### Para ello tenemos que crear primero un docker file que contenga el servicio de nginx:
~~~
FROM ubuntu:24.04

RUN apt update \
    && apt install nginx -y && \
    apt install git -y && \
    rm -rf /var/lib/apt/lists/*

    RUN git clone https://github.com/josejuansanchez/2048.git /app \
    && cp -R /app/* /usr/share/nginx/html/

    EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
~~~

### Iniciaremos sesion en Docker Hub y crearemos un token en el apartado de personal token en ajustes y dentro del repositorio lo añadiremos como secretos el token con nombre "DOCKERHUN_TOKEN" y el usuario "DOCKERHUB_USERNAME" 
![](images/Captura%20de%20pantalla%202025-03-04%20212155.png)

### Una vez hecho eso se nos dirigimos a actions y en new workflow clickamos en "set up a workflow yourself" y pegamos este codigo.
~~~
name: Publish image to Docker Hub

# This workflow uses actions that are not certified by GitHub.
# They are provided by a third-party and are governed by
# separate terms of service, privacy policy, and support
# documentation.

on:
  push:
    branches: [ "main" ]
    # Publish semver tags as releases.
    tags: [ 'v*.*.*' ]
  workflow_dispatch:

env:
  # Use docker.io for Docker Hub if empty
  REGISTRY: docker.io
  # github.repository as <account>/<repo>
  #IMAGE_NAME: ${{ github.repository }}
  IMAGE_NAME: ${{ secrets.DOCKERHUB_USERNAME }}/2048
  IMAGE_TAG: latest

jobs:
  build:

    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write

    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      # Set up BuildKit Docker container builder to be able to build
      # multi-platform images and export cache
      # https://github.com/docker/setup-buildx-action
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@f95db51fddba0c2d1ec667646a06c2ce06100226 # v3.0.0

      # Login against a Docker registry except on PR
      # https://github.com/docker/login-action
      - name: Log into registry ${{ env.REGISTRY }}
        uses: docker/login-action@343f7c4344506bcbf9b4de18042ae17996df046d # v3.0.0
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      # This action can be used to check the content of the variables
      - name: Debug
        run: |
          echo "github.repository: ${{ github.repository }}"
          echo "env.REGISTRY: ${{ env.REGISTRY }}"
          echo "github.sha: ${{ github.sha }}"
          echo "env.IMAGE_NAME: ${{ env.IMAGE_NAME }}"

      # Build and push Docker image with Buildx (don't push on PR)
      # https://github.com/docker/build-push-action
      - name: Build and push Docker image
        id: build-and-push
        uses: docker/build-push-action@0565240e2d4ab88bba5387d719585280857ece09 # v5.0.0
        with:
          context: .
          push: ${{ github.event_name != 'pull_request' }}
          tags: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ env.IMAGE_TAG }}
          cache-from: type=gha
          cache-to: type=gha,mode=max

~~~
### Una vez hecho se nos ejecutara un comprobador de que el docker esta todo en orden y al salir todo OK ya lo tendriamos subido a nuestro docker hub.

![](images/Captura%20de%20pantalla%202025-03-04%20125117.png)
![](images/5.4.PNG)
![](images/5.4.2.PNG)