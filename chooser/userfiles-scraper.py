import requests
import json
from bs4 import BeautifulSoup

per_page = 100
url = 'https://www.digitalcombatsimulator.com/en/files/?PER_PAGE=' + str(per_page) + '&PAGEN_1='
data = []
has_next_page = True

# loop through all pages
page = 0
while has_next_page:
    page = page + 1
    print('---------------------------------------------------')
    print(f'Page: {page}' + ' - ' + url + str(page))
    response = requests.get(url + str(page))
    if response.status_code == 200:
        soup = BeautifulSoup(response.content, 'html.parser')
        entries = soup.find_all('div', class_='row file-body')
        
        for entry in entries:

            title = entry.find('h2').text.strip()
            type = entry.find('div', class_='col-xs-3 type').find('a')['href'].split('-')[2].split('/')[0]
            author = entry.find('div', class_='col-xs-3 author').find('a')['href'].split('-')[2].split('/')[0]
            date = entry.find('div', class_='col-xs-3 date').text.strip()[7:]
            description = entry.find('div', class_='row file-preview-text').text.strip()

            game = entry.find_previous_sibling().find_all('span')[0].text.strip()
            unit = entry.find_previous_sibling().find_all('span')[1].text.strip()

            license = entry.find_all('li')[0].text.strip()[9:]
            language = entry.find_all('li')[1].text.strip()[10:]
            size = entry.find_all('li')[2].text.strip()[6:]
            downloaded = entry.find_all('li')[3].text.strip()[12:]
            # 4th li might not exist
            if len(entry.find_all('li')) > 4:
                comments = entry.find_all('li')[4].text.strip()[10:]
            else:
                comments = 0

            tags = entry.find_next_sibling().find_all('a')
            # exclude "Detail" and "Download" tags
            tag_list = []
            for tag in tags:
                if tag.text != 'Detail' and tag.text != 'Download':
                    tag_list.append(tag.text)

            downloadlink = entry.find_next_sibling().find('a', class_='download')['href']

            img = entry.find('a', class_='fancybox')
            if img:
                img = img['href']
            else:
                img = ''

            print(f'Title: {title}')

            data.append({
                'game': game,
                'unit': unit,
                'title': title,
                'type': type,
                'author': author,
                'date': date,
                'description': description,
                'license': license,
                'language': language,
                'size': size,
                'downloaded': downloaded,
                'comments': comments,
                'tags': tag_list,
                'downloadlink': downloadlink,
                'image': img
            })

        next_page = soup.find('a', id='_next_page')
        if next_page:
            has_next_page = True
        else:
            has_next_page = False

        with open('userfiles.json', 'w') as f:
            json.dump(data, f)
