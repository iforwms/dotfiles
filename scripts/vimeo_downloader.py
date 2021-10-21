#!/usr/bin/env python3

from bs4 import BeautifulSoup
import requests
import json
from vimeo_downloader import Vimeo

cookies = """
CraftSessionId=f04e45a01dc0b97ae5e58f682057a5fe; amp_52ee11=dmDRRCxT3oWifIKy9fWUeF.NzY4MTc=..1fbk5od61.1fbkamaal.0.1.1; f9c0793a124496fe692326d1424a7937username=ac624d59195480571f5d33395ac693c0014934f7s%3A60%3A%2293b0f9e4bb1f0d53e82827c823621bbbdd4f60ccczo3OiJpZm9yd21zIjs%3D%22%3B; sbl_ips_craft_user=9abe33cf6067001a6b152c60dec3a990; sbl_ips_user_id=17414; YII_CSRF_TOKEN=104cefaf3120e1edc7de8a12b703c6ded0ffe45bs%3A81%3A%22Jfau%7EqH9OT88d0fkjbkpkjfpfPkRz9I8m0f%7EcYsL%7Ce7493c80fbcc461f2dcaabaa9a224c67b17e1232%22%3B; amp_f846e7_scottsbasslessons.com=dmDRRCxT3oWifIKy9fWUeF.NzY4MTc=..1fbk5ns6e.1fbkamatp.m.o.1e; intercom-session-mgeih8fu=K2kwN24yT1haakE1WHZvd2lLUlZibDhBLzZ5SzFPYU1rTURZekJXeUFYbVgrcFJnTktIUkRwZzN6SDkzenBMYy0tK3pBNnRIVG5veUlhL3ZPQ0k5blNIQT09--61fc129efefc107e529672c4f0c918b7c38dea68; f9c0793a124496fe692326d1424a7937=f1cd3d876fd8a994746226185e9c69e661e9e4eds%3A344%3A%2213c185898760b442141727b826d9bdb89a401aebYTo2OntpOjA7czo3OiJpZm9yd21zIjtpOjE7czozMjoiVmRFQ0thbTVNc2pjT2tWTHU3dlVuT1RNWlFJZkpic0wiO2k6MjtzOjM2OiI0ZDk5NDg0ZS02ZTVkLTRhMTEtOWFmMS01NTU1OTZiNjVmZDUiO2k6MztpOjE7aTo0O3M6ODI6Ik1vemlsbGEvNS4wIChNYWNpbnRvc2g7IEludGVsIE1hYyBPUyBYIDEwLjE1OyBydjo5MC4wKSBHZWNrby8yMDEwMDEwMSBGaXJlZm94LzkwLjAiO2k6NTthOjA6e319%22%3B
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
