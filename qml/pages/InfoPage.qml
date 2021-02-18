/* FILE-MANGER */


import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.4

import "../python"
import "../components"
import "../components/MimeTypeSwitcher.js" as MimeTypeIconSwitcher
import "../components/GeneralUseFunctions.js" as Functions

Page {
    id: page
    allowedOrientations: Orientation.All

    property string file: "/"

    property var fileId
    property var fileName
    property var fileDescription
    property var fileSize
    property var fileModifiedTime
    property var fileMimeType
    property var fileCreatedTime
    property var fileWebViewLink
    property var fileIconLink
    property var fileHasThumbnail
    //this will show true for google docs.
    property var fileThumbnailLink
    property var fileShared
    property var fileSharedWithMeTime
    property var fileOwnedByMe
    property var md5Checksum

    property bool downloadCondition
    property var filePath
    property bool fileExistsStep
    property bool exportOrDownload

    function fixGoogleDocsNoThumbnails(fileThumbnailLink) {

        /*
        There is an issue with thumbnails for Goolge documents, 'server reply Not found'.
        One way to fix this is to export the document as SUPPORTED_EXT, fetch the thumbnail of that
        EXT, then delete the EXT. This is by no means the way I want to solve this. Until then,
        this soultion works.
        */
        if (fileHasThumbnail && fileThumbnailLink.search(
                    'https://docs.google.com/') !== -1) {
            return false
        } else if (fileHasThumbnail) {
            return true
        }
    }

    function exportOrDownloadStr() {

        if (['application/vnd.google-apps.spreadsheet',
            'application/vnd.google-apps.document',
            'application/vnd.google-apps.presentation'].indexOf(fileMimeType) >= 0) {
            exportOrDownload = true;
        }


    }

    SilicaFlickable {
        id: flickable
        anchors.fill: parent
        contentHeight: column.height
        VerticalScrollDecorator {
            flickable: flickable
        }

        Component.onCompleted: {
        exportOrDownloadStr();
        }

        PullDownMenu {
            MenuItem {
                /*
                This is the same as download, the only diff is that for Google mimetypes
                it will export the document to a standard form, this should have a condition
                for switching between download and export depending on mimetype; exportOrDownload just
                changes the string; once moved to python, it can act as a true export or download function.
                We can export google docs to docx or pdf for example.
                */
                text: exportOrDownload ? qsTr("Export") : qsTr("Download")
                onClicked: {
                    py.download(fileId, md5Checksum, false)
                }
            }

            MenuItem {

                    text: qsTr("Download as PDF")
                onClicked: {
                    py.download(fileId, md5Checksum, true)
                }
            }

            MenuItem {
                text: qsTr("Open in Browser")
                onClicked: {
                    console.log(fileWebViewLink)
                    Qt.openUrlExternally(fileWebViewLink)
                }
            }

            MenuItem {
                text: qsTr("Share")
                visible: fileExistsStep && md5Checksum ? true : false
                onClicked: {
                        pageStack.animatorPush("Sailfish.TransferEngine.SharePage",
                                {
                                "source": filePath,
                                "mimeType": fileMimeType
                                 })
                    }
            }
        }

        PushUpMenu {
            id: pushUpMenuInfoPage
            visible: md5Checksum && fileMimeType === 'application/pdf' ? true : false
            MenuItem {
                id: openInOffice
                text: fileExistsStep ? qsTr("Open") : qsTr("Download")
                onClicked: {
                    if (fileExistsStep){
                        switch(fileMimeType) {
                            /*
                            This will allow us to open pdf files from cargo
                            */
                        case "application/pdf":
                            pageStack.animatorPush("Sailfish.Office.PDFDocumentPage",
                                                   { title: fileName, source: filePath, mimeType: fileMimeType, provider: page.provider })
                            break
                        default:
                            /*
                            Sailfish Office fails for none pdf files. Needs more investigation.
                            */
                            imageNotification.show(qsTr("Only PDF is supported"));
                            break
                        }
                    }
                    else {
                        py.download(fileId, md5Checksum)
                        page.update()
                    }
                }
            }

         Component.onCompleted: {
            py.checkPath(filePath, md5Checksum)
         }

        }

        Column {
            id: column
            anchors.left: parent.left
            anchors.right: parent.right

            PageHeader {
                title: fileName
            }

            Column {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * x

                Image {
                    id: thumbNail
                    cache: true
                    asynchronous: true
                    source: fixGoogleDocsNoThumbnails(
                                fileThumbnailLink) ? Functions.retinaIconLink(
                                                         fileThumbnailLink,
                                                         '=s220',
                                                         '=s1000') : Functions.retinaIconLink(
                                                         fileIconLink,
                                                         '/16/', '/256/')
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                DetailItem {
                    label: qsTr("Name")
                    value: fileName
                }
                DetailItem {
                    label: qsTr("Size")
                    value: Format.formatFileSize(fileSize)
                }
                DetailItem {
                    label: qsTr("Type")
                    value: fileMimeType
                }
                DetailItem {
                    label: qsTr("id")
                    value: fileId
                }
                DetailItem {
                    id: _md5CheckSum
                    label: qsTr("Checksum")
                    value: md5Checksum ? md5Checksum : _md5CheckSum.visible = false
                }
                DetailItem {
                    id: _fileDescription
                    label: qsTr("Descpriction")
                    value: fileDescription ? fileDescription : _fileDescription.visible = false
                }
                DetailItem {
                    id: _fileOwnedByMe
                    label: qsTr("Owner")
                    value: fileOwnedByMe ? qsTr("Yes") : _fileOwnedByMe.visible = false
                }
                DetailItem {
                    id: _fileModifiedTime
                    label: qsTr("Last Modified")
                    value: fileModifiedTime ? fileModifiedTime : _fileModifiedTime.visible = false
                }
                DetailItem {
                    id: _fileCreatedTime
                    label: qsTr("Created On")
                    value: fileCreatedTime ? fileCreatedTime : _fileCreatedTime.visible = false
                }
                DetailItem {
                    id: _fileShared
                    label: qsTr("Shared")
                    value: fileShared ? qsTr("Yes") : _fileShared.visible = false
                }
                DetailItem {
                    id: _fileSharedWithMeTime
                    label: qsTr("Shared with me")
                    value: fileSharedWithMeTime ? fileSharedWithMeTime : _fileSharedWithMeTime.visible = false
                }
            }
        }

        AppNotification {
            id: imageNotification
        }
    }

    Python {
        id: py
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../python'))
            setHandler('download_status', function (res) {
                if (res === 100) {
                    imageNotification.show(qsTr("Download Complete!"));
                }
                else if (res === 110) {
                    imageNotification.show(qsTr("File Already Exists"));
                }
                else {
                    imageNotification.show(qsTr("Download Failed!"));
                }
            })
            setHandler('downloadCondition', function (logic) {
                downloadCondition = logic
            })
            setHandler('path', function (logic) {
                fileExistsStep = logic
            })
            importModule('main', function () {})
        }


        function download(id, md5Checksum, asPdf) {
            call('main.api.download', [id, md5Checksum, asPdf], function () {})
        }

        function checkPath(filePath, md5Checksum) {
            call('main.api.checkPath', [filePath, md5Checksum], function () {})

        }
    }
}
