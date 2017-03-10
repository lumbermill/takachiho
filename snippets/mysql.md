# MySQL
```
CREATE TABLE t (
id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
v VARCHAR(255) NOT NULL DEFAULT '',
modified_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
UNIQUE KEY (v)
FOREIGN KEY v REFERENCES tt(v)
)ENGINE=InnoDB, CHARACTER SET=utf8;
```


## GRANT
```
GRANT SELECT ON db.* TO 'user'@'%';
GRANT ALL ON db.* TO 'user'@'%' IDENTIFIED BY 'pass';
GRANT REPLICATION SLAVE ON *.* TO 'user'@'host' IDENTIFIED BY 'pass';
```

```
SELECT host,db,user FROM mysql.db;
SELECT DISTINCT user FROM mysql.user;
SHOW GRANTS FOR user;
```

## Index
```
create index idx_name on table (col1,col2);
```

# Load and save
```
LOAD DATA INFILE '/tmp/t.csv' REPLACE INTO TABLE t IGNORE 1 LINES;
```

```
SELECT * INTO OUTFILE '/tmp/t.csv' FROM t;
```

# Export table list to csv.
```bash
filename="db.tsv"
db="db_name"
user="user"
result=`mysql -u$user $db -N -s -e 'SHOW TABLES;'`
printf "" > $filename

table_c=0
record_c=0
for line in $result; do
  result=`mysql -u$user $db -N -s -e "SELECT COUNT(*) FROM $line"`
  echo -e "$line\t$result" >> $filename
  table_c=$((table_c+1))
  record_c=$((record_c+$result))
done
echo "Table total: $table_c" >> $filename
echo "Record total: $record_c" >> $filename
```
