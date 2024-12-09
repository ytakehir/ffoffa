# mysql用Dockerfile

# Dockerイメージの指定
FROM mysql:8.1

# 設定ファイルのコピー
COPY ./services/database/mysql/config/my.cnf /etc/mysql/conf.d/my.cnf

# 実行コマンド
CMD ["mysqld"]

# ポートの開放
EXPOSE 3306