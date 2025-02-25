# Constants
BUILD_ROOT="./build"
TEMP_PATH="./temp"
GEN_PATH="./gen"

HMAR_BUTTON_FG=11
VMAR_BUTTON_FG=14
VMAR_BUTTON_FG_INACTIVE=${VMAR_BUTTON_FG}

HMAR_BUTTON_BG=4
VMAR_BUTTON_BG=7

main() {
    python generate_borders.py

    if [ $# -eq 0 ]
    then
        echo "Building all variants"
        echo "Building dark theme"
        build_dark
        echo "Building light theme"
        build_light
    elif [ $1 == "dark" ]
    then
        echo "Building dark theme"
        build_dark
    elif [ $1 == "light" ]
    then
        echo "Building light theme"
        build_light
    else
        echo "Error: invalid variant: $1"
        echo "Valid variants are 'dark' and 'light'"
    fi
}

build_dark() {
    VARIANT="dark"
    build
}

build_light() {
    VARIANT="light"
    build
}

set_path_variables() {
    BUILD_PATH="${BUILD_ROOT}/Xfwaita4-${VARIANT}/xfwm4"
    THEMERC_SRC="src/${VARIANT}_themerc"

    ACTIVE_TITLE_SRC="src/${VARIANT}_active_title.png"
    ACTIVE_BUTTON_DEFAULT_BG_SRC="src/${VARIANT}_active_button_default_bg.png"
    ACTIVE_CLOSE_SRC="src/${VARIANT}_active_button_close_fg.png"
    ACTIVE_MAXIMIZE_SRC="src/${VARIANT}_active_button_maximize_fg.png"
    ACTIVE_MINIMIZE_SRC="src/${VARIANT}_active_button_minimize_fg.png"
    ACTIVE_UNMAXIMIZE_SRC="src/${VARIANT}_active_button_unmaximize_fg.png"
    ACTIVE_TOPRIGHT_SRC="src/${VARIANT}_active_topright.png"
    ACTIVE_BUTTON_HOVER_BG_SRC="src/${VARIANT}_active_button_hover_bg.png"
    ACTIVE_BUTTON_PRESSED_BG_SRC="src/${VARIANT}_active_button_pressed_bg.png"
    
    INACTIVE_TITLE_SRC="src/${VARIANT}_inactive_title.png"
    INACTIVE_BUTTON_DEFAULT_BG_SRC="src/${VARIANT}_inactive_button_default_bg.png"
    INACTIVE_CLOSE_SRC="src/${VARIANT}_inactive_button_close_fg.png"
    INACTIVE_MAXIMIZE_SRC="src/${VARIANT}_inactive_button_maximize_fg.png"
    INACTIVE_MINIMIZE_SRC="src/${VARIANT}_inactive_button_minimize_fg.png"
    INACTIVE_UNMAXIMIZE_SRC="src/${VARIANT}_inactive_button_unmaximize_fg.png"
    INACTIVE_TOPRIGHT_SRC="src/${VARIANT}_inactive_topright.png"
}

build() {
    # Set path variables
    set_path_variables

    # Clear build directories
    if [ -d ${BUILD_PATH} ]; then rm -rf ${BUILD_PATH}; fi;
    if [ -d ${TEMP_PATH} ]; then rm -rf ${TEMP_PATH}; fi;
    mkdir -p ${BUILD_PATH}
    mkdir -p ${TEMP_PATH}

    # Copy themerc
    cp ${THEMERC_SRC} ${BUILD_PATH}/themerc

    # Copy active background
    cp ${ACTIVE_TITLE_SRC} "${TEMP_PATH}/title-active.png"

    # Copy inactive background
    cp ${INACTIVE_TITLE_SRC} "${TEMP_PATH}/title-inactive.png"

    # Create active buttons
    magick ${ACTIVE_TITLE_SRC} \
    ${ACTIVE_BUTTON_DEFAULT_BG_SRC} -geometry +${HMAR_BUTTON_BG}+${VMAR_BUTTON_BG} -composite \
    ${ACTIVE_CLOSE_SRC} -geometry +${HMAR_BUTTON_FG}+${VMAR_BUTTON_FG} -composite \
    ${TEMP_PATH}/close-active.png

    magick ${ACTIVE_TITLE_SRC} \
    ${ACTIVE_BUTTON_DEFAULT_BG_SRC} -geometry +${HMAR_BUTTON_BG}+${VMAR_BUTTON_BG} -composite \
    ${ACTIVE_MAXIMIZE_SRC} -geometry +${HMAR_BUTTON_FG}+${VMAR_BUTTON_FG} -composite \
    ${TEMP_PATH}/maximize-active.png

    magick ${ACTIVE_TITLE_SRC} \
    ${ACTIVE_BUTTON_DEFAULT_BG_SRC} -geometry +${HMAR_BUTTON_BG}+${VMAR_BUTTON_BG} -composite \
    ${ACTIVE_MINIMIZE_SRC} -geometry +${HMAR_BUTTON_FG}+${VMAR_BUTTON_FG} -composite \
    ${TEMP_PATH}/hide-active.png

    magick ${ACTIVE_TITLE_SRC} \
    ${ACTIVE_BUTTON_DEFAULT_BG_SRC} -geometry +${HMAR_BUTTON_BG}+${VMAR_BUTTON_BG} -composite \
    ${ACTIVE_UNMAXIMIZE_SRC} -geometry +${HMAR_BUTTON_FG}+${VMAR_BUTTON_FG} -composite \
    ${TEMP_PATH}/maximize-toggled-active.png


    # Create inactive buttons
    magick ${INACTIVE_TITLE_SRC} \
    ${INACTIVE_BUTTON_DEFAULT_BG_SRC} -geometry +${HMAR_BUTTON_BG}+${VMAR_BUTTON_BG} -composite \
    ${INACTIVE_CLOSE_SRC} -geometry +${HMAR_BUTTON_FG}+${VMAR_BUTTON_FG_INACTIVE} -composite \
    ${TEMP_PATH}/close-inactive.png

    magick ${INACTIVE_TITLE_SRC} \
    ${INACTIVE_BUTTON_DEFAULT_BG_SRC} -geometry +${HMAR_BUTTON_BG}+${VMAR_BUTTON_BG} -composite \
    ${INACTIVE_MAXIMIZE_SRC} -geometry +${HMAR_BUTTON_FG}+${VMAR_BUTTON_FG_INACTIVE} -composite \
    ${TEMP_PATH}/maximize-inactive.png

    magick ${INACTIVE_TITLE_SRC} \
    ${INACTIVE_BUTTON_DEFAULT_BG_SRC} -geometry +${HMAR_BUTTON_BG}+${VMAR_BUTTON_BG} -composite \
    ${INACTIVE_MINIMIZE_SRC} -geometry +${HMAR_BUTTON_FG}+${VMAR_BUTTON_FG_INACTIVE} -composite \
    ${TEMP_PATH}/hide-inactive.png

    magick ${INACTIVE_TITLE_SRC} \
    ${INACTIVE_BUTTON_DEFAULT_BG_SRC} -geometry +${HMAR_BUTTON_BG}+${VMAR_BUTTON_BG} -composite \
    ${INACTIVE_UNMAXIMIZE_SRC} -geometry +${HMAR_BUTTON_FG}+${VMAR_BUTTON_FG_INACTIVE} -composite \
    ${TEMP_PATH}/maximize-toggled-inactive.png

    # Create hover buttons
    magick ${ACTIVE_TITLE_SRC} \
    ${ACTIVE_BUTTON_HOVER_BG_SRC} -geometry +${HMAR_BUTTON_BG}+${VMAR_BUTTON_BG} -composite \
    ${ACTIVE_CLOSE_SRC} -geometry +${HMAR_BUTTON_FG}+${VMAR_BUTTON_FG} -composite \
    ${TEMP_PATH}/close-prelight.png

    magick ${ACTIVE_TITLE_SRC} \
    ${ACTIVE_BUTTON_HOVER_BG_SRC} -geometry +${HMAR_BUTTON_BG}+${VMAR_BUTTON_BG} -composite \
    ${ACTIVE_MAXIMIZE_SRC} -geometry +${HMAR_BUTTON_FG}+${VMAR_BUTTON_FG} -composite \
    ${TEMP_PATH}/maximize-prelight.png

    magick ${ACTIVE_TITLE_SRC} \
    ${ACTIVE_BUTTON_HOVER_BG_SRC} -geometry +${HMAR_BUTTON_BG}+${VMAR_BUTTON_BG} -composite \
    ${ACTIVE_MINIMIZE_SRC} -geometry +${HMAR_BUTTON_FG}+${VMAR_BUTTON_FG} -composite \
    ${TEMP_PATH}/hide-prelight.png

    magick ${ACTIVE_TITLE_SRC} \
    ${ACTIVE_BUTTON_HOVER_BG_SRC} -geometry +${HMAR_BUTTON_BG}+${VMAR_BUTTON_BG} -composite \
    ${ACTIVE_UNMAXIMIZE_SRC} -geometry +${HMAR_BUTTON_FG}+${VMAR_BUTTON_FG} -composite \
    ${TEMP_PATH}/maximize-toggled-prelight.png

    # Create pressed buttons
    magick ${ACTIVE_TITLE_SRC} \
    ${ACTIVE_BUTTON_PRESSED_BG_SRC} -geometry +${HMAR_BUTTON_BG}+${VMAR_BUTTON_BG} -composite \
    ${ACTIVE_CLOSE_SRC} -geometry +${HMAR_BUTTON_FG}+${VMAR_BUTTON_FG} -composite \
    ${TEMP_PATH}/close-pressed.png

    magick ${ACTIVE_TITLE_SRC} \
    ${ACTIVE_BUTTON_PRESSED_BG_SRC} -geometry +${HMAR_BUTTON_BG}+${VMAR_BUTTON_BG} -composite \
    ${ACTIVE_MAXIMIZE_SRC} -geometry +${HMAR_BUTTON_FG}+${VMAR_BUTTON_FG} -composite \
    ${TEMP_PATH}/maximize-pressed.png

    magick ${ACTIVE_TITLE_SRC} \
    ${ACTIVE_BUTTON_PRESSED_BG_SRC} -geometry +${HMAR_BUTTON_BG}+${VMAR_BUTTON_BG} -composite \
    ${ACTIVE_MINIMIZE_SRC} -geometry +${HMAR_BUTTON_FG}+${VMAR_BUTTON_FG} -composite \
    ${TEMP_PATH}/hide-pressed.png

    magick ${ACTIVE_TITLE_SRC} \
    ${ACTIVE_BUTTON_PRESSED_BG_SRC} -geometry +${HMAR_BUTTON_BG}+${VMAR_BUTTON_BG} -composite \
    ${ACTIVE_UNMAXIMIZE_SRC} -geometry +${HMAR_BUTTON_FG}+${VMAR_BUTTON_FG} -composite \
    ${TEMP_PATH}/maximize-toggled-pressed.png

    # Top right corner
    cp ${ACTIVE_TOPRIGHT_SRC} ${TEMP_PATH}/top-right-active.png
    cp ${INACTIVE_TOPRIGHT_SRC} ${TEMP_PATH}/top-right-inactive.png

    # Top left corner
    magick -define png:color-type=6 ${ACTIVE_TOPRIGHT_SRC} -flop ${TEMP_PATH}/top-left-active.png
    magick -define png:color-type=6 ${INACTIVE_TOPRIGHT_SRC} -flop ${TEMP_PATH}/top-left-inactive.png

    # Bottom window border
    cp ${GEN_PATH}/${VARIANT}_active_bottom.png ${TEMP_PATH}/bottom-active.png
    cp ${GEN_PATH}/${VARIANT}_inactive_bottom.png ${TEMP_PATH}/bottom-inactive.png

    # Right window border
    cp ${GEN_PATH}/${VARIANT}_active_right.png ${TEMP_PATH}/right-active.png
    cp ${GEN_PATH}/${VARIANT}_inactive_right.png ${TEMP_PATH}/right-inactive.png

    # Left window border
    cp ${GEN_PATH}/${VARIANT}_active_left.png ${TEMP_PATH}/left-active.png
    cp ${GEN_PATH}/${VARIANT}_inactive_left.png ${TEMP_PATH}/left-inactive.png

    # Bottom right window border
    cp ${GEN_PATH}/${VARIANT}_active_bottom_right.png ${TEMP_PATH}/bottom-right-active.png
    cp ${GEN_PATH}/${VARIANT}_inactive_bottom_right.png ${TEMP_PATH}/bottom-right-inactive.png

    # Bottom left window border
    cp ${GEN_PATH}/${VARIANT}_active_bottom_left.png ${TEMP_PATH}/bottom-left-active.png
    cp ${GEN_PATH}/${VARIANT}_inactive_bottom_left.png ${TEMP_PATH}/bottom-left-inactive.png

    # Transparent buttons
    cp src/transparent.png ${TEMP_PATH}/transparent.png

    # Convert to xpm
    for fpath in ${TEMP_PATH}/*.png; do
        iname=${fpath##*/}
        oname=$(echo ${iname} | sed 's/.png/.xpm/')
        python img2xpm.py ${TEMP_PATH}/${iname} ${BUILD_PATH}/${oname}
    done

    # Rename titles
    cp ${BUILD_PATH}/title-active.xpm ${BUILD_PATH}/title-1-active.xpm
    cp ${BUILD_PATH}/title-active.xpm ${BUILD_PATH}/title-2-active.xpm
    cp ${BUILD_PATH}/title-active.xpm ${BUILD_PATH}/title-3-active.xpm
    cp ${BUILD_PATH}/title-active.xpm ${BUILD_PATH}/title-4-active.xpm
    mv ${BUILD_PATH}/title-active.xpm ${BUILD_PATH}/title-5-active.xpm # move the last one because the name is generic

    cp ${BUILD_PATH}/title-inactive.xpm ${BUILD_PATH}/title-1-inactive.xpm
    cp ${BUILD_PATH}/title-inactive.xpm ${BUILD_PATH}/title-2-inactive.xpm
    cp ${BUILD_PATH}/title-inactive.xpm ${BUILD_PATH}/title-3-inactive.xpm
    cp ${BUILD_PATH}/title-inactive.xpm ${BUILD_PATH}/title-4-inactive.xpm
    mv ${BUILD_PATH}/title-inactive.xpm ${BUILD_PATH}/title-5-inactive.xpm

    # Copy transparent title buttons (for window title centering)
    cp ${BUILD_PATH}/transparent.xpm ${BUILD_PATH}/shade-active.xpm
    cp ${BUILD_PATH}/transparent.xpm ${BUILD_PATH}/shade-inactive.xpm
    cp ${BUILD_PATH}/transparent.xpm ${BUILD_PATH}/shade-prelight.xpm
    cp ${BUILD_PATH}/transparent.xpm ${BUILD_PATH}/shade-pressed.xpm
    cp ${BUILD_PATH}/transparent.xpm ${BUILD_PATH}/menu-active.xpm
    cp ${BUILD_PATH}/transparent.xpm ${BUILD_PATH}/menu-inactive.xpm
    cp ${BUILD_PATH}/transparent.xpm ${BUILD_PATH}/menu-prelight.xpm
    cp ${BUILD_PATH}/transparent.xpm ${BUILD_PATH}/menu-pressed.xpm
    cp ${BUILD_PATH}/transparent.xpm ${BUILD_PATH}/stick-active.xpm
    cp ${BUILD_PATH}/transparent.xpm ${BUILD_PATH}/stick-inactive.xpm
    cp ${BUILD_PATH}/transparent.xpm ${BUILD_PATH}/stick-prelight.xpm
    mv ${BUILD_PATH}/transparent.xpm ${BUILD_PATH}/stick-pressed.xpm

    # Get rid of temp folder
    if [ -d ${TEMP_PATH} ]; then rm -rf ${TEMP_PATH}; fi;
}

main $1

