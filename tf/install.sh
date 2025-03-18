#!/bin/bash -xe

cd /home/ubuntu

sudo add-apt-repository ppa:xtradeb/apps -y
sudo apt update
sudo apt install -y chromium

sleep 10

for i in {0..2}; do
    debport="1090${i}"
    if (( i > 9 )); then
        debport="109${i}"
    fi
    nohup chromium --no-sandbox --user-data-dir=/home/ubuntu/.config/chromium-${i} --headless=new --remote-debugging-port=${debport} --disable-gpu --autoplay-policy=no-user-gesture-required --allow-running-insecure-content --ignore-certificate-errors "https://ngx24.vastplots.com:12910/player_1.html" 2>&1 &
done

