#!/usr/bin/env python3

from bs4 import BeautifulSoup
import requests
import json
from vimeo_downloader import Vimeo

cookies = """
***REDACTED***
         """.strip()

def getHTML(url):
    response = requests.get(url)
    return response.text

def getCourseData(html):
    soup = BeautifulSoup(html, 'html.parser')
    course_detail = soup.find('course-detail')
    json_string = course_detail[':init-course-modules']
    return json.loads(json_string)

def downloadFiles(data):
    for object in data:
        item = object['items'][0]
        url = item['url']
        text = item['text']
        video_id = item['video'].rsplit('/', 1)[-1]
        video = 'https://vimeo.com/' + video_id
        filepath = url.replace('http://scottsbasslessons.com/courses/', '') + '_' + text.replace(" ", "-").lower() + '.mp4'
        # downloadFile(video_id, filepath)
        downloadFile(item['video'], filepath)

def downloadFile(url, filepath):
    basepath="/Users/ifor/Downloads/"
    print("Downloading %s to %s" % (url, basepath + filepath))
    # v = Vimeo.from_video_id(video_id=url, cookies=cookies)
    # best_stream = v.best_stream
    # title = best_stream.title
    # download_url = best_stream.direct_url
    # best_stream.download() # to download video
    v = Vimeo(url=url, cookies=cookies, embedded_on='https://scottsbasslessons.com/courses/the-essential-guide-to-bass-effects-with-steve-lawson/course-trailer')
    print(v.metadata)
    exit()

with open("index.html") as fp:
    data = getCourseData(fp)
downloadFiles(data)

url = 'https://scottsbasslessons.com/courses/the-essential-guide-to-bass-effects-with-steve-lawson/course-trailer'
html = getHTML(url)
data = getCourseData(html)
downloadFiles(data)
