from selenium import webdriver
from pyvirtualdisplay import Display
from datetime import datetime
import time

class SpeedIndicator:
    NETWORK_SPEEDS = "Network Speeds"
    UPLOAD = "upload"
    DOWNLOAD = "download"

    def __init__(self, driver):
        self.driver = driver
        self.speedMap = {}
        self.date = str(datetime.now())

    def is_updating(self, prefix):
        class_name = prefix + "-speed";
        speed = self.get_element_text(class_name)
        print "isUpdating: {}".format(speed)
        if "0" == speed:
            return True
        else:
            self.speedMap[class_name] = speed
            return False

    def wait_until_done(self):
        index = 0
        while self.is_updating(self.DOWNLOAD) and index < 60:
            time.sleep(1)
            index += 1

        index = 0
        while self.is_updating(self.UPLOAD) and index < 60:
            time.sleep(1)
            index += 1

    def get_element_text(self, id):
        print "get_element_text: {}".format(id)
        page_source = self.driver.page_source
        if id not in page_source:
            print "Could not find {} in page source".format(id)
            return "0"
        text = self.driver.execute_script("return document.getElementsByClassName('" + id + "')[0].innerHTML;")
        if not text:
            return "0"
        else:
            return text

    def get_value(self, prefix):
        class_name = prefix + "-speed";
        if not class_name in self.speedMap:
            self.speedMap[class_name] = 0
        return self.speedMap[class_name]

    def get_complete_value(self, prefix):
        int_id = prefix + "SpeedInt";
        dec_id = prefix + "SpeedDec";
        return "{},{}".format(self.get_value(int_id), self.get_value(dec_id))

NETWORK_SPEED_CSV = "network-speed.csv"
print "Starting Speed test..."
display = Display(visible=0, size=(800, 600))
display.start()

browser = webdriver.Firefox()
browser.get("http://beta.speedtest.net/")
print browser.title
# startMeasure = driver.find_element_by_class_name("start-text")
print "Clicking"
browser.execute_script("document.getElementsByClassName('start-text')[0].click();")
speedIndicator = SpeedIndicator(browser)
print "Waiting until done"
try:
    speedIndicator.wait_until_done()
    with open(NETWORK_SPEED_CSV, "a") as myfile:
        myfile.write("{},{},{}\n".format(speedIndicator.date,
                                       speedIndicator.get_value(SpeedIndicator.DOWNLOAD),
                                       speedIndicator.get_value(SpeedIndicator.UPLOAD)))
finally:
    browser.quit()
    display.stop()
    print "Speed test done."
