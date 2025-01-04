FROM python:3.8-alpine
WORKDIR /app
COPY app.pyc .
RUN pip3 install --no-cache-dir flask &&  apk add --no-cache curl && rm -rf /root/.cache/
EXPOSE 80
CMD ["flask", "run", "host=0.0.0.0", "port=80"]