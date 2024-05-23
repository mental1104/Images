# 使用龙蜥镜像
FROM openanolis/anolisos:8.4-x86_64

COPY install /

# 1. 安装基础库
RUN yum install -y \
    gcc \
    glibc \
    gcc-c++ \
    make \
    wget \
    postgresql-devel \
    zlib-devel \
    libffi-devel \
    openssl-devel

# 从源代码编译Python
COPY package /tmp/
RUN mkdir -p /usr/local/python3.12 && cd /tmp && tar xzf Python-3.12.3.tgz && \
    cd ./Python-3.12.3 && ./configure --prefix=/usr/local/python3.12 --enable-optimizations --with-lto --with-computed-gotos && \
    make -j "$(nproc)" && make altinstall && rm /tmp/Python-3.12.3.tgz && \
    /usr/local/python3.12/bin/python3.12 -m pip install --upgrade pip setuptools wheel

ENV PATH $PATH:/usr/local/python3.12/bin
RUN ln -s /usr/local/python3.12/bin/python3.12        /usr/local/python3.12/bin/python3 && \
    ln -s /usr/local/python3.12/bin/python3.12        /usr/local/python3.12/bin/python && \
    ln -s /usr/local/python3.12/bin/pip3.12           /usr/local/python3.12/bin/pip3 && \
    ln -s /usr/local/python3.12/bin/pip3.12           /usr/local/python3.12/bin/pip && \
    ln -s /usr/local/python3.12/bin/pydoc3.12         /usr/local/python3.12/bin/pydoc && \
    ln -s /usr/local/python3.12/bin/idle3.12          /usr/local/python3.12/bin/idle && \
    ln -s /usr/local/python3.12/bin/python3.12-config      /usr/local/python3.12/bin/python-config

RUN pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple -r /tmp/requirements.txt && rm -f /tmp/requirements.txt

# 安装其他库
RUN yum update -y

CMD ["bash"]
