# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = charger-control

CONFIG += sailfishapp

SOURCES += src/charger-control.cpp

OTHER_FILES += qml/charger-control.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    rpm/charger-control.changes.in \
    rpm/charger-control.spec \
    rpm/charger-control.yaml \
    translations/*.ts \
    charger-control.desktop \
    qml/cover/charger-control-charge.png \
    qml/cover/charger-control-nocharge.png \
    qml/cover/charger-control-off.png \
    qml/cover/Property.qml \
    rpm/charger-control-permissions.service \
    rpm/charger-control-permissions.sh

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/charger-control-de.ts

systemd_service.path = /usr/lib/systemd/user
systemd_service.files = rpm/*.service
INSTALLS += systemd_service

systemd_service_scripts.path = /usr/libexec
systemd_service_scripts.files = rpm/*.sh
INSTALLS += systemd_service_scripts
