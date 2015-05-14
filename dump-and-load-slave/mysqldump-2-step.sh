# Slave need to be behind master's dump so we have to stop it before starting
mysql -P<slave-port> -h<slave-host> -e "STOP SLAVE;"

# 'single-transaction' will produce a dump consistent to Master's binlog position from 'master-data'.
# If you're bottleneck by single-threaded 'gzip', consider using 'pigz'
mysqldump -P<master-port> -h<master-host> --compress --routines --triggers --events --single-transaction --master-data --force --databases <db-name1> <...> | gzip > /tmp/master-dump-$(date +%Y%m%d).sql.gz

# Before loading master's dump, we need slave to be synced with dump's binlog position
zcat /tmp/master-dump-$(date +%Y%m%d).sql.gz | grep '^CHANGE MASTER TO' | head -n1 | sed 's/CHANGE MASTER TO/START SLAVE UNTIL/' | mysql -P<slave-port> -h<slave-host>

# Wait for replication to stop (can use MASTER_WAIT_POS)

# If this slave isn't a master as well, you speed up next command by using 'SET SESSION sql_log_bin = 0;' instead of binlog_format = 'STATEMENT'.
(echo "SLAVE STOP; SET FOREIGN_KEY_CHECKS=0; SET SESSION binlog_format = 'STATEMENT';" ; zcat /tmp/master-dump-$(date +%Y%m%d).sql.gz | grep -v '^CHANGE MASTER' ) | mysql -P<slave-port> -h<slave-host> 

mysql -P<slave-port> -h<slave-host> -e "START SLAVE;"

