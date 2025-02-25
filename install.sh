ROOTDIR="${HOME}/.themes"

main() {
    if [ $# == 0 ]
    then
        echo "Installing all variants"
        echo "Installing dark theme"
        set_dark
        install
        echo "Installing light theme"
        set_light
        install
    elif [ $1 == "dark" ]
    then
        echo "Installing dark theme"
        set_dark
        install
    elif [ $1 == "light" ]
    then
        echo "Installing light theme"
        set_light
        install
    else
        echo "Error: invalid variant: $1"
        echo "Valid variants are 'dark' and 'light'"
    fi
}

set_dark() {
    THEME_NAME="Xfwaita4-dark"
    BUILD_PATH="build/${THEME_NAME}"
}

set_light() {
    THEME_NAME="Xfwaita4-light"
    BUILD_PATH="build/${THEME_NAME}"
}

install() {
    if [ -d ${ROOTDIR}/${THEME_NAME} ]; then rm ${ROOTDIR}/${THEME_NAME}/xfwm4/*; rmdir ${ROOTDIR}/${THEME_NAME}/xfwm4; rmdir ${ROOTDIR}/${THEME_NAME}; fi;
    if [ ! -d ${ROOTDIR} ]; then mkdir -p ${ROOTDIR}; fi;
    cp -r ${BUILD_PATH} ${ROOTDIR}
}

main $1
