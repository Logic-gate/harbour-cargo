import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.4

import '../components/GeneralUseFunctions.js' as Functions

Page {
    id: settingsPage
    allowedOrientations: Orientation.All
    backNavigation: true

    property var currentIconSet
    property var currentIcon
    property var configBoolean

    SilicaFlickable {
        id: settingsContainer
        contentHeight: column.height
        anchors.fill: parent

        Column {
            id: column
            width: settingsPage.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("Settings")
            }

            SectionHeader {
                text: qsTr("Style")
            }

            TextSwitch {
                id: iconSet
                checked: currentIconSet
                text: qsTr("Enable Google Drive Icons")
                description: qsTr("Use the icons from Google drive. Defaults to Silica Style. You need to refresh for the icon change to take effect")
                onCheckedChanged: {
                    py.configBooleanIconChange(iconSet.checked)
                }
            }

            TextSwitch {
                id: gridModeSet
                text: qsTr("Enable Grid Mode")
                description: qsTr("Not implemented yet")
                checked: false
                down: true

            }


            Label {
                id: separatorLabel
                x: Theme.horizontalPageMargin
                width: parent.width  - ( 2 * Theme.horizontalPageMargin )
                font.pixelSize: Theme.fontSizeExtraSmall
                wrapMode: Text.Wrap
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }
            }

            VerticalScrollDecorator {}
        }

    }
    Python {
        id: py
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../python'))

            setHandler('configBoolean', function (option) {
                    iconSet.checked = option
            })

            setHandler('currentConfig', function (option) {
                    currentIcon = option
            })

            importModule('main', function () {})
        }

        function configBooleanIconChange(checked) {
            call('main.api.configBooleanIconChange', [checked], function () {})
        }

    }
}
