from datetime import datetime
from meteostat import Stations, Monthly, Point
import pandas as pd

start = datetime(2022,1,1)
end = datetime(2025,1,1)

location = Point(46.63179124070864, 27.729613366249627,109)

data = Monthly(location, start,end)
data = data.fetch()

data.to_csv("weatherData.csv", index=True)