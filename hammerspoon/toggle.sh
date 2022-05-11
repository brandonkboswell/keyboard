res=$(osascript -e "tell application \"System Events\" to get name of application processes whose frontmost is true and visible is true");

echo $res

if [[ ( $res == "$1" ) || ($res == "$2") ]]
then
  osascript -e "tell application \"System Events\" to set visible of process \"$1\" to false"
else
  open -a "$1.app"
fi