# -*- coding: utf-8 -*-
"""
Created on Wed Nov 10 12:20:42 2021

@author: Felix
"""

#NBER Webscraping

# Packages #
import os
import requests

from bs4 import BeautifulSoup

import selenium
from selenium.webdriver.common.by import By
from selenium import webdriver

import time
import pandas as pd

#Requires Java SE
import tika
from tika import parser # pip install tika
#--#

print(os.getcwd())
os.chdir("C:/Users/Felix/Documents/Python_Scripts")
print(os.getcwd())

# set options #
options = webdriver.ChromeOptions()
options.add_argument('--headless')
options.add_argument('--no-sandbox')
options.add_argument('--disable-dev-shm-usage')


wd = webdriver.Chrome(options=options)
#--#

# Start at the first page and setup the needed output lists #
url = "https://www.nber.org/papers?facet=topics%3AFinancial%20Markets&facet=topics%3AFinancial%20Economics&page=1&perPage=100&sortBy=public_date#listing-77041"
wd.get(url)

pdfs = []

tika.initVM()
#--#

while True:
    #Get the current overviewpage and list all links
    links = []
    head = wd.find_elements_by_css_selector(By.CSS_SELECTOR,"div.digest-card__title a")
    for i in list(range(0,(len(head)))): links.append(str(head[i].get_attribute("href")))
    print(links)
    
    #Start one-by-one extraction
    for i in list(range(0,len(links))):
        wd.get(links[i])
        pdf = wd.find_elements(By.CSS_SELECTOR,"div.gate-band__links a")
        print(pdf.get_attribute("href"))
        pdfs.append(parser.from_file(str(pdf.get_attribute("href")),service="text"))    
    
    wd.get(url)
    try:
        wd.find_elements(By.CSS_SELECTOR,"button[class='btn btn--link pager__next']").click()
        url = str(print(wd.current_url))     
        
wd.find_element(By.CSS_SELECTOR,)