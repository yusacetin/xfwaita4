BASE_DARK="${HOME}/.themes/Xfwaita4-dark"
if [ -d ${BASE_DARK} ]
then
    echo "Uninstalling dark theme"
    rm -rf ${BASE_DARK}
fi


BASE_LIGHT="${HOME}/.themes/Xfwaita4-light"
if [ -d ${BASE_LIGHT} ]
then
    echo "Uninstalling light theme"
    rm -rf ${BASE_LIGHT}
fi
