#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
A simple python3 script to grab weather data from openweathermap.org
You will need an api key (see http://openweathermap.org/appid)
To find your city code see http://openweathermap.org/find?q=

Additional requirements: python-dateutil (sudo pip3 install python-dateutil)

Author CISMaleScumLord
Licence GPL V3
Copyright February 2018
"""

import os.path
import urllib.request
import xml.etree.ElementTree as elementTree
from datetime import datetime
from dateutil.parser import parse

from weather import (icons, CurrentWeather)

# Script configuration - can be changed

CITY_CODE = 'ENTER_YOUR_CITY_CODE_HERE'
API_KEY = 'ENTER_YOUR API_KEY_HERE'
UNITS = 'metric'
ENCODING = 'utf-8'

# Do not change below here unless you are sure what you are doing

CURRENT_WEATHER_URL = 'http://api.openweathermap.org/data/2.5/weather?id=' + CITY_CODE + '&APPID=' + API_KEY + '&mode=xml&units=' + UNITS
FORECAST_WEATHER_URL = 'http://api.openweathermap.org/data/2.5/forecast?id=' + CITY_CODE + '&APPID=' + API_KEY + '&mode=xml&units=' + UNITS

def get_weather_data(data_to_fetch):

    try:
        response = urllib.request.urlopen(data_to_fetch)
        data = response.read().decode(ENCODING)
        return data
    except Exception as e:
        print(str(e))

def parse_current_weather(current_weather):

    current = elementTree.fromstring(current_weather)
    current_data = CurrentWeather(
        current.find('city').get('name'),
        current.find('city').find('sun').get('rise'),
        current.find('city').find('sun').get('set'),
        current.find('temperature').get('value'),
        current.find('temperature').get('min'),
        current.find('temperature').get('max'),
        current.find('temperature').get('unit'),
        current.find('pressure').get('value'),
        current.find('pressure').get('unit'),
        current.find('wind').find('speed').get('value'),
        current.find('wind').find('direction').get('name'),
        current.find('weather').get('number'),
    )

    return current_data

def is_day(sunrise, sunset):

    now = datetime.now()
    return now >= parse(sunrise) and now <= parse(sunset)

def calculate_wind_speed(response_speed):

    if UNITS == 'imperial':
        return response_speed + 'MPH'
    else:
        mps = float(response_speed)
        kmh = mps * 18 / 5
        speed = '{:0.0f}{}'.format(kmh, 'KPH')
        return speed

def write_conky_file(current_data):

    temperature_units = {'metric':'ºC', 'imperial':'ºF'}
    speed = calculate_wind_speed(current_data.wind_speed)

    s = '${{voffset -24}}${{alignr}}{}\n'.format(current_data.city)
    if is_day(current_data.sunrise, current_data.sunset):
        s += '${{voffset 9}}${{color2}}${{font ConkyWeather:size=60}}{}${{font}}${{color}}\n'.format(icons[int(current_data.weather)][0])
    else:
        s += '${{voffset 9}}${{color2}}${{font ConkyWeather:size=60}}{}${{font}}${{color}}\n'.format(icons[int(current_data.weather)][1])

    s += '${{voffset -72}}${{offset 90}}Temperature:${{alignr}}{}{}\n'.format(current_data.temperature, temperature_units.get(current_data.temperature_unit))
    s += '${{offset 90}}Wind:${{alignr}}{}\n'.format(speed)
    s += '${{alignr}}{}\n'.format(current_data.wind_direction_name)
    s += '${{offset 90}}Pressure:${{alignr}}{}{}\n'.format(current_data.pressure, current_data.pressure_unit)
    print(s)

if __name__ == '__main__':
    current_weather = get_weather_data(CURRENT_WEATHER_URL)
    forecast_weather = get_weather_data(FORECAST_WEATHER_URL)
    current_data = parse_current_weather(current_weather)
    write_conky_file(current_data)
