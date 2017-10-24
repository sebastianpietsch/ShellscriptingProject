#!/bin/bash
#######################
# Backup Script to Backup
# Owncloud config, DB and data
#####################

#was wird gebackupt?
backup_files="/var/www/owncloud/config /var/www/owncloud/data /backup/sqldumptmp"

#wohin?
destTag="/backup/daily"
destWoche="/backup/weekly"
destMonat="/backup/monthly"
destJahr="/back/annual"

#Archivname erzeugen
day=$(date +%A)
weeknr=$(date +%V)
month=$(date +%b)
year=$(date +%Y)

archivTag="oc-backup-$day.tgz"
archivWoche="oc-backup-$weeknr.tgz"
archivMonat="oc-backup-$month.tgz"
archivJahr="oc-backup-$year.tgz"

#Startmessage
echo "Backup gestartet"

# Datenbank Backup
echo "Datenbank wird gesichert..."
mysqldump --single-transaction -u cim -pPass4Cim: > backup$(date +%Y-%m-%d).sql
mv backup$(date +%Y-%m-%d).sql /backup/sqldumptmp/backup$(date +%Y-%m-%d).sql
echo "Datenbank gesichert!"

######
#backup mit tar
######

echo "Daten werden gesichert"

date1=$(date +%d+%m)
date2=$(date +%d)
date3=$(date +%u)

if [[ "$date1" = "30+12" ]]
then
  tar czf $destJahr/$archivJahr $backup_files;
elif [[ "$date2" = "01" ]]
then
  tar czf $destMonat/$archivMonat $backup_files;
elif  [[ $date3 -gt 6 ]]
then
    tar czf $destWoche/$archivWoche $backup_files;
else
    tar czf $destTag/$archivTag $backup_files;
fi

rm /backup/sqldumptmp/*

echo "Daten gesichert!"
#Endmessage

echo "Backup fertig!"

#long list vom Backup Ordner um Dateingröße zu checken
if [[ "$date1" = "30+12" ]]
then
  ls -lh $destJahr;
elif [[ "$date2" = "01" ]]
then
  ls -lh $destMonat;
elif  [[ $date3 -gt 6 ]]
then
    ls -lh $destWoche;
else
    ls -lh $destTag;
fi
