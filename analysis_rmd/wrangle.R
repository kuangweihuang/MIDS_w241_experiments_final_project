library(data.table)
setwd('Documents/MIDS/w241/course_project/')
pre_survey <- read.csv(file = './data/pre_survey_v1.csv', 
                       header = TRUE, 
                       sep = ',', 
                       row.names = 'ResponseId',
                       stringsAsFactors = FALSE)
dt_survey1 <- data.table(pre_survey)
dt_survey1 <- dt_survey1[c(-1,-2),]

setnames(dt_survey1, 
         c('Q10','Q12','Q26','Q9','Q19','Q35','Q2_Id','Q2_Name','Q18',
           'Q32_1','Q32_2','Q32_3','Q32_4','Q32_5','Q32_6','Q32_7','Q32_8'),
         c('email','ios','has_tracker','age','gender','country','screenshot_id','screenshot_file','other_app',
           'excited','happy','peaceful','relaxed','upset','stressed','sad','depressed'))

#Throw away subjects with no screenshot tracker
dt_survey1 <- dt_survey1[grep('Yes', has_tracker)]

#Throw away subjects with no email
dt_survey1 <- dt_survey1[grep('@', email)]

# change gender to dummy variable
dt_survey1[grep('Female', gender), female:=1L]
dt_survey1[grep('Male', gender), female:=0L]
dt_survey1[, gender:=NULL]

# Throw away another irrelevant columns
# dt_survey1[, apply(dt_survey1, 2, function(x) !all(is.na(x)))]

dt_survey1[,`:=`(Status = NULL, IPAddress = NULL, Progress = NULL, Duration..in.seconds. = NULL,
                 LocationLatitude = NULL, LocationLongitude = NULL, RecipientLastName = NULL,
                 RecipientFirstName = NULL, RecipientEmail = NULL, ExternalReference = NULL)]

#Save to csv
write.csv(dt_survey111, file = './data/pre_survey_clean.csv')
