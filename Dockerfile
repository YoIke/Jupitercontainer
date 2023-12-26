# python:3.10のbullseyeベースイメージを使用
FROM python:3.10-slim-bullseye

# 必要なツールのインストール
RUN apt-get update && apt-get install -y wget unzip curl git

# Pythonとpipのセットアップ
RUN pip install --upgrade pip && \
    pip install jupyter jupyterlab pydrive jupyterlab-git

# JupyterLabの日本語パックをインストール
RUN pip install jupyterlab-language-pack-ja-JP

# Java 17のインストール
RUN apt-get install -y software-properties-common && \
    echo 'deb http://security.debian.org/debian-security bullseye-security main' >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y openjdk-17-jdk

# PostgreSQLのクライアントツールのインストール
RUN apt-get install -y libpq-dev

# IJavaのインストール
RUN wget https://github.com/SpencerPark/IJava/releases/download/v1.3.0/ijava-1.3.0.zip && \
    unzip ijava-1.3.0.zip && \
    python install.py --sys-prefix

# 必要なPythonライブラリのインストール
RUN pip install pandas sqlalchemy psycopg2-binary

# JupyterLabの作業ディレクトリを設定
WORKDIR /data

# themes.jupyterlab-settingsとplugin.jupyterlab-settingsの設定ファイルを追加
COPY themes.jupyterlab-settings /root/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/
COPY plugin.jupyterlab-settings /root/.jupyter/lab/user-settings/@jupyterlab/translation-extension/

# JupyterLabの起動用のコマンドを設定
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--no-browser", "--allow-root"]
