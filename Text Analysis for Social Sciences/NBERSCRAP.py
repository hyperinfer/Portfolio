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
from selenium.common.exceptions import TimeoutException, WebDriverException

import time
import pandas as pd

#Requires Java SE
import tika
from tika import parser # pip install tika

import json
#--#

#Change CWD to Webdriver Location
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
# Testurl should return 35 papers on two pages #
url = "https://www.nber.org/papers?endDate=2021-11-06T00%3A00%3A00%2B01%3A00&page=1&perPage=20&q=&sortBy=public_date&startDate=2021-11-01T00%3A00%3A00%2B01%3A00#listing-77041"
wd.get(url)

#Outputlist
pdfs = []

tika.initVM()
#--#

#Most print()-functions are for selfassesment and can be deleted or put as comment if not needed!

#Note: The NBER website does not seem to approve large-scale scraping attempts and denies page access after about two iterations. 
#However, if this is done within an academic network (we use the VPN network of the University of Hamburg) this is no longer a problem!

while True:
    #Get the current overviewpage and list all links
    links = []
    head = wd.find_elements(By.CSS_SELECTOR,"a[class='paper-card__paper_number']")
    for j in list(range(0,(len(head)))): links.append(str(head[j].get_attribute("href")))
    print(links)
    #Start one-by-one extraction
    for i in list(range(0,len(links))):
        wd.get(links[i])
        wd.implicitly_wait(1)
        pdf = wd.find_element(By.CSS_SELECTOR,"a[class='btn btn--primary btn--black']")
        print(pdf.get_attribute("href"))
        pdfs.append(parser.from_file(str(pdf.get_attribute("href")),service="all"))    
    #Navigate back to overviewpage 
    wd.get(url)
    #And try to navigate to the next site
    try:
        wd.find_element(By.CSS_SELECTOR,"button[class='btn btn--link pager__next']").click()
        url = str(wd.current_url)
        #For some reason necessary to avoid StaleElementReference
        wd.get(url)
        wd.implicitly_wait(1)
        print(url)
    except (TimeoutException, WebDriverException):
        print("Finished")
        break
    
wd.quit()

#Export list to a JSON-File
file = open("NBERpdfs.json","w+")
json.dump(pdfs,file)
file.close()
