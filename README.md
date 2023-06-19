Credits
-------

*   [8311 Discord Server](https://www.google.com/url?q=https://discord.gg/c8HGajUEGk&sa=D&source=editors&ust=1687215678125409&usg=AOvVaw2xWDtEEMBc1eTzP0JJGykH)

*   @ChrisEric1 CECL#5569 – 3.18.2\_en.bin + CVE tip
*   @tofu#6072 – CVE tip
*   @redbeard#3977 – Documenting their experiment with this exploit
*   @up\_n\_atom – \*.der file locations
*   @jack2333 – Helped troubleshooting, lots of suggestions
*   @ibutsu – Recursive script suggestion

*   [Derek Abdine – CVE Write-up](https://www.google.com/url?q=https://derekabdine.com/blog/2022-arris-advisory.html&sa=D&source=editors&ust=1687215678127846&usg=AOvVaw0qyBoJQ8UzchhtxQIWeiYZ)
*   [devicelocksmith](https://www.google.com/url?q=https://www.devicelocksmith.com/2018/12/eap-tls-credentials-decoder-for-nvg-and.html&sa=D&source=editors&ust=1687215678128482&usg=AOvVaw2vYXRfD6_jb1JcwQZO8Eta) – mfg\_dat\_decode

Prerequisites
-------------

1.  BGW210 on 4.22.5 or lower, untested on BGW320
2.  Computer with an ethernet port
3.  Ability to copy paste

Resources
---------

1.  [3.18.2\_en.bin](https://www.google.com/url?q=http://gateway.c01.sbcglobal.net/firmware/ALPHA/210/001E46/BGW210-700_3.18.2/spTurquoise210-700_3.18.2_ENG.bin&sa=D&source=editors&ust=1687215678129995&usg=AOvVaw2FjKTrvz-_LPRgENR_-jXX) (gateway.c01.sbcglobal.net/firmware/ALPHA/210/001E46/BGW210-700\_3.18.2/spTurquoise210-700\_3.18.2\_ENG.bin)
2.  [mfg\_dat\_decode](https://www.google.com/url?q=https://www.devicelocksmith.com/2018/12/eap-tls-credentials-decoder-for-nvg-and.html&sa=D&source=editors&ust=1687215678130742&usg=AOvVaw3V76euGKX0nJmFGMdM0vpK)  
    Necessary for decoding mfg.dat for certs
3.  [mfg\_dat\_flood.sh](https://www.google.com/url?q=https://pastebin.com/7FQxXPdV&sa=D&source=editors&ust=1687215678131527&usg=AOvVaw2687TYyP390-ykP2y_7EpE) (Optional)  
    Runs a curl get request recursively until success or your shell crashes. It can also be done manually by hand but I can’t cover that since I had no success. I ran the script with Ubuntu through WSL.
4.  [CVE](https://www.google.com/url?q=https://derekabdine.com/blog/2022-arris-advisory.html&sa=D&source=editors&ust=1687215678132252&usg=AOvVaw2wDxHDJaiJrPIaaQiQileT) (Optional)  
    In depth explanation of the exploit.[Vulnerability #1](https://www.google.com/url?q=https://derekabdine.com/blog/2022-arris-advisory.html%23vulnerability-1-cve-2022-31793-path-traversal-from-the-filesystem-root&sa=D&source=editors&ust=1687215678132670&usg=AOvVaw1BsZMwa9EPH4iq5v-UgJ1O), [methodology](https://www.google.com/url?q=https://derekabdine.com/blog/2022-arris-advisory.html%23decrypting-secrets&sa=D&source=editors&ust=1687215678133039&usg=AOvVaw3H1KXtYfubMqvbpZZBivDt) (bullet point “Obtaining the certificate via reboot & exploitation”

Steps
-----

1.  Assign the following static IP to your computer  
    Windows:  
    Settings → Network & Internet → Ethernet → {your ethernet connection} → Edit button under IP Settings → Change Automatic (DHCP) to Manual → Turn on IPv4 → Fill in:

*   IP address:  
    192.1.168.x (i.e., 192.1.168.200)  
    
*   Subnet mask:  
    255.255.255.0  
    OR  
    Subnet prefix length: 24
*   Gateway: 192.168.1.254

2.  Connect to the BGW210  
    Unplug ONT port on BGW210 → plug in an ethernet cable from your computer to one of the BGW210’s ethernet ports → plug in BGW210’s power cable
3.  Navigate to 192.168.1.254 (BGW210 GUI) → Diagnostics → Update → Upload 3.18.2\_EN.bin → Wait for the update to complete
4.  In your computer’s terminal:

*   Create the script file with your text editor of choice:  
    nano flood.sh
*   Paste the script
*   Save and exit nano (ctrl+x → ctrl+y → enter)
*   Make script executable:  
    chmod +x fetch\_file.sh

5.  Once the update is done and the modem is back online, unplug the modem, wait a few seconds, and plug it back in.
6.  In your computer’s terminal:

*   If using the script, type the following then hit enter:  
    ./flood.sh

7.  If you end up with a mfg.dat file bigger than 200kb or so, it likely worked. If not, unplug and replug the modem. The script will still be running, but you can stop it (ctrl+C) and start it again (./flood.sh) too.
8.  Repeat until successful. I was running 6 tabs at once.
9.  After successfully getting the mfg.dat file, stop the script.
10.  Ensure the modem is powered on, then run each of these commands through the terminal:

*   curl --ignore-content-length -X"GET a/etc/rootcert/attroot2031.der" http://192.168.1.254:80 -o attroot2031.der
*   curl --ignore-content-length -X"GET a/etc/rootcert/attsubca2021.der" http://192.168.1.254:80 -o attsubca2021.der
*   curl --ignore-content-length -X"GET a/etc/rootcert/attsubca2030.der" http://192.168.1.254:80 -o attsubca2030.der

11.  Copy the mfg.dat and all three \*.der files to the same directory/folder as mfg\_dat\_decode
12.  Run mfg\_dat\_decode
13.  Certs (hopefully) obtained
