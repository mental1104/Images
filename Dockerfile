# 使用官方的Python3镜像作为基础镜像
FROM ubuntu:20.04

# 安装NumPy、SciPy、pysam和setuptools

RUN apt-get update && apt-get install -y python3 pip libncurses5-dev libbz2-dev liblzma-dev
RUN python3 --version
RUN apt-get install -y 2to3
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
RUN pip install numpy scipy pysam setuptools matplotlib

WORKDIR /app
COPY . .

RUN 2to3 -w -n ./rmats2sashimiplot/src
RUN cd ./rmats2sashimiplot && python3 setup.py install

RUN cd ./samtools-1.19.2 && sh ./configure && make
RUN cd ./samtools-1.19.2 && mv samtools /usr/local/bin
# 将本地文件复制到镜像中（如果有其他的Python脚本或依赖项）
# COPY . /app

# 设置容器启动时执行的命令（可根据需要修改）
CMD ["bash"]
