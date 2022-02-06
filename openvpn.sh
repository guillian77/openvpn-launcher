#!/bin/sh
sourcePath=$(dirname $([ -L $0 ] && readlink $0 || echo $0))
config="config.ovpn"
password="pass.txt"
cd $sourcePath

header()
{
  echo "----------------------------------------"
  echo "$1"
  echo "----------------------------------------"
}

getStatus()
{
  header "OpenVPN status:"
  if pgrep -x "openvpn" >/dev/null
  then
    echo "Running"
  else
    echo "Not running"
  fi
}

start()
{
  header "Check configuration file."
  if [ ! -f $config ]
  then
    echo "OpenVPN configuration file note found: $config"
    exit
  fi
  echo "OK"

  header "Check password file."
  if [ ! -f $password ]
  then
    echo "OpenVPN password file note found: $password"
    exit
  fi
  echo "OK"

  if [ "$2" = "-it" ]; then
    echo "OpenVPN run as interactive mode."
    sudo openvpn --config $config --auth-user-pass $password
  else
    header "Start open OpenVPN connection."
    sudo openvpn --config $config --auth-user-pass $password --daemon
    echo "OpenVPN run as service."
  fi
}

stop()
{
  header "Start open OpenVPN connection."
  pgrep openvpn | xargs sudo kill -9
}

case $@ in
  status)
    getStatus
    ;;
  start*)
    start $@
    ;;
  stop)
    stop
    ;;
  *)
    echo "start|stop|status"
esac
exit 0