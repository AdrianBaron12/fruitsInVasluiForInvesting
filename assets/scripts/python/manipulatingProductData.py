import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

df = pd.read_csv('data_english.csv')

"""df.rename(columns={
    'Nomenclatorul produselor agricole vandute in pietele agroalimentare': 'Product',
    ' Judete': 'County',
    ' Localitati': 'Locality',
    ' Perioade': 'Period',
    ' UM: Unitati de masura': 'Unit',
    ' Valoare': 'Price'
}, inplace = True)"""

#Check for blanks in headers
df.rename(columns={
    ' Localitati ':'Locality'
}, inplace=True)

print(df.columns)

df['Locality']=df['Locality'].replace({
    ' 161945 MUNICIPIUL VASLUI': 'VASLUI',
    ' 161794 MUNICIPIUL BARLAD': 'BARLAD'
})

print(df['Locality'].unique())

romanian_to_english = {
    'ianuarie': 'January',
    'februarie': 'February',
    'martie': 'March',
    'aprilie': 'April',
    'mai': 'May',
    'iunie': 'June',
    'iulie': 'July',
    'august': 'August',
    'septembrie': 'September',
    'octombrie': 'October',
    'noiembrie': 'November',
    'decembrie': 'December'

}

def translate_date(dateStr):
    dateStr = dateStr.strip()
    parts = dateStr.split()
    if len(parts) < 3:
        return dateStr
    month_romanian = parts[1].lower()
    year = parts[2]
    englishMonth = romanian_to_english.get(month_romanian,month_romanian)
    return f"{englishMonth} {year}"

df = pd.read_csv('data_updated.csv')

df['Period'] = df['Period'].apply(translate_date)

df.to_csv('data_updated.csv',index=False)