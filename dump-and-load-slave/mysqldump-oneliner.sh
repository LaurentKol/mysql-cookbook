# Dump and Load one or multiple small tables from the master while keeping database consistent replication-wise.
# Requires direct network connectivity
mysqldump -P<master-port> -h<master-host> --master-data <db-name> <tbl-name1> <...> | \
  sed 's#CHANGE MASTER TO MASTER_LOG_FILE=\([^:]*\),\s*MASTER_LOG_POS=\([0-9]*\);#\
  START SLAVE UNTIL MASTER_LOG_FILE=\1, MASTER_LOG_POS=\2;\
  SELECT MASTER_POS_WAIT(\1,\2); STOP SLAVE;#' | \
  mysql -P<slave-port> -h<slave-host> --show-warnings <db-name>

# Resume replication
mysql -P<slave-port> -h<slave-host> -e 'START SLAVE'

