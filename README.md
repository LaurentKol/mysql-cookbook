# mysql-cookbook

## Replication: dump and load slave
All these dump and load recipes keep database(s) consistent replication-wise, and support MariaDB multi-source replication with if slave commands prefixed by: `SET @@default_master_connection ="<conn-name>";`
 - [Mysqldump one-liner dump and load] (dump-and-load-slave/mysqldump-oneliner.sh)
 - [Mysqldump 2 step dump and load] (dump-and-load-slave/mysqldump-2-step.sh)
 - [File-level copy dump and load] (dump-and-load-slave/file-copy-read-lock.sh)
 
## TODO
Rewrite recipe as bash script with trap to catch error and email exit status
