FROM ubuntu:latest

RUN apt-get update && apt-get install -y wget

# anacondaの導入
RUN wget https://repo.anaconda.com/archive/Anaconda3-2022.05-Linux-x86_64.sh && \
  sh Anaconda3-2022.05-Linux-x86_64.sh -b -p /opt/anaconda3 && \
  rm -f Anaconda3-2022.05-Linux-x86_64.sh
ENV PATH /opt/anaconda3/bin:$PATH

# mecabの導入
RUN apt-get -y update && \
  apt-get -y upgrade && \
  apt-get install -y mecab && \
  apt-get install -y libmecab-dev && \
  apt-get install -y mecab-ipadic-utf8 && \
  apt-get install -y git && \
  apt-get install -y make && \
  apt-get install -y curl && \
  apt-get install -y xz-utils && \
  apt-get install -y file && \
  apt-get install -y sudo

# mecab-ipadic-NEologdのインストール
RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git && \
  cd mecab-ipadic-neologd && \
  ./bin/install-mecab-ipadic-neologd -n -y && \
  echo dicdir = `mecab-config --dicdir`"/mecab-ipadic-neologd">/etc/mecabrc && \
  sudo cp /etc/mecabrc /usr/local/etc && \
  cd

RUN conda update -n base -c defaults conda

RUN mkdir workdir
WORKDIR /workdir
COPY ./ /workdir

ENV TZ Asia/Tokyo
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8

RUN pip install --upgrade pip --no-cache-dir && \
  pip install -r requirements.txt --no-cache-dir
