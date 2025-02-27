FROM ubuntu:24.04

RUN apt update \
    && apt install nginx -y && \
    apt install git -y && \
    rm -rf /var/lib/apt/lists/*

    RUN git clone https://github.com/josejuansanchez/2048.git /app \
    && cp -R /app/* /usr/share/nginx/html/

    EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]