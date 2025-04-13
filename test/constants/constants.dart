const Map<String, Object> mockResponse = {
  'result': 'success',
  'documentation': 'https://www.exchangerate-api.com/docs',
  'terms_of_use': 'https://www.exchangerate-api.com/terms',
  'time_last_update_unix': 1627776001,
  'time_last_update_utc': 'Sun, 01 Aug 2021 00:00:01 +0000',
  'time_next_update_unix': 1627862401,
  'time_next_update_utc': 'Mon, 02 Aug 2021 00:00:01 +0000',
  'base_code': 'USD',
  'conversion_rates': {'USD': 1, 'EUR': 0.84, 'GBP': 0.72, 'JPY': 109.72},
};

const Map<String, Object> mockCodesResponse = {
  'result': 'success',
  'documentation': 'https://www.exchangerate-api.com/docs',
  'terms_of_use': 'https://www.exchangerate-api.com/terms',
  'supported_codes': [
    ['USD', 'United States Dollar'],
    ['EUR', 'Euro'],
    ['GBP', 'British Pound Sterling'],
    ['JPY', 'Japanese Yen'],
  ],
};
