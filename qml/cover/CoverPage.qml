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

CoverBackground {
    id: cover
    property int mode: 0 + stateFile.read() // 0=off, 1=phone, 2=charge
    property var offText: qsTr("Off")
    property var noChargeText: qsTr("Phone only")
    property var chargeText: qsTr("Charging")
    property double current: 494
    property double power: 1974.1

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
        console.log("Mode changed to " + mode);
        console.log("PM8921 write: "+ pm8921ChargerDisableFile.write(mode < 2 ? 1 : 0));
        console.log("power_supply write: "+ powerSupplyChargerDisableFile.write(mode < 1 ? 1 : 0));
        console.log("statefile: " + stateFile.write(mode));
    }

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
            text: cover.mode == 0 ? cover.offText : cover.mode == 1 ? cover.noChargeText : cover.chargeText
            font.pixelSize: Theme.fontSizeExtraSmall
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Image {
            source: cover.mode == 0 ? "charger-control-off.png" : cover.mode == 1 ? "charger-control-nocharge.png" : "charger-control-charge.png"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Property {
            label: qsTr("Current:")
            value: current + " mA"
        }
        Property {
            label: qsTr("Power:")
            value: power + " mW"
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
