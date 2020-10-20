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
TARGET = harbour-cargo

CONFIG += sailfishapp_qml

SOURCES +=

res.files = res
res.path = /usr/share/$${TARGET}

token.files = token
token.path = /home/nemo/.config/$${TARGET}



OTHER_FILES += \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    qml/cover/coveractions.py \
    qml/python/main.py \
    qml/python/header.py \
    qml/creds/client_id.json

DISTFILES += \
    harbour-cargo.desktop \
    qml/components/AppNotification.qml \
    qml/components/AppNotificationItem.qml \
    qml/components/GeneralUseFunctions.js \
    qml/components/LoadingIndicator.qml \
    qml/components/MimeTypeSwitcher.js \
    qml/harbour-cargo.qml \
    qml/pages/About.qml \
    qml/pages/InfoPage.qml \
    qml/pages/ListPage.qml \
    qml/pages/SettingsPage.qml \
    rpm/harbour-cargo.changes.in \
    rpm/harbour-cargo.spec \
    rpm/harbour-cargo.yaml

RESOURCES += \
    qrc.qrc

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172 256x256

ICONPATH = /usr/share/icons/hicolor

86.png.path = $${ICONPATH}/86x86/apps/
86.png.files += icons/86x86/harbour-cargo.png

108.png.path = $${ICONPATH}/108x108/apps/
108.png.files += icons/108x108/harbour-cargo.png

128.png.path = $${ICONPATH}/128x128/apps/
128.png.files += icons/128x128/harbour-cargo.png

172.png.path = $${ICONPATH}/172x172/apps/
172.png.files += icons/172x172/harbour-cargo.png

256.png.path = $${ICONPATH}/256x256/apps/
256.png.files += icons/256x256/harbour-cargo.png

cargo.desktop.path = /usr/share/applications/
cargo.desktop.files = harbour-cargo.desktop


INSTALLS += res token 86.png 108.png 128.png 172.png 256.png

