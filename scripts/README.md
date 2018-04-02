
# How to install the scripts

## Script overwrite-toon-configs.sh

Copy the script to /usr/bin and make it executable, like this

    chmod u+x /usr/bin/overwrite-toon-configs.sh

And add this line in the ***/etc/inittab***
(below the /sbin/getty line, if you have one)

    # HCBv2 static stuff
    # ...... some other lines
    gett:235:respawn:/sbin/getty -L 115200 ttymxc0 vt102
    hkt:245:boot:/usr/bin/overwrite-toon-configs.sh
