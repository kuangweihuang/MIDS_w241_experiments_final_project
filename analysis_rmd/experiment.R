library(data.table)
setwd('/Users/temp/Documents/MIDS/w241/course_project/W241_Course_Project')

wrangle <- function(filepath){
  data_raw <- read.csv(file = filepath, 
                       header = TRUE, 
                       sep = ',', 
                       # row.names = 'ResponseId',
                       stringsAsFactors = FALSE)
  dt <- data.table(data_raw)
  dt <- dt[c(-1,-2),] # Remove first two rows which are not data
  
  dt <- dt[,.(ResponseId,RecipientEmail,RecordedDate,Q2_Id,Q2_Name,
              Q32_1,Q32_2,Q32_3,Q32_4,Q32_5,Q32_6,Q32_7,Q32_8)]
  
  setnames(dt, c('RecipientEmail','Q2_Id','Q2_Name','Q32_1','Q32_2','Q32_3','Q32_4','Q32_5','Q32_6','Q32_7','Q32_8'),
           c('Email','screenshot_id','screenshot_name','excited','happy','peaceful','relaxed','upset','stressed','sad','depressed'))
  
  dt[,`:=`(excited=as.numeric(excited),happy=as.numeric(happy),peaceful=as.numeric(peaceful),relaxed=as.numeric(relaxed),
           upset=as.numeric(upset),stressed=as.numeric(stressed),sad=as.numeric(sad),depressed=as.numeric(depressed))]
  return(dt)
}

# The mood translation datatable
dt_mood <- data.table(name=c('excited','happy','peaceful','relaxed','upset','stressed','sad','depressed'),
                      activation = c(4,3,2,1,4,3,2,1),
                      pleasant = c(4,3,2,1,4,1,3,2))

# create two functions to do the moodtranslation
cal_act <- function(moodname, number){
  return(dt_mood[name==moodname, activation]*number)
}
cal_ple <- function(moodname, number){
  return(dt_mood[name==moodname, pleasant]*number)
}

# Add day1 data
dt_cfb <- wrangle('data/survey_response/day1/Control_FB.csv')
dt_cins <- wrangle('data/survey_response/day1/Control_Ins.csv')
dt_cwc <- wrangle('data/survey_response/day1/Control_WC.csv')
dt_tfb <- wrangle('data/survey_response/day1/Treat_FB.csv')
dt_tins <- wrangle('data/survey_response/day1/Treat_Ins.csv')
dt_twc <- wrangle('data/survey_response/day1/Treat_WC.csv')

dt_response1 <- rbind(dt_cfb, dt_cins, dt_cwc, dt_tfb, dt_tins, dt_twc)

# create two columns to record the mood
dt_response1[, `:=`(activation1=0L, pleasant1=0L)]
# translate mood to activation and pleasant
dt_response1[,`:=`(activation1=cal_act('excited',excited)+
                    cal_act('happy',happy)+
                    cal_act('peaceful',peaceful)+
                    cal_act('relaxed', relaxed)+
                    cal_act('upset', upset)+
                    cal_act('stressed',stressed)+
                    cal_act('sad',sad)+
                    cal_act('depressed',depressed),
                  pleasant1=cal_ple('excited',excited)+
                    cal_ple('happy',happy)+
                    cal_ple('peaceful',peaceful)+
                    cal_ple('relaxed', relaxed)+
                    cal_ple('upset', upset)+
                    cal_ple('stressed',stressed)+
                    cal_ple('sad',sad)+
                    cal_ple('depressed',depressed))]
# Remove the actual mood columns and only keep the activation and pleasant column
dt_response1[,`:=`(excited=NULL,happy=NULL,peaceful=NULL,relaxed=NULL,upset=NULL,stressed=NULL,sad=NULL,depressed=NULL)]
dt_response1 <- dt_response1[,.(Email, activation1, pleasant1)]

#Save to csv
write.csv(dt_response1, file = 'data/survey_response/response_day1.csv',row.names=FALSE)

#Add day7 data
dt_fb7 <- wrangle('data/survey_response/day7/fb_day7.csv')
dt_ins7 <- wrangle('data/survey_response/day7/ins_day7.csv')
dt_wc7 <- wrangle('data/survey_response/day7/wc_day7.csv')
dt_response7 <- rbind(dt_fb7, dt_ins7, dt_wc7)
# create two columns to record the mood
dt_response7[, `:=`(activation7=0, pleasant7=0)]
# translate mood to activation and pleasant
dt_response7[,`:=`(activation7=cal_act('excited',excited)+
                     cal_act('happy',happy)+
                     cal_act('peaceful',peaceful)+
                     cal_act('relaxed', relaxed)+
                     cal_act('upset', upset)+
                     cal_act('stressed',stressed)+
                     cal_act('sad',sad)+
                     cal_act('depressed',depressed),
                   pleasant7=cal_ple('excited',excited)+
                     cal_ple('happy',happy)+
                     cal_ple('peaceful',peaceful)+
                     cal_ple('relaxed', relaxed)+
                     cal_ple('upset', upset)+
                     cal_ple('stressed',stressed)+
                     cal_ple('sad',sad)+
                     cal_ple('depressed',depressed))]
# Remove the actual mood columns and only keep the activation and pleasant column
dt_response7[,`:=`(excited=NULL,happy=NULL,peaceful=NULL,relaxed=NULL,upset=NULL,stressed=NULL,sad=NULL,depressed=NULL)]
dt_response7 <- dt_response7[,.(Email, activation7, pleasant7)]

#Save to csv
write.csv(dt_response7, file = 'data/survey_response/response_day7.csv',row.names=FALSE)

# Add day14 data
# dt_fb14 <- wrangle('data/survey_response/day7/fb_day7.csv')
# dt_ins14 <- wrangle('data/survey_response/day7/ins_day7.csv')
# dt_wc14 <- wrangle('data/survey_response/day7/wc_day7.csv')
# dt_response14 <- rbind(dt_fb7, dt_ins7, dt_wc7)

