setwd("D:/Dropbox/01_Studium2015/Data Science/I Januar/03_Getting and Cleaning Data/Get_Clean_Data_R")


# 1. CSV-files ----

# Downloading files ----

if (!file.exists("data")) {dir.create("data")}

fileURL <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"

download.file(fileURL, destfile = "./data/cameras.csv")

list.files("data/")
#[1] "cameras.csv"

dateDownloaded <- date()
dateDownloaded
#[1] "Mon Jan 16 11:19:41 2017"


# Reading local files ----

cameraData <- read.table("data/cameras.csv", sep = ",", header = TRUE)
head(cameraData)


# 2. Xlsx-files ----

# Downloading files ----

fileURL <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.xlsx?accessType=DOWNLOAD"

download.file(fileURL, destfile = "./data/cameras.xlsx")

# Well, seems like the xlsx-version is not longer available

# 3. XML-files ----

install.packages("XML")
library(XML)

fileURL <- "http://www.w3schools.com/xml/simple.xml"

doc <- xmlTreeParse(fileURL,useInternal=TRUE)
rootNode <- xmlRoot(doc)
xmlName(rootNode)
names(rootNode)

rootNode[[1]]

rootNode[[1]][[1]]

xmlSApply(rootNode, xmlValue)

# Nochmal lesen: http://www.stat.berkeley.edu/~statcur/Workshop2/Presentations/XML.pdf

xpathSApply(rootNode,"//name",xmlValue)

fileUrl <- "http://espn.go.com/nfl/team/_/name/bal/baltimore-ravens"
doc <- htmlTreeParse(fileUrl,useInternal=TRUE)
scores <- xpathSApply(doc,"//div[@class='score']",xmlValue)
teams <- xpathSApply(doc,"//div[@class='game-info']",xmlValue)
scores
teams

# Some more xml tutorials for web scraping can be found at:
# http://www.omegahat.org/RSXML/shortIntro.pdf
# http://www.omegahat.org/RSXML/Tour.pdf
# http://www.stat.berkeley.edu/%7Estatcur/Workshop2/Presentations/XML.pdf
