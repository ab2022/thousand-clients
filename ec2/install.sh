#!/bin/bash -xe

cd /home/ubuntu

sudo add-apt-repository ppa:xtradeb/apps -y
sudo apt update
sudo apt install -y chromium

sleep 10

for i in {0..29}; do
    debport="1090${i}"
    if (( i > 9 )); then
        debport="109${i}"
    fi
    sess=$(openssl rand -hex 8)
    nohup chromium --no-sandbox --user-data-dir=/home/ubuntu/.config/chromium-${i} --headless=new --remote-debugging-port=${debport} --disable-gpu --autoplay-policy=no-user-gesture-required --allow-running-insecure-content --ignore-certificate-errors "https://nightly-dot-shaka-player-demo.appspot.com/demo/#audiolang=en-US;textlang=en-US;lowLatencyMode=true;cmcd.enabled=true;sessionId=${sess};contentId=DASH-Content-ID-01;uilang=en-US;assetBase64=eyJuYW1lIjoic2t5IG5ld3MiLCJzaG9ydE5hbWUiOiIiLCJpY29uVXJpIjoiIiwibWFuaWZlc3RVcmkiOiJodHRwczovL3NhdHBvYy5jb206MTI5MTAvZGFzaC9TZXJ2aWNlMi9tYW5pZmVzdC5tcGQiLCJzb3VyY2UiOiJDdXN0b20iLCJmb2N1cyI6ZmFsc2UsImRpc2FibGVkIjpmYWxzZSwiZXh0cmFUZXh0IjpbXSwiZXh0cmFUaHVtYm5haWwiOltdLCJleHRyYUNoYXB0ZXIiOltdLCJjZXJ0aWZpY2F0ZVVyaSI6bnVsbCwiZGVzY3JpcHRpb24iOm51bGwsImlzRmVhdHVyZWQiOmZhbHNlLCJkcm0iOlsiTm8gRFJNIHByb3RlY3Rpb24iXSwiZmVhdHVyZXMiOlsiVk9EIl0sImxpY2Vuc2VTZXJ2ZXJzIjp7Il9fdHlwZV9fIjoibWFwIn0sIm9mZmxpbmVMaWNlbnNlU2VydmVycyI6eyJfX3R5cGVfXyI6Im1hcCJ9LCJsaWNlbnNlUmVxdWVzdEhlYWRlcnMiOnsiX190eXBlX18iOiJtYXAifSwicmVxdWVzdEZpbHRlciI6bnVsbCwicmVzcG9uc2VGaWx0ZXIiOm51bGwsImNsZWFyS2V5cyI6eyJfX3R5cGVfXyI6Im1hcCJ9LCJleHRyYUNvbmZpZyI6bnVsbCwiZXh0cmFVaUNvbmZpZyI6bnVsbCwiYWRUYWdVcmkiOm51bGwsImltYVZpZGVvSWQiOm51bGwsImltYUFzc2V0S2V5IjpudWxsLCJpbWFDb250ZW50U3JjSWQiOm51bGwsImltYU1hbmlmZXN0VHlwZSI6bnVsbCwibWVkaWFUYWlsb3JVcmwiOm51bGwsIm1lZGlhVGFpbG9yQWRzUGFyYW1zIjpudWxsLCJ1c2VJTUEiOnRydWUsIm1pbWVUeXBlIjpudWxsfQ==;panel=CUSTOM%20CONTENT;build=uncompiled" 2>&1 &
done

