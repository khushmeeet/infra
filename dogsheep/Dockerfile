FROM python:latest

ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-c"]

RUN apt-get -y update && apt-get -y upgrade

RUN pip3 install datasette
RUN datasette install datasette-dashboards
RUN datasette install datasette-chatgpt-plugin
RUN datasette install datasette-simple-html
RUN pip install py-gfm
RUN pip install datasette-render-markdown
RUN datasette install datasette-youtube-embed
RUN datasette install datasette-geojson
RUN pip install datasette-copyable
RUN datasette install datasette-configure-fts
RUN pip install datasette-search-all
RUN datasette install datasette-nteract-data-explorer
RUN pip install datasette-pretty-json
RUN datasette install datasette-mp3-audio
RUN datasette install datasette-redirect-to-https
RUN datasette install datasette-geojson-map
RUN datasette install datasette-cluster-map
RUN datasette install dogsheep-beta
RUN pip install datasette-vega

EXPOSE 8001

CMD ["datasette", "serve", "--host", "0.0.0.0", "--port", "8001", "/mnt/dbs", "-m", "/mnt/metadata/metadata.yml"]
