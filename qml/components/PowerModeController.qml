import QtQuick 2.0
import harbour.charger.control.FileIO 1.0

Item {
    property int mode: 0 + stateFile.read() // 0=off, 1=phone, 2=charge

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
}
