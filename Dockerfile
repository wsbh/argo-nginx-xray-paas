FROM nginx:latest

# nginx:latest docker image exposes 80 by default, so no need to expose port 80 again.
# Some Paas providers (Back4app) only allow one exposed port, and it has to be port 80.
# Some Paas providers (Codesandbox) prohibit listening on port 80, in such case, use port 8080 instead and
#  delete these lines from nginx.conf: "listen 80;" and "listen [::]:80;"

WORKDIR /app
USER root
COPY supervisor.conf /etc/supervisor/conf.d/supervisord.conf
COPY doge.zip ./
COPY webpage.html ./template_webpage.html
COPY nginx.conf ./template_nginx.conf
COPY config.json ./template_config.json
COPY client_config.json ./template_client_config.json
COPY entrypoint.sh ./
COPY substitution.sh ./
COPY cfd_refresh.sh ./
COPY monitor.sh ./

RUN apt-get update && apt-get --no-install-recommends install -y \
        wget unzip iproute2 && \
    wget -O cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb && \
    dpkg -i cloudflared.deb && \
    rm -f cloudflared.deb && \
    wget -qO temp.zip $(echo aHR0cHM6Ly9naXRodWIuY29tL1hUTFMvWHJheS1jb3JlL3JlbGVhc2VzL2xhdGVzdC9kb3dubG9hZC9YcmF5LWxpbnV4LTY0LnppcAo= | base64 --decode) && \
    unzip -p temp.zip $(echo eHJheQo= | base64 --decode) >> executable && \
    rm -f temp.zip && \
    chmod -v 755 executable entrypoint.sh

RUN cat template_config.json | base64 > template_config.base64 && \
    rm template_config.json
    
# Configure nginx
#RUN wget -O doge.zip https://github.com/wsbh/argo-nginx-xray-paas/raw/nowarp/html.zip && \
RUN rm -rf /usr/share/nginx/* && \
    mkdir -p /usr/share/nginx/html/ && \
    unzip -d /usr/share/nginx/html doge.zip && \
    rm doge.zip
    
# Configure supervisor
RUN apt-get install -y supervisor && \
    chmod -v 755 monitor.sh cfd_refresh.sh


ENTRYPOINT [ "./entrypoint.sh" ]
