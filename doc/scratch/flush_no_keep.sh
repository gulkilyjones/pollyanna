#!/bin/bash

echo script is disabled until further refinemenet
exit;

# Adds all non-essential and non-#keep items to archived.log
# This results in their archiving on next pass

mydate=`date +%s`
#save current date

sqlite3 -cmd ".headers off" -cmd ".timeout 500" cache/*/index.sqlite3 "
  SELECT file_hash
  FROM item_flat
  WHERE file_hash NOT IN (
    SELECT file_hash FROM item_flat
    WHERE
      ','||labels_list||',' LIKE '%,keep,%' OR
      ','||labels_list||',' LIKE '%,puzzle,%' OR
      ','||labels_list||',' LIKE '%,admin,%' OR
      ','||labels_list||',' LIKE '%,pubkey,%'
    UNION
    SELECT item_hash AS file_hash FROM item_parent
    WHERE parent_hash IN (
      SELECT file_hash FROM item_flat
      WHERE
        ','||labels_list||',' LIKE '%,keep,%' OR
        ','||labels_list||',' LIKE '%,puzzle,%' OR
        ','||labels_list||',' LIKE '%,admin,%' OR
        ','||labels_list||',' LIKE '%,pubkey,%'
    )
    UNION
    SELECT item_hash AS file_hash FROM item_parent
    WHERE parent_hash IN (
      SELECT file_hash FROM item_flat
      WHERE parent_hash IN (
        SELECT file_hash FROM item_flat
        WHERE
          ','||labels_list||',' LIKE '%,keep,%' OR
          ','||labels_list||',' LIKE '%,puzzle,%' OR
          ','||labels_list||',' LIKE '%,admin,%' OR
          ','||labels_list||',' LIKE '%,pubkey,%'
      )
    )
  )
" > log/archived.log.$mydate
# make list of things to archive

cat log/archived.log.$mydate > log/archived.log
# write list to archived.log file
# yes, we want to overwrite the file.

echo $mydate
# announce date

cat log/archived.log.$mydate > log/archived.log
echo "\n\nItems were added to archive queue" >> log/archived.log.$mydate
# append explanation to list of files we saved

cp log/archived.log.$mydate html/txt/log_archived.log.$mydate.txt
# post the list of files

./index.pl ./html/txt/log_archived.log.$mydate.txt
























