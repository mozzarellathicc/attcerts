# BGW210 4.23.4 Cert Extraction

Exploit works on the BGW210. Status on other devices is unknown.

BGW320: Firmware 3.18.1 does NOT work.

This method can take many attempts to succeed. If anyone is able to improve the consistency, please let me know.

<a id="toc"></a>
- [Resources](#user-content-resources)
- [Prerequisites](#user-content-prerequisites)
- [Initial Setup](#user-content-initial-setup)
  - [Assign Static IP](#user-content-assign-static-ip)
  - [Prepare the RG](#user-content-prepare-the-rg)
- [Extract the \*.der files](#user-content-extract-the-der-files)
- [Extract mfg.dat](#user-content-extract-mfgdat)
- [Credits](#user-content-credits)

## Resources
1. [3.18.2_en.bin](http://gateway.c01.sbcglobal.net/firmware/ALPHA/210/001E46/BGW210-700_3.18.2/spTurquoise210-700_3.18.2_ENG.bin)
   - (Optional if BGW firmware =< 3.18.2)
   - `http://gateway.c01.sbcglobal.net/firmware/ALPHA/210/001E46/BGW210-700_3.18.2/spTurquoise210-700_3.18.2_ENG.bin`
2. [mfg_dat_decode](https://www.devicelocksmith.com/2018/12/eap-tls-credentials-decoder-for-nvg-and.html)
   - `https://www.devicelocksmith.com/2018/12/eap-tls-credentials-decoder-for-nvg-and.html`
3. [get_mfg_dat.sh](https://raw.githubusercontent.com/mozzarellathicc/attcerts/main/get_mfg_dat.sh)
4. [get_rootcerts.sh](https://raw.githubusercontent.com/mozzarellathicc/attcerts/main/get_rootcerts.sh)

[↑ Return to menu](#toc)
## Prerequisites
1. Residential Gateway (RG) vulnerable to the muhttpd path traversal exploit
   - This guide was written for the BGW210.
   - As of December 2023, confirmed downgrade works from firmware 4.25.5
   - It has not been tested on the BGW320 or any of the NVG line.
2. Device with an ethernet port
3. Basic knowledge of commandline

[↑ Return to menu](#toc)
## Initial Setup
Download the provided [resources](#resources) before proceeding. Ensure the scripts are executable by running:

- `chmod +x get_mfg_dat.sh`
- `chmod +x get_rootcerts.sh`

[↑ Return to menu](#toc)
### Assign Static IP
**After finishing this method, ensure these settings are reverted to Automatic (DHCP).**

<a id="windows"></a>

<details>
    <summary><b>Windows</b></summary>
    <ol>
        <li>Settings → Network & Internet → Ethernet</li>
        <li>Select the active Ethernet connection</li>
        <li>Under IP settings, click "Edit"</li>
        <li>Change Automatic (DHCP) to Manual</li>
        <li>Toggle on IPv4</li>
        <li>Fill in the fields as follows:
            <ul>
                <li>IP address:
                    <ul>
                        <li>192.168.1.x (i.e., 192.168.1.200)</li>
                    </ul>
                </li>
                <li>Subnet prefix length:
                    <ul>
                        <li>24</li>
                        <li>If it says "Subnet Mask" instead, use 255.255.255.0</li>
                    </ul>
                </li>
                <li>Gateway:
                    <ul>
                        <li>192.168.1.254</li>
                    </ul>
                </li>
            </ul>
        </li>
    </ol>
</details>
<a id="mac"></a>
<details>
    <summary><b>Mac</b></summary>
    <ol>
        <li>System Settings/Preferences → Network</li>
        <li>Select the active Ethernet connection
        <ul><li>*Ventura 13: Click Details*</li></ul></li>
        <li>Click "Advanced".</li>
        <li>Click "TCP/IP".</li>
        <li>Configure IPv4</li>
        <li>Set "Configure IPv4" to "Manually"</li>
        <li>Fill in the following details:
            <ul>
                <li>IP address:  
                    <ul>
                        <li>192.168.1.x (i.e., 192.168.1.200)</li>
                    </ul>
                </li>
                <li>Subnet Mask:
                    <ul>
                        <li>255.255.255.0</li>
                    </ul>
                </li>
                <li>Router:
                    <ul>
                        <li>192.168.1.254</li>
                    </ul>
                </li>
            </ul>
        </li>
        <li>Click "Apply" to save changes</li>
    </ol>
</details>

[↑ Return to menu](#toc)
### Prepare the RG
1. Unplug the power cable
2. If attached, unplug the Ethernet cable connected to the ONT port
3. Connect computer's Ethernet port to one of the **Ethernet ports** on the RG. Do **not** connect it to the ONT.
4. Plug the RG's power cable back in and wait for it to boot up.
5. Navigate to the U-verse portal at 192.168.1.254
   - Click the "Diagnostics" tab
   - Click the "Update" link
     - If current firmware version is **below** 3.18.2, skip this step.
     - If current firmware version is **above** 3.18.2, upload the 3.18.2_EN.bin file and wait for the update to complete.
6. Test if the RG is vulnerable to the exploit. Make sure the BGW is fully booted, then, in the **computer's** terminal, run:
   - `curl --ignore-content-length -X"GET a/etc/hosts" http://192.168.1.254:80`
   If the hosts file is printed, the exploit will work.

[↑ Return to menu](#toc)
## Extract the \*.der files
To decode mfg.dat, you'll need to download the attroot2031.der, attsubca2021.der, and attsubca2030.der files.
From the computer's terminal, run:

`./get_rootcerts.sh`

[↑ Return to menu](#toc)
## Extract mfg.dat
This will likely take several tries. The updated version of the script by [@mdonohue](https://github.com/mdonohue) should require only one terminal open.

1. Unplug the RG's power cable.
2. In the terminal, run:
   - `./get_mfg_dat.sh`.
3. Plug in the RG's power cable again.
4. Repeat until successful. The mfg.dat file should be bigger than 200kb.
5. Stop the script by either exiting the terminal or pressing `Ctrl+C`.
6. Copy the mfg.dat file and all three \*.der files to the same directory as **mfg_dat_decode**
7. Run mfg_dat_decode
8. If there's no error, the certificates will have been extracted and decoded successfully.

**Change the computer's IP back to Automatic/DHCP.**

[↑ Return to menu](#toc)
## Credits
- [8311 Discord Server](https://discord.gg/c8HGajUEGk)
  - @ChrisEric1 CECL#5569 – 3.18.2_en.bin + CVE tip
  - @ibutsu – Lots of scripting help
  - @jack2333 – Lots of help with troubleshooting and testing
  - @redbeard#3977 – Documenting their experiment with this exploit
  - @tofu#6072 – Initial CVE tip to @redbeard
  - @up_n_atom – \*.der file locations
- [Derek Abdine](https://derekabdine.com/blog/2022-arris-advisory.html) – CVE Write-up
- [devicelocksmith](https://www.devicelocksmith.com/2018/12/eap-tls-credentials-decoder-for-nvg-and.html) – mfg_dat_decode
- [mdonohue](https://github.com/mdonohue) – Optimization of get_mfg_dat.sh

[↑ Return to menu](#toc)
