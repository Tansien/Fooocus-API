FROM pytorch/pytorch:2.1.0-cuda12.1-cudnn8-runtime AS build

ENV TZ=Europe/Stockholm \
    DEBIAN_FRONTEND=noninteractive

WORKDIR /app

# Install git only at build time; strip cache
RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    rm -rf /var/lib/apt/lists/*

# Copy Fooocus and API project
COPY . /app

# Install Python dependencies without pip cache
RUN pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir opencv-python-headless -i https://pypi.org/simple

# Make sure Fooocus-API can create/delete folders
RUN chmod -R 777 /app/

EXPOSE 8888

CMD ["python", "main.py", "--host", "0.0.0.0", "--port", "8888", "--skip-pip"]