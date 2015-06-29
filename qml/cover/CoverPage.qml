/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0

// project imports
import FileIO 1.0
import CoverStatus 1.0

CoverBackground {
    id: cover
    property int mode: 0 + stateFile.read() // 0=off, 1=phone, 2=charge
    property string status: "<charging?>"
    property string status2: "<usbcable?>"
    property double current: 1.111
    property double power: 1.222
    property double capacity: 110

    // mode management

    FileIO {
        id: stateFile
        source: "/tmp/charger-control.state"
        onError: {
            console.log("ERROR: Failed to read state file: ", msg);
            Qt.quit();
        }
    }
    FileIO {
        id: pm8921ChargerDisableFile
        source: "/sys/module/pm8921_charger/parameters/disabled"
        onError: console.log("ERROR: PM8921: ", msg)
    }
    FileIO {
        id: powerSupplyChargerDisableFile
        source: "/sys/class/power_supply/usb/charger_disable"
        onError: console.log("ERROR: power_supply: ", msg)
    }

    onModeChanged: {
        // NOTE: PM8921 must be written first
        //console.log("Mode changed to " + mode);
        var stat1 = pm8921ChargerDisableFile.write(mode < 2 ? 1 : 0);
        var stat2 = powerSupplyChargerDisableFile.write(mode < 1 ? 1 : 0);
        if (stat1 && stat2) {
          stateFile.write(mode);
        } else {
          mode = 0 + stateFile.read();
        }
    }

    // cover status updater

    FileIO {
        id: voltageNowFile
        source: "/sys/devices/platform/msm_ssbi.0/pm8038-core/pm8921-charger/power_supply/battery/voltage_now"
        onError: console.log("ERROR: voltage_now: ", msg)
    }
    FileIO {
        id: currentNowFile
        source: "/sys/devices/platform/msm_ssbi.0/pm8038-core/pm8921-charger/power_supply/battery/current_now"
        onError: console.log("ERROR: current_now: ", msg)
    }
    FileIO {
        id: capacityFile
        source: "/sys/devices/platform/msm_ssbi.0/pm8038-core/pm8921-charger/power_supply/battery/capacity"
        onError: console.log("ERROR: capacity: ", msg)
    }
    FileIO {
        id: statusFile
        source: "/sys/devices/platform/msm_ssbi.0/pm8038-core/pm8921-charger/power_supply/battery/status"
        onError: console.log("ERROR: charge_type: ", msg)
    }
    FileIO {
        id: usbTypeFile
        source: "/sys/devices/platform/msm_ssbi.0/pm8038-core/pm8921-charger/power_supply/usb/type"
        onError: console.log("ERROR: charge_type: ", msg)
    }

    CoverStatus {
        id: coverStatus
    }

    Timer {
        interval: 1000
        running: coverStatus.status === 2
        repeat: true
        onTriggered: {
            var currentFileTxt = currentNowFile.read();
            current = currentFileTxt.length > 0 ? currentFileTxt / 1e6 : current + 0.00001;

            var voltageNowTxt = voltageNowFile.read();
            var voltage = voltageNowTxt.length > 0 ? voltageNowTxt / 1e6 : 1.111;
            power = voltage * current;

            var capacityTxt = capacityFile.read();
            capacity = capacityTxt.length > 0 ? capacityTxt : 120;

            var statusTxt = statusFile.read();
            var usbTypeTxt = usbTypeFile.read();

            // "Unknown", "Charging", "Discharging", "Not charging", "Full"
            status = statusTxt.length > 0 ? statusTxt === "Full" ? "Battery full" : statusTxt : "Simulated";
            status2 = usbTypeTxt.length > 0 ?
                         usbTypeTxt === "USB" ?
                             statusTxt === "Discharging" ? "USB power not used"
                           : statusTxt === "Not charging" ? "USB powers phone only"
                           : ""
                       : "USB cable disconnected"
                   : "Simulated";
        }
    }

    // ui

    Column {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: Theme.paddingSmall
        anchors.leftMargin: Theme.paddingSmall
        width: parent.width - (2 * anchors.leftMargin)
        Label {
            text: qsTr("Charger Control")
            font.pixelSize: Theme.fontSizeSmall
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Label {
            text: status
            font.pixelSize: Theme.fontSizeExtraSmall
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Label {
            text: status2
            font.pixelSize: Theme.fontSizeTiny
            color: Theme.secondaryColor
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Image {
            source: cover.mode == 0 ? "charger-control-off.png" : cover.mode == 1 ? "charger-control-nocharge.png" : "charger-control-charge.png"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Property {
            label: qsTr("Current:")
            value: (current * 1e3).toFixed(2) + " mA"
        }
        Property {
            label: qsTr("Power:")
            value: (power * 1e3).toFixed(2) + " mW"
        }
        Property {
            label: qsTr("Capacity:")
            value: capacity.toFixed(0) + " %"
        }
    }

    CoverActionList {
        id: coverListOff
        enabled: cover.mode == 0

        CoverAction {
            iconSource: "charger-control-nocharge.png" // nocharge
            onTriggered: cover.mode = 1
        }

        CoverAction {
            iconSource: "charger-control-charge.png" // charge
            onTriggered: cover.mode = 2
        }
    }
    CoverActionList {
        id: coverListNoCharge
        enabled: cover.mode == 1

        CoverAction {
            iconSource: "charger-control-off.png" // off
            onTriggered: cover.mode = 0
        }

        CoverAction {
            iconSource: "charger-control-charge.png" // charge
            onTriggered: cover.mode = 2
        }
    }
    CoverActionList {
        id: coverListCharge
        enabled: cover.mode == 2

        CoverAction {
            iconSource: "charger-control-off.png" // off
            onTriggered: cover.mode = 0
        }

        CoverAction {
            iconSource: "charger-control-nocharge.png" // nocharge
            onTriggered: cover.mode = 1
        }
    }
}
