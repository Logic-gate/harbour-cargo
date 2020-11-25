

    function retinaIconLink(sourceObject, searchValue, newValue){
        return sourceObject.replace(searchValue, newValue)
    }

    function dir(mimeType) {
        if (mimeType === "application/vnd.google-apps.folder") {
            return true
        }
        else {
            return false
        }
    }

    function refreshAfterSearch(count, param, header){
        listModel.clear()
        focus = true
        pageHeader.title = header
        py.getCustomSearch(count, param)
    }

    function refresh(){

        listModel.clear()
        py.getData(25)
    }


    function pushPageDir(count, param, header){
        focus = true
        pageStack.push('../pages/ListPage.qml', {dirPush: true, fetchCount: count, fetchParam: param, fetchHeader: header})
    }

    //fileThumbnailLink is actuall contentHints
    function pushPageFile(fileId, fileName,
                          fileDescription, fileSize,
                          fileModifiedTime, fileMimeType,
                          fileCreatedTime, fileWebViewLink,
                          fileIconLink, fileHasThumbnail,
                          fileThumbnailLink, fileShared,
                          fileSharedWithMeTime, fileOwnedByMe, md5Checksum, filePath){
        pageStack.push('../pages/InfoPage.qml', {fileId: fileId, fileName: fileName,
                                         fileDescription: fileDescription, fileSize: fileSize,
                                        fileModifiedTime: fileModifiedTime, fileMimeType: fileMimeType,
                                        fileCreatedTime: fileCreatedTime, fileWebViewLink: fileWebViewLink,
                                        fileIconLink: fileIconLink, fileHasThumbnail: fileHasThumbnail,
                                        fileThumbnailLink: fileThumbnailLink, fileShared: fileShared,
                                        fileSharedWithMeTime: fileSharedWithMeTime, fileOwnedByMe: fileOwnedByMe, md5Checksum: md5Checksum, filePath: filePath})


    }
