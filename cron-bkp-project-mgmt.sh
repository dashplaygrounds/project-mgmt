#!/bin/bash
export BKPDIR=q4-2023-projectmgmt-backups
export PREFIX1=featmap-backup
export PREFIX2=openproject-backup
export PREFIX3=redmine-backup
export WINBKPDIR=C:/Users/sfeadmin/OneDrive/DATA-CABINET-Q4-2023/2023-Q4-PROJECT-MGMT-BACKUPS/
cd ~/${BKPDIR}
ls -lrt
export TIMESTAMP=$(date +%m%d%Y_%H%M%S)
echo $TIMESTAMP > timestamp.txt
cat timestamp.txt
# env vars
export WHOST="192.168.1.176"
export WPORT="22"
export OUTDIR=pm_$TIMESTAMP
export FILE=$OUTDIR.zip


docker ps

# dbs: featmap,openproject,redmine
export PGPASSWORD=project
mkdir -p ~/$BKPDIR/pm_$TIMESTAMP
cd ~/$BKPDIR
docker exec pmdb pg_dump featmap -U manager -F c > ~/$BKPDIR/pm_$TIMESTAMP/$PREFIX1.dump
sleep 5
docker exec pmdb pg_dump openproject -U manager -F c > ~/$BKPDIR/pm_$TIMESTAMP/$PREFIX2.dump
sleep 5
docker exec pmdb pg_dump redmine -U manager -F c > ~/$BKPDIR/pm_$TIMESTAMP/$PREFIX3.dump

du -sh $OUTDIR

sleep 5
# Zipping dump directory
if [ ! -d "$OUTDIR" ]; then
  echo "$OUTDIR does not exist."
else
  zip -r $FILE ./$OUTDIR
fi

ls -lrt $OUTDIR

# Wait for the crond service to trigger on specified times - every 12 hours
# crontab -e
# Remember to 'ssh-pass' to windows sfeadmin@192.168.1.190
# Sync is thru scp to Onedrive Win10 on Proxmox LAN
sshpass -p "789456" \
    scp -P $WPORT $FILE \
 sfeadmin@$WHOST:${WINBKPDIR}
# scp is successful
# But require manual RDP to sign-in to onedrive .190
# and upload the new backup automatically
# Notice the correct double quotes
echo "Last ${OUTDIR}: $(date)\n" >>~/${BKPDIR}/backup-timelogs.txt