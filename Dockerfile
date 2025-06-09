FROM python:3.9-slim

WORKDIR /app

RUN apt-get update && apt-get install -y curl unzip jq && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

ARG AWS_DEFAULT_REGION=us-west-2
ENV AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION

RUN PRODIGY_KEY=$(AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION aws secretsmanager get-secret-value --secret-id prodigy/key --query SecretString --output text | jq -r '.["prodigy-license-key"]') && \
    pip install --no-cache-dir prodigy -f https://$PRODIGY_KEY@download.prodi.gy && \
    pip install --no-cache-dir -r requirements.txt && \
    python -m spacy download en_core_web_sm

COPY app/ ./app/
COPY config/ ./config/

ENV PYTHONPATH=/app
ENV PORT=8080
ENV PRODIGY_HOST=0.0.0.0
ENV PRODIGY_PORT=8080

EXPOSE 8080

CMD ["python", "-m", "prodigy", "textcat.manual", "my_dataset", "-", "--label", "POSITIVE,NEGATIVE"]