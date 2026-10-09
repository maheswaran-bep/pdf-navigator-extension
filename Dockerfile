FROM alpine:3.22

RUN apk add --no-cache zip unzip jq

WORKDIR /app

COPY manifest.json popup.html popup.css popup.js ./
COPY images/ ./images/

CMD ["sh", "-c", "mkdir -p /output && zip -r /output/pdf-navigator-extension.zip manifest.json popup.html popup.css popup.js images/ && unzip -t /output/pdf-navigator-extension.zip"]
