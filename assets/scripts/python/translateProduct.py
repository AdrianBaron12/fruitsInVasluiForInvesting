import pandas as pd


df = pd.read_csv('data_updated.csv',sep=',')

romanian_to_english_product = {
    'Mere': 'Apples',
    'Pere': 'Pears',
    'Piersici': 'Peaches',
    'Caise': 'Apricots',
    'Cirese': 'Cherries',
    'Visine': 'Sour Cherries',
    'Prune': 'Plums',
    'Nuci': 'Nuts',
    'Capsuni': 'Strawberries',
    'Struguri de masa': 'Grapes'
}

df['Product'] = df['Product'].replace(romanian_to_english_product)

print(df['Product'].unique())

df.to_csv('data_updated.csv', index=False)
