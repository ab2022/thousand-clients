#!/bin/bash -xe
echo "Copying the SSH Key to the server"

SSH_PUB_KEY="your public ssh key"

cd /home/ubuntu
echo -e "${SSH_PUB_KEY}" >> .ssh/authorized_keys

sudo apt-get update
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome-stable_current_amd64.deb

sleep 60

for i in {0..29}; do
    debport="1090${i}"
    if (( i > 9 )); then
        debport="109${i}"
    fi
	nohup google-chrome-stable --no-sandbox --user-data-dir=/home/ubuntu/.config/google-chrome-ub10${i} --headless=new --remote-debugging-port=${debport} --disable-gpu --autoplay-policy=no-user-gesture-required --allow-running-insecure-content --ignore-certificate-errors "https://reference.dashif.org/dash.js/nightly/samples/dash-if-reference-player/index.html?mpd=http%3A%2F%2Fsatpoc.com%3A12909%2Fdash%2FService2%2Fmanifest.mpd&autoLoad=true&muted=true+&debug.logLevel=4&streaming.delay.liveDelayFragmentCount=NaN&streaming.delay.liveDelay=NaN&streaming.buffer.initialBufferLevel=NaN&streaming.liveCatchup.maxDrift=NaN&streaming.liveCatchup.playbackRate.min=NaN&streaming.liveCatchup.playbackRate.max=NaN&streaming.cmcd.enabled=true" 2>&1 &
done

