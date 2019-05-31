library(data.table)
setwd('/Users/temp/Documents/MIDS/w241/course_project/W241_Course_Project')
#read in randomization schedule
rand_sched <- read.csv('data/subjects_post_rand_ass_20190327.csv', header = TRUE, sep = ',', stringsAsFactors = FALSE)
dt_rand_sched <- data.table(rand_sched)
dt_rand_sched <- dt_rand_sched[,.(Email, Experiment_App, Treat, Mobile_OS, Name, Age, Gender, Country)]
#read in response data
response_day1 <- read.csv('data/survey_response/response_day1.csv', header = TRUE, sep = ',', stringsAsFactors = FALSE)
dt_response_day1 <- data.table(response_day1)

response_day7 <- read.csv('data/survey_response/response_day7.csv', header = TRUE, sep = ',', stringsAsFactors = FALSE)
dt_response_day7 <- data.table(response_day7)

# response_day14 <- read.csv('data/survey_response/response_day14.csv', header = TRUE, sep = ',', stringsAsFactors = FALSE)
# dt_response_day14 <- data.table(response_day1)

# Join the randomization scheduel and response data
result <- merge(dt_rand_sched,dt_response_day1, by='Email', all.x = TRUE)
result <- merge(result, dt_response_day7, by='Email',all.x = TRUE)

#Add in app usage from Stanley's collection
app_usage <- read.csv('data/survey_response/Experiment Tracking - Main.csv', header = TRUE, sep = ',', stringsAsFactors = FALSE)
dt_app_usage <- data.table(app_usage)
setnames(dt_app_usage, c('Day.1.App..Min.Day.','Day.7.App'), c('daily_usage_1','daily_usage_7'))
#Remove unnecessary columns
dt_app_usage <- dt_app_usage[,.(Email, daily_usage_1, daily_usage_7)]

# Join the randomization scheduel and response data
result <- merge(result,dt_app_usage, by='Email',all.x = TRUE)
#Save it
write.csv(result, file = 'data/survey_response/result.csv',row.names=FALSE)
