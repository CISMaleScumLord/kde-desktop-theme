#!/usr/bin/env python3

"""
Icons to weather font for conky_weather.py
Structure to be used in conky_weather.py
Modularised only to keep the main script shorter

Author CISMaleScumLord
Licence GPL V3
Copyright February 2018
"""

from collections import defaultdict
from collections import namedtuple

icons = defaultdict(list)
icons[200] = ['k', 'K', 'thunderstorm with light rain']
icons[201] = ['l', 'l', 'thunderstorm with rain']
icons[202] = ['m', 'm', 'thunderstorm with heavy rain']
icons[210] = ['l', 'l', 'light thunderstorm']
icons[211] = ['l', 'l', 'thunderstorm']
icons[212] = ['n', 'n', 'heavy thunderstorm']
icons[221] = ['n', 'n', 'ragged thunderstorm']
icons[230] = ['l', 'l', 'thunderstorm with light drizzle']
icons[231] = ['m', 'm', 'thunderstorm with drizzle']
icons[232] = ['m', 'm', 'thunderstorm with heavy drizzle']
icons[300] = ['g', 'G', 'light intensity drizzle']
icons[301] = ['s', 's', 'drizzle']
icons[302] = ['t', 't', 'heavy intensity drizzle']
icons[310] = ['g', 'G', 'light intensity drizzle rain']
icons[311] = ['h', 'h', 'drizzle rain']
icons[312] = ['i', 'i', 'heavy intensity drizzle rain']
icons[313] = ['j', 'j', 'shower rain and drizzle']
icons[314] = ['j', 'j', 'heavy shower rain and drizzle']
icons[321] = ['j', 'j', 'shower drizzle']
icons[500] = ['g', 'G', 'light rain']
icons[501] = ['h', 'h', 'moderate rain']
icons[502] = ['i', 'i', 'heavy intensity rain']
icons[503] = ['j', 'j', 'very heavy rain']
icons[504] = ['j', 'j', 'extreme rain']
icons[511] = ['x', 'x', 'freezing rain']
icons[520] = ['g', 'G', 'light intensity shower rain']
icons[521] = ['h', 'h', 'shower rain']
icons[522] = ['i', 'i', 'heavy intensity shower rain']
icons[531] = ['j', 'j', 'ragged shower rain']
icons[600] = ['o', 'O', 'light snow']
icons[601] = ['p', 'p', 'snow']
icons[602] = ['q', 'q', 'heavy snow']
icons[611] = ['y', 'y', 'sleet']
icons[612] = ['x', 'x', 'shower sleet']
icons[615] = ['x', 'x', 'light rain and snow']
icons[616] = ['x', 'x', 'rain and snow']
icons[620] = ['x', 'x', 'light shower snow']
icons[621] = ['x', 'x', 'shower snow']
icons[622] = ['x', 'x', 'heavy shower snow']
icons[701] = ['0', '0', 'mist']
icons[711] = ['0', '0', 'smoke']
icons[721] = ['0', '0', 'haze']
icons[731] = ['7', '7', 'sand', 'dust whirls']
icons[741] = ['0', '0', 'fog']
icons[751] = ['7', '7', 'sand']
icons[761] = ['7', '7', 'dust']
icons[762] = ['7', '7', 'volcanic ash']
icons[771] = ['6', '6', 'squalls']
icons[781] = ['1', '1', 'tornado']
icons[800] = ['a', 'A', 'clear sky']
icons[801] = ['b', 'B', 'few clouds']
icons[802] = ['c', 'C', 'scattered clouds']
icons[803] = ['d', 'D', 'broken clouds']
icons[804] = ['e', 'f', 'overcast clouds']
icons[900] = ['1', '1', 'tornado']
icons[901] = ['2', '2', 'tropical storm']
icons[902] = ['3', '3', 'hurricane']
icons[903] = ['4', '4', 'cold']
icons[904] = ['5', '5', 'hot']
icons[905] = ['6', '6', 'windy']
icons[906] = ['u', 'u', 'hail']
icons[951] = ['a', 'A', 'calm']
icons[952] = ['9', '9', 'light breeze']
icons[953] = ['9', '9', 'gentle breeze']
icons[954] = ['9', '9', 'moderate breeze']
icons[955] = ['9', '9', 'fresh breeze']
icons[956] = ['6', '6', 'strong breeze']
icons[957] = ['6', '6', 'high wind', 'near gale']
icons[958] = ['6', '6', 'gale']
icons[959] = ['6', '6', 'severe gale']
icons[960] = ['2', '2', 'storm']
icons[961] = ['3', '3', 'violent storm']
icons[962] = ['4', '4', 'hurricane']

CurrentWeather = namedtuple(
    'CurrentWeather', [
        'city',
        'sunrise',
        'sunset',
        'temperature',
        'temperature_min',
        'temperature_max',
        'temperature_unit',
        'pressure',
        'pressure_unit',
        'wind_speed',
        'wind_direction_name',
        'weather',
    ]
)


