#!/bin/bash

### BEGIN INIT INFO
# Short-Description: Mount dei filesystem oradbfs
# chkconfig: 2345 79 21
### END INIT INFO

if [ -r /lib/lsb/init-functions ]; then
    . /lib/lsb/init-functions
else
    exit 1
fi

NAME="oracle_dbfs"
FSTAB="/etc/sysconfig/${NAME}.mounts"

# Get instance specific config file
if [ -r "/etc/sysconfig/${NAME}" ]; then
    . /etc/sysconfig/${NAME}
fi

oradbfs_mount() {
  ORA_DBFS_CONNSTRING="$1"
  ORA_DBFS_MOUNT="$2"
  ORA_DBFS_OPTS=$(echo $3|sed -e 's/,/ -o /g' -e 's/^/-o /g')

  echo -n "Mounting oradbfs: ${ORA_DBFS_CONNSTRING} on ${ORA_DBFS_MOUNT} ..."

  df -k | grep -q "${ORA_DBFS_MOUNT}"
  rc=$?
  if [ $rc -eq 0 ]; then
    log_success_msg "already mounted."
    return $rc
  fi

  chown "${ORA_DBUSER}" "${ORA_DBFS_MOUNT}"
  su - $ORA_DBUSER -c "[ -r \"/etc/sysconfig/${NAME}\" ] || exit 1; \
    . \"/etc/sysconfig/${NAME}\"; \
    \"${ORA_DBFS_PROG}\" ${ORA_DBFS_OPTS} ${ORA_DBFS_CONNSTRING} ${ORA_DBFS_MOUNT}"

  for i in {1..20}; do
    df -k | grep -q "${ORA_DBFS_MOUNT}"

    rc=$?
    if [ $rc -ne 0 ]; then
      sleep 1
    else
      break
    fi
  done

  if [ $rc -ne 0 ]; then
    log_failure_msg "failed."
    return $rc
  fi

  CONN=`cat /proc/mounts | grep "${ORA_DBFS_MOUNT}" | awk '{print $1}'`

  log_success_msg "mounted!"
  return 0
}

oradbfs_start() {
  for line in "$(cat $FSTAB|grep -v -e ^#)"; do
    arr=($line)
    ORA_DBFS_CONNSTRING=${arr[0]}
    ORA_DBFS_MOUNT=${arr[1]}
    ORA_DBFS_OPTS=${arr[2]}

    oradbfs_mount "${ORA_DBFS_CONNSTRING}" "${ORA_DBFS_MOUNT}" "${ORA_DBFS_OPTS}"
  done
}

oradbfs_stop() {
  for line in "$(cat $FSTAB|grep -v -e ^#)"; do
    arr=($line)
    ORA_DBFS_CONNSTRING="${arr[0]}"
    ORA_DBFS_MOUNT="${arr[1]}"
    ORA_DBFS_OPTS="${arr[2]}"

    oradbfs_umount "${ORA_DBFS_MOUNT}"
  done
}

oradbfs_umount() {
  ORA_DBFS_MOUNT="$1"
  echo -n  "Unmounting oradbfs: \"${ORA_DBFS_MOUNT}\""

  df -k | grep -q "${ORA_DBFS_MOUNT}"
  rc=$?
  if [ $rc -ne 0 ]; then
    log_success_msg "not mounted."
    return 0
  fi

  su - $ORA_DBUSER -c "fusermount -u \"${ORA_DBFS_MOUNT}\""
  df -k | grep -q "${ORA_DBFS_MOUNT}"

  rc=$?
  if [ $rc -eq 0 ]; then
    log_failure_msg "failed."
    return 1
  fi

  log_success_msg "unmounted."
  return 0

}

oradbfs_status() {
  for line in "$(cat $FSTAB|grep -v -e ^#)"; do
    arr=($line)
    ORA_DBFS_CONNSTRING="${arr[0]}"
    ORA_DBFS_MOUNT="${arr[1]}"
    ORA_DBFS_OPTS="${arr[2]}"

    oradbfs_fs_status "${ORA_DBFS_MOUNT}"
  done
}

oradbfs_fs_status() {
  ORA_DBFS_MOUNT="$1"

  echo -n "Status oradbfs: \"${ORA_DBFS_MOUNT}\""
  df -k | grep -q "${ORA_DBFS_MOUNT}"
  rc=$?
  if [ $rc -eq 0 ]; then
    CONN=`cat /proc/mounts | grep "${ORA_DBFS_MOUNT}" | awk '{print $1}'`
    CLIENT_PID=`ps -ef | grep dbfs_client | grep -v grep | awk '{print $2}'`
    log_success_msg "\"${CONN}\" mounted on \"${ORA_DBFS_MOUNT}\" - Client PID: ${CLIENT_PID}"
  else
    log_failure_msg "unmounted."
  fi
  return $rc
}

case "$1" in
start)
  oradbfs_start;
;;
stop)
  oradbfs_stop;
;;
status)
  oradbfs_status;
;;
restart)
  oradbfs_stop;
  oradbfs_start;
;;
*)
  echo "Usage: oradbfs {start|stop|status}"
  exit 1
esac

