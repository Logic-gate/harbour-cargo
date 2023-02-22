import os

HOME = os.environ['HOME']

MAIN_PATH = '/usr/share/harbour-cargo/qml/creds/'
CONFIG_PATH = HOME + '/.config/harbour-cargo/'
TOKEN_FILE = 'token.pickle'
CLIENT_ID_FILE = 'client_id.json'
CONFIG_FILE = 'config'
DOWNLOAD_PATH = HOME + '/Downloads/Cargo/'
HOST = 'localhost'
PORT = 8098
SUCCESS_MESSAGE = 'You can close this page now!...'
DEFAULT_CONFIG = "iconSet=[silicaIconSet]\npageSize=[25]"
PATCH_PATH = "/usr/share//harbour-cargo/qml/python/patches/"
JOLLA_GALLERY_PATH = '/usr/share/jolla-gallery/'
GALLERY_QML_256 = '7ed28197af82d58d0fb3d4599db9ba08b15556efde7f8e4c85ac91304671997e'
GALLERY_START_PAGE_256 = '83fac1158194a85917605d18fbb3a458677fb4e978615b3c4e85b097a0c79519'

SCOPES = [
    'https://www.googleapis.com/auth/drive.metadata.readonly',
    'https://www.googleapis.com/auth/drive',
    'https://www.googleapis.com/auth/drive.appdata',
    'https://www.googleapis.com/auth/drive.file',
    'https://www.googleapis.com/auth/drive.metadata',
    'https://www.googleapis.com/auth/drive.readonly',
    'https://www.googleapis.com/auth/drive.photos.readonly'
    ]


SERVICE_SEARCH_FIELDS = "nextPageToken, files(*)"


GOOGLE_MIME_TYPES_CONVERT = {'application/vnd.google-apps.spreadsheet': 
                ('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', '.xlsx'),
       	'application/vnd.google-apps.document': 
                ('application/vnd.openxmlformats-officedocument.wordprocessingml.document', '.docx'),
        'application/vnd.google-apps.presentation':
            ('application/pdf', '.pdf')
        }
