# Update from Packagecloud Dev Branch

When developing, it is often more convenient to update your WLAN Pi development device from the dev branch of Packagecloud.

The following one-liner will ensure your WLAN Pi updates from dev:

```
curl -s https://packagecloud.io/install/repositories/wlanpi/dev/script.deb.sh | sudo bash
```

You could also use:

```
wpdev -d
```
