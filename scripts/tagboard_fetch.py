from bs4 import BeautifulSoup
import requests, urllib.request

debug = True
fetch_url = 'https://tagboardeffects.blogspot.com/2023/01/t-rex-mudhoney-v11.html'
test_file = "/Users/ifor/Downloads/Guitar FX Layouts T-Rex Mudhoney V1.1.html"

headers = {
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:55.0) Gecko/20100101 Firefox/55.0',
}

if debug is True:
    print(f'[INFO] Opening {test_file}')
    file = open(test_file, "r")
    soup = BeautifulSoup(file, "html.parser")
else:
    print(f'[INFO] Fetching {fetch_url}')
    r = requests.get(fetch_url, headers=headers)
    soup = BeautifulSoup(r.content, "html.parser")

body = soup.find(class_ = 'post-body')
images = body.find_all('img')

name = soup.find(class_ = 'post-title').text.strip()
intro = body.find_all('p')
image_anchors = [img.parent.attrs['href'] for img in images]
effect_type = soup.find(class_ = 'post-labels').find('a').text

print("Name:", name)
print("Effect type:", effect_type)
print("Intro text:", intro)
print("Images:", image_anchors)

print(f'{name} | {effect_type}')

for url in image_anchors:
    print(url)
    urllib.request.urlretrieve(url, 'abc')

# 1. Make directory
# 2. Save text

quit()

