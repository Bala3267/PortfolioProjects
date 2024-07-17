# Install the Packages
install.packages("tidyverse")
install.packages("dplyr")
install.packages("ggplot")
install.packages("lubridate")
install.packages("hms")
install.packages("magrittr")

# Load the Packages
library(tidyverse)
library(dplyr)
library(ggplot2)
library(lubridate)
library(magrittr)
library(hms)

#Read the data set.
#This Data set was downloaded from Maven Analytics data set web site. 

data = read.csv('C:/Users/gst/Downloads/Ms_Office/railway.csv')

head(data)

# View the data in table form
View(data) 

# Checking structure of data 
str(data)

# Checking the dimension of data 
dim(data)


# Data Cleaning and Preprocess
#----------------------------------

# Checking if the data containing any null value
anyNA(data)

# Converting the character value of Date.of.Purchase column into Date value
data$Date.of.Purchase <- as.Date(data$Date.of.Purchase)
data$Date.of.Journey  <- as.Date(data$Date.of.Journey)

# Converting the Departure.Time, Arrival.Time, Actual.Arrival.Time column value into proper time value.
data['Departure.Time'] <- as_hms(data$Departure.Time)
data['Arrival.Time'] <- as_hms(data$Arrival.Time)


# Checking type of the Railcard Type
table(data$Railcard)

# Replace the None value in Railcard column with Adult
data$Railcard  <- replace(data$Railcard, data$Railcard=='None', 'Adult')

# Confirming if the None value are changed to Adult
table(data$Railcard)


# Exploratory Data Analysis
#------------------------------------
#------------------------------------

# Q1) What are the most popular routes?
data %<>% mutate(Routes = paste(data$Departure.Station,data$Arrival.Destination,sep = " to ")) 

most_popular_routes <- data %>% group_by(Routes) %>% summarise(Count = n()) %>% 
                        arrange(desc(Count))

class(most_popular_routes)
# Converting the most_popular_routes list into data frame
most_popular_routes <- as.data.frame(head(most_popular_routes,10))
most_popular_routes

# a) Ploting the top 10 most popular routes by using base R bar plot
bp <-barplot(most_popular_routes$Count[1:10],
             names.arg = NULL,
        col=rainbow(10),xlab = 'Routes',ylab = 'Total count',
        main = 'Top 10 most popular UK - Train Routes ')

#  Adding x axis label on the bar plot
text(bp,par('usr')[3]-0.5,srt=45,
     labels = most_popular_routes$Routes[1:10],
     adj =1,xpd=TRUE,cex = 0.8)



# Creating the same bar plot using ggplot library
ggplot(most_popular_routes,aes(x=Routes,y=Count,fill=Routes))+
  geom_bar(stat='identity',width = 0.8)+
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        legend.position = 'none')+
  geom_text(aes(label = Count), vjust = -0.3, size = 3.5)+
  ggtitle('Top 10 most popular UK - Train Routes ')

#---------------------------------------------------------

# Q2)What are the peak travel times?

data %>% group_by(Departure.Time) %>% summarise(count = n()) %>% 
  arrange(desc(count))

peak_travels_time <-data %>% group_by(hour =strftime(Departure.Time,'%H')) %>% summarise(count=n()) %>% 
                  arrange(desc(count))

peak_travel_bar <- ggplot(peak_travels_time,aes(x=hour,y=count)) + 
                    geom_bar(stat='identity',fill='violet') + 
                    theme_gray(base_size = 14)+
                    xlab('Hours')+ylab('Total Count')+
                    ggtitle('Peak Travel Time')+
  geom_text(aes(label=count),vjust=-0.3,size=3)

peak_travel_bar

# Q3)How does revenue vary by ticket types and classes?
table(data$Ticket.Class)

revenue_by_class <- data %>% group_by(Ticket.Class) %>% summarise(total_revenue=sum(Price))
revenue_by_class

# Converting the revenue value to percentage value for pie chart.
per <- revenue_by_class$total_revenue/sum(revenue_by_class$total_revenue)

revenue_pie <-ggplot(revenue_by_class,aes(x='',y=per,fill=cm.colors(2)))+
              geom_bar(stat = 'identity',width=1)+coord_polar(theta = "y") +
              labs(title = "Top 10 Most Popular UK - Train Routes") +
              theme_void() +theme(legend.position = 'none')+
              geom_text(aes(label =revenue_by_class$Ticket.Class), position = position_stack(vjust = 0.5), size = 3)

revenue_pie
#------------------------------------------------------

# Q4) Which Payment method used most?
most_used_payment_method <-data %>% group_by(Payment.Method) %>% summarise(count=n())  
  
most_used_payment_method_bar <-
barplot(most_used_payment_method$count,names.arg = most_used_payment_method$Payment.Method,
        col=rainbow(3),xlab='Payment Method',ylab='Total Count',
        main = 'Most Used Payment Method',
        ylim = c(0, max(most_used_payment_method$count)+5000))

# Adding data label on the bar plot
text(most_used_payment_method_bar,y=most_used_payment_method$count,
     labels = most_used_payment_method$count,pos=3,cex=0.8)
#-------------------------------------------------------

# Q5) Which purchase type people used the most?

purchase_type <- data %>% group_by(Purchase.Type) %>% summarise(cnt = n())
purchase_type

purchase_type_bar <- barplot(purchase_type$cnt,names.arg = purchase_type$Purchase.Type,
                      col=cm.colors(2),xlab='Purchae Type',ylab='Count',
                      main = 'Purchase Type Count',
                      ylim = c(0,max(purchase_type$cnt) + 10000),cex.names = 0.8)

# Adding data label on the bar plot
text(purchase_type_bar,y=purchase_type$cnt,
     labels = purchase_type$cnt,pos=3, cex=0.8,col='black')

purchase_type_bar

#---------------------------------------------------------------

# 6) Journey Status
journey_status <- data %>% group_by(Journey.Status) %>% summarise(cnt = n())
journey_status

s<-barplot(journey_status$cnt,names.arg = journey_status$Journey.Status,
        col=topo.colors(3),xlab='Journey Status',ylab='Total Count',
        main='Total count of Journey Status',
        ylim= c(0, max(journey_status$cnt) + 10000), cex.names = 0.8)
s

# Adding data label on the bar plot
text(x = s, y = journey_status$cnt, 
     labels = journey_status$cnt, pos = 3, cex = 0.8, col = "black")

# -------------------------------------

# --------Exploratory Data Analysis Completed -----------------