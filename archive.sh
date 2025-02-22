if [ -d build/Xfwaita4-dark ] && [ -d build/Xfwaita4-light ]
then
    echo "Creating archive of all variants"
    tar -zcf build/Xfwaita4.tar.gz -C build Xfwaita4-dark Xfwaita4-light
    tar -zcf build/Xfwaita4-dark.tar.gz -C build Xfwaita4-dark
    tar -zcf build/Xfwaita4-light.tar.gz -C build Xfwaita4-light
elif [ -d build/Xfwaita4-dark ]
then
    echo "Creating archive of dark theme"
    tar -zcf build/Xfwaita4-dark.tar.gz -C build Xfwaita4-dark
elif [ -d build/Xfwaita4-light ]
then
    echo "Creating archive of light theme"
    tar -zcf build/Xfwaita4-light.tar.gz -C build Xfwaita4-light
else
    echo "Error: no build files found"
fi
