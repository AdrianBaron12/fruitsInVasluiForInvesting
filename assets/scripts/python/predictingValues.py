import pandas as pd
import numpy as np

df = pd.read_csv('data_formatted.csv')

df['Period_dt'] = pd.to_datetime(df['Period'], format='%B %Y')

#df['Price'] = df['Price'].replace(r'^\s*$', np.nan, regex=True)

all_periods = pd.date_range(start='2022-01-01', end='2024-12-01', freq='MS')  # 'MS' = month start


def reindex_group(group):

    product, locality = group.name

    county = group['County'].iloc[0] if 'County' in group.columns else None
    unit = group['Unit'].iloc[0] if 'Unit' in group.columns else None
    group = group.set_index('Period_dt')
    group = group.reindex(all_periods)
    group['Product'] = product
    group['Locality'] = locality
    if county is not None:
        group['County'] = county
    if unit is not None:
        group['Unit'] = unit
    group['Period'] = group.index.strftime('%B %Y')
    return group.reset_index(drop=False).rename(columns={'index': 'Period_dt'})


df_complete = df.groupby(['Product', 'Locality']).apply(reindex_group, include_groups=False).reset_index(drop=True)



df_complete.to_csv('data_complete_periods.csv', index=False)