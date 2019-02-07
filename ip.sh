#!/bin/sh

# Site from script fetches your public IP
GETIPADDR="ifconfig.me"


# This way does not work as I expected, cause pwd fetches the curren path FROM you are running
# the scritp, and eventually could not be run from its own directory
#CWD=$(pwd)
#NOWIPADDR="$CWD/nowipaddr"
#LOG="$CWD/logIP.log"


# Customize here your own paths
NOWIPADDR="/home/wyre/ip-checker/nowipaddr"
LOG="/home/wyre/ip-checker/logIP.log"



if [ -e $NOWIPADDR ] && [ -e $LOG ];
then

    # Main block, here is checking if IP has changed
    # then sends you an email

    if [ "$(cat $NOWIPADDR)" != "$(curl -s $GETIPADDR)" ]
    then
        curl -s $GETIPADDR > $NOWIPADDR
        # Switch here your personal mail to receive sent mail
        echo "IP has changed to -> $(cat $NOWIPADDR)" | mail -s "YemaServer Ip has changed" WyRe12@gmail.com
        {
            date;
            echo "IP has changed to -> $(cat $NOWIPADDR); sending email to WyRe12@gmail.com";
            echo " ";
        } >> $LOG
    fi

    # Debugging part to send mails or log info even
    # when there are no changes

  #  if [ "$(cat $NOWIPADDR)" = "$(curl -s $GETIPADDR)" ]
  #  then
  #      echo "Current IP is -> $(cat $NOWIPADDR)" | mail -s "Testing YemaServ mail Service" WyRe12@gmail.com
  #      {
  #          date;
  #          echo "No IP change. Right now is $(cat $NOWIPADDR)";
  #          echo " ";
  #      } >> $LOG
  #  fi

# If nowipaddr or logIP.log does not exist it will creates needed file
# and it takes this as firs time execution.

else

    if [ -e $LOG ]
    then
        rm $LOG
    fi
    if [ -e $NOWIPADDR ]
    then
        rm $NOWIPADDR
    fi

    touch $LOG
    {
        echo " ";
        echo "##################################";
        echo "Creating Log for script debugging:";
        echo "##################################";
        echo " ";
    } >> $LOG

    touch $NOWIPADDR
    curl -s $GETIPADDR > $NOWIPADDR
    echo "Fetching IP for the first time, IP -> $(cat $NOWIPADDR)" | mail -s "First time execution IP script" WyRe12@gmail.com
    {
        date;
        echo "Fetching IP for the first time, IP -> $(cat $NOWIPADDR); sending email to WyRe12@gmail.com";
        echo " ";
    } >> $LOG
fi
