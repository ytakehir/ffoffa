# ベースとなるMySQLの公式イメージを指定
FROM mysql:8.1

# 設定ファイルのコピー
COPY ./services/database/mysql/config/my.cnf /etc/mysql/conf.d/my.cnf

# MySQLのデータディレクトリの権限設定
RUN chown -R mysql:mysql /var/lib/mysql

# 初期化SQLファイルのコピー
COPY ./services/database/mysql/seed /docker-entrypoint-initdb.d/

# 実行コマンド
CMD ["mysqld"]

# ポートの開放
EXPOSE 3306
