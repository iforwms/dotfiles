from bs4 import BeautifulSoup
import requests

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
name = soup.find(class_ = 'post-title').text
intro = body.find_all('p')
images = body.find_all('img')
image_anchors = [img.parent.attrs['href'] for img in images]
effect_type = soup.find(class_ = 'post-labels').find('a').text

print("Name:", name)
print("Intro text:", intro)
print("Images:", image_anchors)
print("Effect type:", effect_type)

# 1. Make directory
# 2. Save text
# 3. Download images

quit()

print(soup)

