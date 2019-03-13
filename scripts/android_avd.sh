#!/bin/bash

# Download an ARM system image to create an ARM emulator.
echo "yes" | sdkmanager "system-images;android-24;google_apis;armeabi-v7a"

# Create an ARM AVD emulator, with a 100 MB SD card storage space. Echo "no"
# because it will ask if you want to use a custom hardware profile, and you don't.
# https://medium.com/@AndreSand/android-emulator-on-docker-container-f20c49b129ef
echo "no" | avdmanager create avd \
    -n test \
    -k "system-images;android-24;google_apis;armeabi-v7a" \
    -c 100M \
    --force

# Launch the emulator in the background
$ANDROID_HOME/emulator/emulator -avd test -no-skin -no-audio -no-window -no-boot-anim -gpu off &