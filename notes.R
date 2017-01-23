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

# 4. JSON-files ----

install.packages("jsonlite")
library(jsonlite)
jsonData <- fromJSON("https://api.github.com/users/jtleek/repos")
names(jsonData)
class(jsonData)

names(jsonData$owner)

jsonData$name

jsonData$owner$login

myjson <- toJSON(iris, pretty=TRUE)
cat(myjson)


iris2 <- fromJSON(myjson)
head(iris2)

head(iris)
identical(iris, iris2)
#Ups ^^

# 5. Working with "data.table"

library(data.table)

#seems to be much easier to use than the standard data.frame

DF <- data.frame(x=rnorm(9),y=rep(c("a","b","c"),each=3),z=rnorm(9))
head(DF,3)

DF1 <- data.table(x=rnorm(9),y=rep(c("a","b","c"),each=3),z=rnorm(9))
head(DF1,3)
DF1

class(DF)
class(DF1)
#[1] "data.table" "data.frame" #2 classes?

identical(DF, DF1)
#false, at least it looks the same

tables()

# a little subsetting
DF1[2,] #only row 2

DF1[DF1$y=="a",]# all rows where y=a

DF1[c(2,3)] # row 2 and 3 shown, no need to set ","

DF1[,c(2,3)] # columns 2 and 3
DF[,c(2,3)] # same

DF1[,list(mean(x),sum(z))]
# V1        V2
# 1: 0.1362041 -1.790826

DF[,list(mean(x),sum(z))]
#Error in mean(x) : object 'x' not found

DF1[,table(y)]
#y
#a b c 
#3 3 3 

DF[,table(y)]
#Error in table(y) : object 'y' not found

DF1[,w:=z^2]
head(DF1,1) # so we added a new variable 'w'


DF1[,m:= {tmp <- (x+z); log2(tmp+5)}] #several operations processed at once
head(DF1)

DF1[,a:= x > 0] #adding a logical variable
head(DF1)

DF1[,b:= mean(x+w), by=a] #Hier wird dann unterschieden
# zwischen den Gruppen TRUE und FALSE

set.seed(123);
DT <- data.table(x=sample(letters[1:3], 1E5, TRUE))

DT[, .N, by=x] #Mit ".N" gezaehlt, mit "by" gruppiert
head(DT)

DT <- data.table(x=rep(c("a","b","c"),each=100), y=rnorm(300))
setkey(DT, x)
DT['a']
head(DT)
