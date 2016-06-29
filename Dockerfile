FROM nvidia/cuda:7.5-cudnn5-devel
MAINTAINER Cliff L. Biffle <code@cliffle.com>

RUN apt-get update && apt-get install -y \
  libcuda1-352 \
  python-pip \
  python-dev \
  python-matplotlib \
  && rm -rf /var/lib/apt/lists/*

COPY tensorflow-0.9.0-cp27-none-linux_x86_64.whl /tmp
RUN pip install /tmp/tensorflow-0.9.0-cp27-none-linux_x86_64.whl
RUN pip install jupyter

EXPOSE 8888
CMD jupyter notebook --notebook-dir=/notebooks --no-browser --ip=0.0.0.0
