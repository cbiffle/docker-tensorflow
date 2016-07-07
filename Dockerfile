FROM nvidia/cuda:7.5-cudnn5-devel
MAINTAINER Cliff L. Biffle <code@cliffle.com>

RUN \
  apt-get update && \
  apt-get install -y software-properties-common curl && \
  \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true |\
      debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  echo "deb http://storage.googleapis.com/bazel-apt stable jdk1.8" | \
      tee /etc/apt/sources.list.d/bazel.list && \
  curl https://storage.googleapis.com/bazel-apt/doc/apt-key.pub.gpg | \
      apt-key add - && \
  apt-get update && \
  apt-get install -y --force-yes \
    libcudnn5=5.0.5-1+cuda7.5 \
    && \
  apt-get install -y \
    bazel \
    git \
    libcuda1-352 \
    oracle-java8-installer \
    python-dev \
    python-pip \
    python-numpy \
    swig \
    python-wheel \
    && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

CMD \
  git clone -b r0.9 https://github.com/tensorflow/tensorflow && \
  cd /tensorflow && \
  PYTHON_BIN_PATH=/usr/bin/python \
    TF_NEED_GCP=0 \
    TF_NEED_CUDA=1 \
    GCC_HOST_COMPILER_PATH=/usr/bin/gcc \
    TF_CUDA_VERSION=7.5 \
    CUDA_TOOLKIT_PATH=/usr/local/cuda \
    TF_CUDNN_VERSION=5.0.5 \
    CUDNN_INSTALL_PATH=/usr/lib/x86_64-linux-gnu \
    TF_CUDA_COMPUTE_CAPABILITIES=5.2 \
    ./configure && \
  bazel build -c opt --copt=-mavx2 --config=cuda \
    //tensorflow/tools/pip_package:build_pip_package && \
  bazel-bin/tensorflow/tools/pip_package/build_pip_package \
    /tmp/tensorflow_pkg && \
  bash
