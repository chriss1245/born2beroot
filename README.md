# Born2BeRoot
The steps  I made to start up a server (based on [Baigalaa's ](https://baigal.medium.com/born2beroot-e6e26dfb50ac) guide) on a virtual machine.

## Operating System
We were told to choose between **Cent OS** and **Debian**
I decided to choose Debian because of the community it supports it. While Cent OS is supported by the Red Hat company, Debian is more a hippie distro.
In addition, Debian is one of the most popular and well stablished linux dstributions. Other distributions such as Ubuntu are Debian based. 

One of the most significant differences between Debian and Cent Os is at the Linux Security Module (which handles the resources' permissions a program has). Cent Os implements SELinux whereas Debian implements AppArmor. AppArmor was designed to be more user friendly and works with profiles intead of a policy.

## Installation
* I created a new virtual machine using the latest version of Debian (11.2.0). 
* I created a boot partition of 500 MB mounted on ``/boot`` and a logical partition which will contain encrypted logical volumes in the LVMGroup.
  * |Name|Mount Point|File System|Description|
    |----|-----------|------------|----------|
    |root|``/``|Ext4|The parent folder of the whole schema|
    |home|``/home``|Ext4|The folder where the users' information will be stored|
    |srv|``/srv``|Ext4|Site specific data server by the system|
    |tmp|``/tmp``|Ext4|Where the temporal files lie|
    |var|``/var``|Ext4|Contains variable files that the operating system reads and write in|
    |var-log|``/var/log``|Ext4|Contains the log files|
    |swap| ``-``|Linux Swap|Auxiliar storage if the RAM is full|
* I only installed ssh. Not graphical interface neither standard system utilities.

## Sudo
``sudo`` is a program tha enables a user to run commands as other user (root by default) getting access to all the privileges the other user has.

In order to install sudo it is needed to use the root user.
The first thing to do is log as root and download sudo.
```console
apt install sudo
```
In order to add the cmanzano user to the sudo group (so that it can run sudo)
```console
usermod -aG sudo cmanzano
```

If we execute ``sudo -v`` we can check whether the user can run sudo.
![sudo](https://user-images.githubusercontent.com/58918297/147292664-b475c37d-48c2-4b9e-b798-2bea7bc96a80.png)

Now we need to stablish a strong policy for the sudo group.
```console
sudo nano /etc/sudoers
```
It is recommended not to edit the suddores file. It is a good practice to edit the /etc/sudoers.d directory. There you can create more complex policies.

We have to complain with the following policies:
* Authentication using sudo has to be limited to 3 attempts in the event of an incor-
rect password.
* A custom message of your choice has to be displayed if an error due to a wrong
password occurs when using sudo.
* Each action using sudo has to be archived, both inputs and outputs. The log file
has to be saved in the /var/log/sudo/ folder.
* The TTY mode has to be enabled for security reasons.
* For security reasons too, the paths that can be used by sudo must be restricted.
Example:
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin

## Ufw
Ufw stands for Unclomplicated Firewall. It is a firewall xd. To install it.
```console
sudo apt install ufw
sudo systemctl enable ufw
sudo systemctl start ufw
sudo ufw enable
```
To allow 4242 port:
```console 
sudo ufw allow 4242
```

## SSH
SSH is a protocol that provides a secure way for users to connect to a computer over an insecure network (internet). 
We have been told to change the port (by de fault 22) to 4242 on the ``/etc/ssh/sshd_config`` file. In addition, we have to disable login as root throught ssh. In the same file we det the ``PermitRootLogin`` option to ``no``.

In order to allow ssh connections to the virtual machine it is also needed that we enable *port forwarding* at the network settings.
Finally we can connect from our computer's terminal by: 
```console 
ssh cmanzano@127.0.0.1 -p 4242
```

## Passwords Policy
We were told:

* Your password has to expire every 30 days. ``PASS_MAX_DAYS 30``
* The minimum number of days allowed before the modification of a password will be set to 2. ``PASS_MIN_DAYS 30``
* The user has to receive a warning message 7 days before their password expires. ``PASS_WARN_AGE 7``

We can apply these rules by modifying the file ``/etc/login.def``
```console
sudo nano /etc/login.def
```

* Your password must be at least 10 characters long. It must contain an uppercase letter and a number. Also, it must not contain more than 3 consecutive identical
characters ``minlen=10`` ``ucredit=-1`` ``dcredit=-1`` ``maxrepeat=3``
* The password must not include the name of the user. ``reject_username``
* The following rule does not apply to the root password: The password must have at least 7 characters that are not part of the former password. ``difok=7``
* Of course, your root password has to comply with this policy ``enforce_for_root``

In order to apply the remaining requirements we need to install the ``libpam-pwquality`` packege and edit the ``common-password`` file found at the ``/etc/pam.d/`` directory.
```console
sudo apt install libpam-pwquality
sudo nano /etc/pam.d/common-password
```

