# coding=utf-8
from __future__ import print_function
import pickle
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import Flow
from google.auth.transport.requests import Request
import pyotherside
import os
import httplib2
import socket
import io
import shutil
from googleapiclient.http import MediaIoBaseDownload
import re
import header
import hashlib


socket.setdefaulttimeout = 5

#Fix for ipv6 hanging on googleapis.com

old_getaddrinfo = socket.getaddrinfo
def new_getaddrinfo(*args, **kwargs):
    responses = old_getaddrinfo(*args, **kwargs)
    return [response
            for response in responses
            if response[0] == socket.AF_INET]
socket.getaddrinfo = new_getaddrinfo

#END

class Operations:

    def __init__(self):

        self.creds = None
        self.main_path = header.MAIN_PATH
        self.config_path = header.CONFIG_PATH
        self.token_file = header.TOKEN_FILE
        self.config_file = header.CONFIG_FILE
        self.token = str(self.config_path + self.token_file)
        self.client_id_file = header.CLIENT_ID_FILE
        self.client_id = str(self.main_path + self.client_id_file)
        self.config = str(self.config_path + self.config_file)
        self.flow = ''
        self.service = ''
        self.download_path = header.DOWNLOAD_PATH
        self.defualt_config = header.DEFAULT_CONFIG
        self.service_search_fields = header.SERVICE_SEARCH_FIELDS
        self.google_mime_types_convert = header.GOOGLE_MIME_TYPES_CONVERT

    def pathChecks(self, path):

        '''
            path: list header._PATH

            return: IO files in path
        '''
        for i in path:
            if os.path.exists(i):
                print('found', i)
                pass
            else:
                os.makedirs(os.path.dirname(i), exist_ok=True)
                try:
                    os.mknod(i)
                    os.chmod(i, 0o666)
                except:
                    pass
                print('created', i)

    def createConfigBody(self):

        with open(self.config, 'w') as configs:
            configs.write(self.defualt_config)
            configs.flush()
            configs.close()

    def configParser(self, config):

        '''
            config: str config name e.g: iconSet=[silicaIconSet], iconSet == name

            return: str config value e.g: iconSet=[silicaIconSet], silicaIconSet == value
        '''

        value = r"^"+config+"=\[(.*?)\]"

        configFile = open(self.config, 'r')
        matches = re.finditer(value, configFile.read(), re.MULTILINE)
        configFile.flush()
        configFile.close()
        for matchNum, match in enumerate(matches, start=1):
            match = match

        for groupNum in range(0, len(match.groups())):
            groupNum = groupNum + 1

        matchCondition = ("{group}".format(group = match.group(groupNum)))

        return matchCondition

    def configWriter(self, configName, value):

        '''
            configName: str config name e.g: iconSet=[silicaIconSet], iconSet == name

            value: str config value e.g: iconSet=[silicaIconSet], silicaIconSet == value

            return: IO write new value
        '''

        with open(self.config, 'r+') as config:
            configFile = config.read()
            replaceString = re.sub(api.configParser(configName), value, configFile)
            config.seek(0)
            config.write(replaceString)
            config.truncate()

    def configBooleanIconChange(self, checked):

        '''
            checked: bool

            return: bool

            TODO: Rethink this!!!
        '''

        currentConfig = self.configParser('iconSet')

        if checked:
            print(checked, 'googleIcons')
            self.configWriter('iconSet', 'googleDriveIconSet')
            pyotherside.send('configBoolean', True)
            return True
        else:
            print(checked, 'silica')
            self.configWriter('iconSet', 'silicaIconSet')
            pyotherside.send('configBoolean', False)
            return False

    def configBooleanIconCheck(self):

        '''
            return: bool

            NOTE: WHY DID I DO THIS????
        '''

        if self.configParser('iconSet') == 'googleDriveIconSet':
            return True
        else:
            return False

    def credentialsCheck(self):

        print('credentialsCheck::starting')

        if not self.creds or not self.creds.valid:
            if self.creds and self.creds.expired \
                and self.creds.refresh_token:
                self.creds.refresh(Request())
            else:
                '''
                pathChecks is done here, this will only run at first launch
                after checking, we set the defaults values programmatically.
                '''
                self.pathChecks([self.config, self.download_path])
                self.createConfigBody()

                flow = Flow.from_client_secrets_file(self.client_id,
                        header.SCOPES, redirect_uri='urn:ietf:wg:oauth:2.0:oob'
                        )
                self.flow = flow

                (auth_url, _) = flow.authorization_url(prompt='consent')

                pyotherside.send('authUrl', str(auth_url))

    def credentialsCheckToken(self):

        if os.path.exists(self.token):
            pyotherside.send('code', 1)
            print('credentialsCheck::tokenFound::%s' % self.token)
            with open(self.token, 'rb') as token:
                self.creds = pickle.load(token)
                print('credentialsCheck::goto::testFunction')
                self.serviceBuild()
        else:
            pyotherside.send('code', 2)

    def processToken(self, code):

        print('processToken::code::%s' % code)

        if not self.creds or not self.creds.valid:
            if self.creds and self.creds.expired and self.creds.refresh_token:
                self.creds.refresh(Request())
            else:
                self.flow.fetch_token(code=code)
                self.creds = self.flow.credentials
            with open(self.token, 'wb') as token:
                print('processToken::pickle::dump::%s' % self.token)
                pickle.dump(self.creds, token)
                print('processToken::pickle::dump::DONE')
                pyotherside.send('status', str('pickled!'))
                pyotherside.send('code', 3)
                self.serviceBuild()
               # pyotherside.send('mover', 2)

    def serviceBuild(self):

        print('serviceBuild::starting')
        print('serviceBuild::serviceBuilding')

        try:
            pyotherside.send('status', str('Buidling service...'))
        except:
            pass
        self.service = build('drive', 'v3', credentials=self.creds, num_retries=10)

        pyotherside.send('mover', 2)

        return

    def listFileService(self, count):

        '''
            count: int pageSzie 

            return: list
        '''

        pyotherside.send('status', str('Fetching test results...'))
        results = self.service.files().list(
            pageSize=int(count), fields=self.service_search_fields).execute()
        items = results.get('files', [])
        print('listFileService::resultsParse::items')
        pyotherside.send('iconParseSetting', self.configBooleanIconCheck())
        pyotherside.send('setIcon', str(self.configParser('iconSet')))
        return items

    def nextListFileService(self, token):

        results = service.files().list(
            pageSize=1000,
            pageToken=token,
            fields="nextPageToken, files(mimeType, name)").execute()
        items = results.get('files', [])

        return items

    def getFileService(self, id):

        '''
            id: document id

            return: file(id)
        '''
        results = self.service.files().get(fileId=id, ).execute()

        return results

    def searchListFileService(self, count, param):

        '''
            count: int pageSzie

            param: str query 

            return: list
        '''
        results = self.service.files().list(
            pageSize=int(count), q=param, fields=self.service_search_fields).execute()
        items = results.get('files', [])
        print('testFunction::resultsParse::items')
        pyotherside.send('iconParseSetting', self.configBooleanIconCheck())
        pyotherside.send('setIcon', str(self.configParser('iconSet')))
        return items

    def download(self, id, md5Checksum, asPdf):

        '''
            id: document id

            asPdf: ignore mimetype and choose PDF instead

            return: file --> header.DOWNLOAD_PATH

            if Google Docs(mimetype);

            return (GOOGLE_MIME_TYPES_CONVERT) --> header.DOWNLOAD_PATH

            TODO: Refactor conditions, download is download

        '''

        file = self.getFileService(id)
        fileName = file['name']
        mimeTypeFromGoogle = file['mimeType']
        print(mimeTypeFromGoogle)

        
        if asPdf:
            fileFormat= ".pdf"
            request = self.service.files().export_media(fileId=id,
                                             mimeType="application/pdf")
        elif mimeTypeFromGoogle in self.google_mime_types_convert:
            downloadMimeType, fileFormat= self.commonMimeType(mimeTypeFromGoogle)
            print('found file')
            request = self.service.files().export_media(fileId=id,
                                             mimeType=downloadMimeType)
        else:
            if '.' in fileName:
                fileFormat = ''
            try:
                fileFormat = file['name'].split('.')[1] #mimeTypeFromGoogle.split('/')[1]
            except:
                fileFormat = ''
            request = self.service.files().get_media(fileId=id)

        # if self.isAscii(fileName):
        #     file_name = self.download_path + u''.join(fileName) + fileFormat
        #     downloadCondition = self.checkPath(file_name, md5Checksum)
        
        file_name = self.download_path + id  + '.' + fileFormat
        downloadCondition = self.checkPath(file_name, md5Checksum)
        
        if downloadCondition:
            pyotherside.send('downloadCondition', True)
            fh = io.BytesIO()
            downloader = MediaIoBaseDownload(fh, request)
            done = False
            while done is False:
                status, done = downloader.next_chunk()
                pyotherside.send('download_status', int(status.progress() * 100))
                pyotherside.send('path', str(file_name))
            fh.seek(0)

            with open(file_name, 'wb') as f:
                shutil.copyfileobj(fh, f, length=131072)
        else:
            pyotherside.send('downloadCondition', False)
            pyotherside.send('download_status', 110)

    def checkPath(self, filePath, md5Checksum):

        '''
            checks if the file exists, and matches checksums

            return True to Download
            return False to Pass

        '''

        if os.path.exists(filePath):
            print("Found File")
            if hashlib.md5(open(filePath,'rb').read()).hexdigest() == md5Checksum:
                print("md5 Checks")
                print(filePath)
                pyotherside.send('path', True)
                return False
            else:
                print("md5 false")
                pyotherside.send('path', False)
                return True
        else:
            print("Need to download")
            pyotherside.send('path', False)
            return True

    def commonMimeType(self, mimeType):
        #I am sure there is a lib for this, until then...manual!
        
        try:
            return self.google_mime_types_convert[mimeType]
        except:
            return (mimeType, mimeType.split('/')[1])

    def isAscii(self, string):
        # Very lazy and very wrong. Should add proper unicode support. --> Todo!
        try:
            string.encode('ascii')
        except UnicodeEncodeError:
            return False
        else:
            return True


api = Operations()

