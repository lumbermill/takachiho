#!/usr/bin/env python3
from __future__ import print_function
import httplib2
import os, re, sys, time, datetime

from apiclient import discovery
from oauth2client import client
from oauth2client import tools
from oauth2client.file import Storage

try:
    import argparse
    p = argparse.ArgumentParser(parents=[tools.argparser])
    p.add_argument("folder",help="Name of the folder on Google Drive")
    p.add_argument("file",help="Path for the picture to post.")
    flags = p.parse_args()
except:
    # TODO: fileパラメタが指定されていない場合、空のディレクトリを作って終了
    # TODO: client_secretが存在しない場合、取得用のURLを出してあげる。
    flags = None

# If modifying these scopes, delete your previously saved credentials
# at ~/.credentials/drive-python-quickstart.json
#SCOPES = 'https://www.googleapis.com/auth/drive.metadata.readonly'
SCOPES = 'https://www.googleapis.com/auth/drive'
BASEDIR = os.path.dirname(os.path.abspath(__file__))
CLIENT_SECRET_FILE = BASEDIR+'/motion-googledrive-secret.json'
APPLICATION_NAME = 'Motion for Google Drive'
RETENTION_DAYS = 30  # Drive上に画像を保持する期間

def get_credentials():
    """Gets valid user credentials from storage.

    If nothing has been stored, or if the stored credentials are invalid,
    the OAuth2 flow is completed to obtain the new credentials.

    Returns:
        Credentials, the obtained credential.
    """
    home_dir = os.path.expanduser('~')
    credential_dir = os.path.join(home_dir, '.credentials')
    if not os.path.exists(credential_dir):
        os.makedirs(credential_dir)
    credential_path = os.path.join(credential_dir,
                                   'motion-googledrive.json')

    store = Storage(credential_path)
    credentials = store.get()
    if not credentials or credentials.invalid:
        flow = client.flow_from_clientsecrets(CLIENT_SECRET_FILE, SCOPES)
        flow.user_agent = APPLICATION_NAME
        if flags:
            credentials = tools.run_flow(flow, store, flags)
        else: # Needed only for compatibility with Python 2.6
            credentials = tools.run(flow, store)
        print('Storing credentials to ' + credential_path)
    return credentials

def timestamp(filename):
    """
    Get timestamp from given filename(xxx-yyyymmddhhmmss.jpg).
    Not used for now.
    """
    t = re.split('[-.]',filename)[1]
    t = time.strptime(t,"%Y%m%d%H%M%S")
    # TODO: How to take care of timezone?
    return time.strftime("%Y-%m-%dT%H:%M:%S%z",t)

def main():
    """
    """
    credentials = get_credentials()
    http = credentials.authorize(httplib2.Http())
    service = discovery.build('drive', 'v3', http=http)
    filepath = flags.file # saved file name
    foldername = flags.folder
    filename = os.path.basename(filepath)
    delete_img = 'false'
    print("folder: %s" % (foldername))

    # Checks if the folder already exists and gets the ID.
    items = service.files().list(q="name = '%s'" % (foldername)).execute().get('files')
    if len(items) == 0:
        body = {'name': foldername,'mimeType': "application/vnd.google-apps.folder"}
        fid = service.files().create(body=body).execute().get('id')
    else:
        fid = items[0]['id']

    if filepath == 'init' or filepath == '%f':
        print("Folder was created.")
    elif filepath == '%d':
        # Search and delete old pictures.
        border = (datetime.date.today() - datetime.timedelta(RETENTION_DAYS)).strftime("%Y-%m-%d")
        q4delete = "'%s' in parents and mimeType = 'image/jpeg' and starred != true and modifiedTime < '%sT00:00:00+09:00'" % (fid,border)
        items = service.files().list(q=q4delete).execute().get('files')
        if len(items) > 0:
            print("%d files(older than %s and not starred) are going to be trashed." % (len(items),border))
            for i in items:
                print("  %s" % (i['name']))
                service.files().delete(fileId=i['id']).execute()
        else:
            print("Nothing to be deleted.")
    else:
        # Sends the picture.
        print("local: %s" % (filepath))
        print("remote: %s/%s" % (foldername,filename))
        body = { 'name': filename, 'parents':[fid] }
        service.files().create(media_body=filepath, body=body).execute()
        if delete_img == 'true':
            print(filename+" was deleted on local.")
            os.remove(filepath)

if __name__ == '__main__':
    main()
