# Charger Control

Charger control is designed for the original Jolla Phone and allows you to control how the battery is charged/discharged when a USB cable is connected. The app gives you three options:

* **CHARGE** - The battery is charged normally. This is the default after the phone is started or when the app is not installed.
* **DO NOT CHARGE** - The battery is not charged. USB power is used to power the phone only. Using this you can keep your battery level at say 80% and still have it use USB power to power the phone.
* **DISCHARGE** - USB power is not used at all. This is handy if you have the phone connected to a laptop without a charger and don't want to drain the laptop battery yet still want to communicate over USB.

**NOTE:** This app has not been tested on any other Sailfish device than the original Jolla Phone. Use it at your own risk on other Sailfish devices. In fact, you use the program at your own risk on any device. The app uses low-level interfaces to control the charger on the device and obviously they have not been thoroughly tested by Jolla. I have however been using the app on my own phone for over a year and it has been working perfectly.

The app is completely controlled using cover actions. The cover also actively shows the state of the application like "Charging", "Discharging", "Not charging", "Battery Full" and also the amount of current/power going from/to the battery.

After startup the phone is always in the default CHARGE mode. After you start the app and change modes the mode remains active until you change it with the app or restart your phone. Even if you shut down the app the mode will stay. Only restarting the phone resets the mode back to CHARGE.

Please note that it is fully possible for the phone to use more power (when running heavy applications) than is available from USB, especially if you connect to a charger/laptop that provides less than the maximum charging power to the phone. In this case the cover status indicators will show you that the phone is actually discharging despite being configured to CHARGE or NO CHARGE modes.

The current & power indicators show positive values when the battery is charging and negative values when the battery is draining. When in "NO CHARGE" mode or when battery is full, and the phone is using less power than available over USB, the current & power indicators will show values very close to, but not exactly zero. For example 1.72mA and 7.16mW. This seems to be normal. :)

The app has been written to use as little battery power itself as possible. I have not noticed any difference in battery draining times when the app is running or not. Whenever the cover is not visible, the monitoring is shut down and the app basically waits for the cover to become visible again before doing anything. When swithcing modes the app reconfigures the hardware, so there is no active monitoring needed to achieve the different charging modes. The monitoring is only for keeping the user informed when the cover is visible. Please note though that future versions MAY provide additional features where this is no longer the case, but I promise they will not be enabled by default. :)

Technical note: Because the hardware controls to control the charging are not accessible to normal apps in current Sailfish OS releases, I had to write a systemd service that changes the permissions of the controls when the app is installed and when phone starts up. The permissions are set so that only Charger Control can access them, so it does not decrease security of those controls outside the Charger Control app. The app itself is run in "setgid" mode to give it permissions to the hardware controls. Due to these two special arrangements (systemd service + setgid) the app is not eligible for the Jolla Store. If at any point in the future Sailfish OS loosens the permissions of these hardware controls then these arrangements are no longer necessary and the app can be submitted to the store.

The source code for the app is available on GitHub: https://github.com/xkr47/sailfish-charger-control/. Please file your issues, suggestions and pull requests there. General comments are also welcome and can be submitted via https://openrepos.net/content/xkr47/charger-control/.
