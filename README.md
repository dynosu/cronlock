# cronlock
bash script to prevent double running of crons under linux

This is the initial script. Not using it anywhere yet since its not 100% done yet. 

Flock can do most of this, but its not easy to monitor and therefor not amazing to use. 

This script has been tested in bash on Ubuntu and Debian. If it works on others, great, if not ... Let me know and I will see what I can do. But no promises. 

## Issues

If you see a problem with the script or if you see something i could improve. Then please create an issue and ill look into it. If you have a fix, then please submit it and I will look at it. 

## planned features

* merging of check script and cronlock script. (a monitoring/icinga mode of the script to check on status of a cron)
* examples of apply rules for icinga2 
* improving the code somewhat. 

### Maybe
* If there is interest, I can look at including a docker container config or something. 

## License

Feel free to use the script, however a thank you or acknowledgement would be nice. See the LICENSE for this. 

This repository has the MIT license with the small addition of what I call: Dont be an ass. 

If you use this script to harass others, or in any way harm others ... please dont. If you wanna be an ass, write your own damn script. 

