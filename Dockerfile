# 使用官方的 Python 镜像作为基础镜像
FROM python:3.12

# 设置工作目录
WORKDIR /app

# 复制 requirements.txt 文件
COPY requirements.txt .

# 安装 Python 依赖并设置时区
RUN apt-get update && apt-get install -y tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apt install -y iputils-ping \
    && pip install --upgrade pip \
    && pip install -r requirements.txt -i https://pypi.mirrors.ustc.edu.cn/simple \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 复制项目的其余内容
COPY . /app

# 设置环境变量
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# 暴露应用程序运行的端口
EXPOSE 8000

# 启动 FastAPI 应用程序
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]