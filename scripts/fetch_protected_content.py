from bs4 import BeautifulSoup
import requests

def fetch(
        login_url,
        fetch_url,
        login,
        password,
        login_input_name='login',
        password_input_name='password',
        csrf_token_name=None
):
    headers = {
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:55.0) Gecko/20100101 Firefox/55.0',
    }

    with requests.Session() as s:
        payload = {
            login_input_name: login,
            password_input_name: password,
        }

        if csrf_token_name is not None:
            print('[fetch_protected_content] Fetching CSRF token from login page...')
            req = s.get(login_url, headers=headers).text
            html = BeautifulSoup(req, "html.parser")
            csrf = html.find('input', {'name': csrf_token_name}).attrs['value']
            payload[csrf_token_name] = csrf

        print('[fetch_protected_content] Logging in...')
        res = s.post(login_url, headers=headers, data=payload)

        print(f'Fetching {fetch_url}')
        r = s.get(fetch_url, headers=headers)
        return BeautifulSoup(r.content, "html.parser")
