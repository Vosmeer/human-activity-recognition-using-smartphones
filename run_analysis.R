###### Data Science Course, Course 3, Week 4, Peer graded Assignment 1 ######
install.packages("tidyr")
install.packages("plyr")
##Assignment:
#You should create one R script called run_analysis.R that does the following.

#2 Extracts only the measurements on the mean and standard deviation for each measurement.
#3 Uses descriptive activity names to name the activities in the data set
#4 Appropriately labels the data set with descriptive variable names.
#5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable 
# for each activity and each subject

#### Preliminary

##Setting working directory
setwd("C:\\_Data\\Mijn Documenten\\R\\Scripts Coursera\\Course 3 - Week 4")
library(stringr)
library(tidyr)
library(dplyr)
library(plyr)

## Download data
url1<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
td = tempdir()
tf = tempfile(tmpdir=td, fileext=".zip")
download.file(url1, tf)


## Loading data into R
filelist = unzip(tf,list=FALSE)
fileset_tot<-lapply(filelist, FUN=read.table,sep="",fill=T)
files_import<-as.data.frame(cbind(filelist,summary(fileset_tot),nrow(fileset_tot),lapply(fileset_tot,FUN=nrow)))

##cleanup
rm(filelist,td,tf,url1)

#### Question 1: Merging the training and the test sets to create one data set

## Merging datasets
  test_data<-as.data.frame(fileset_tot[[15]])
  training_data<-as.data.frame(fileset_tot[[27]])
  dataset_tot<-rbind(test_data,training_data)

  #cleanup
  rm(test_data,training_data)
  
#### Question 2: Dataset with only mean and standard deviation

## Rearranging feature labels to get measurement-type as the start of each label
  
  # Get labelnames
    dataset_names<-as.data.frame(fileset_tot[[2]])
    dataset_names2<-as.character(dataset_names[,2])

  # Splitting labels
    feat_domain<-ldply(str_extract_all(dataset_names2,"(^[:lower:]{1})"),rbind)
    feat_labels<-ldply(str_extract_all(dataset_names2,"((?<=[:lower:])[:upper:][:lower:]{2,})"),rbind)
    feat_meas<-ldply(str_extract_all(dataset_names2,"((?<=[:punct:])[:alpha:]{2,})"),rbind)
    feat_dir<-ldply(str_extract_all(dataset_names2,"((?<=[:punct:]{3})((.){1,5}))"),rbind)
    feat_corr<-ldply(str_extract_all(dataset_names2,"((?<=[:punct:]{3})([:upper:][:punct:][:upper:]))"),rbind)
    feat_angle<-ldply(str_extract_all(dataset_names2,"((?<=\\()([:graph:]{1,})(?=\\)))"),rbind)
    
    feat_domain[,1] <- gsub("t", "time", feat_domain[,1])
    feat_domain[,1] <- gsub("f", "trequency", feat_domain[,1])
    feat_domain[,1] <- gsub("a", "angle", feat_domain[,1])
    
  # Constructing new labels
    headers_overv<-cbind(feat_labels,feat_domain,feat_meas,feat_dir,feat_angle)
    
    headers_overv[] <- lapply(headers_overv, as.character)
    
    header_desc<-{paste( 
      headers_overv[,8],
      "(",
      headers_overv[,10],
      ")",
      ".of.",
      headers_overv[,7],
      ".of.",headers_overv[,1],
      headers_overv[,2],
      headers_overv[,3],
      headers_overv[,4],
      headers_overv[,5],
      headers_overv[,6],
      headers_overv[,7],
      "(",
      headers_overv[,11],
      ")",
      sep="")
    }
    
    header_desc <- gsub("NA", "", header_desc)
    header_desc[c(555:561)] <-gsub("Mean\\(\\)\\.of\\.Angle\\.\\of\\.", "", header_desc[c(555:561)])
    header_desc[c(1:561)] <-gsub("\\(\\)", "", header_desc[c(1:561)])
    #header_desc<-as.data.frame(header_desc)
    #header_desc[] <- lapply(header_desc, as.character)

  #cleanup
    rm(dataset_names,dataset_names2,feat_labels,feat_corr,feat_dir,feat_angle,feat_meas,feat_domain)

## Select only the Mean and Standard deviation-measurements
    
  #filter on time
    headers_mean_std<-headers_overv[headers_overv[,7]%in%("time"),] 

  #filter on mean and standard deviation
    headers_mean_std<-headers_mean_std[headers_mean_std[,8]%in%c("mean","std"),]    
    
  #filter on derivated measurements
    headers_mean_std<-headers_mean_std[is.na(headers_mean_std[,3]),]       

## Filter dataset_tot for mean and standard deviation (question #4 is also answered here!)   
  
  # renaming dataset_tot
    colnames(dataset_tot)<-header_desc
    
  # filtering dataset_tot  
    measurements<-as.numeric(rownames(headers_mean_std))
    dataset_mean_std<-dataset_tot[,measurements]

  #cleanup
    rm(header_desc,headers_overv,headers_mean_std,measurements)
  
#### Question 3: Uses descriptive activity names to name the activities in the data set
    
  # Get activities
    dataset_activities_train <- as.data.frame(fileset_tot[[28]])
    dataset_activities_test <- as.data.frame(fileset_tot[[16]])
  
  # Get activity names
    dataset_activities_names <- as.data.frame(fileset_tot[[1]])

  # Merge activities
    dataset_activities <- rbind(dataset_activities_test,dataset_activities_train)
  
  # Labelling activities
    dataset_activities <- join(dataset_activities,dataset_activities_names, by = "V1")
 
  # Labelling activities in dataset
    dataset_mean_std<-cbind(dataset_activities[,2],dataset_mean_std)
    colnames(dataset_mean_std)[1]<-"Activity"

  #cleanup
    rm(dataset_activities_names,dataset_activities_train,dataset_activities_test,dataset_activities)
      
#### Question 4: Appropriately labels the data set with descriptive variable names 
    
    ## See last 3 programming lines of question no. 2
    
#### Question 5: create an independent tidy data set with the average of each variable for each activity and each subject 
 
  ##  Adding subject number to dataset
    
    # Get subject
    dataset_subjects_train <- as.data.frame(fileset_tot[[26]])
    dataset_subjects_test <- as.data.frame(fileset_tot[[14]])

    # Merge subjects
    dataset_subjects <- rbind(dataset_subjects_test,dataset_subjects_train)

    # Adding subjects to dataset
    dataset_mean_std<-cbind(dataset_subjects,dataset_mean_std)
    colnames(dataset_mean_std)[1]<-"Subject"
    
    #cleanup
    rm(dataset_subjects_train,dataset_subjects_test,dataset_subjects)
    
  ##  Create tidy dataset
    dataset_mean_std_tdy<-dataset_mean_std%>%group_by(Subject,Activity)%>%summarise_all(funs(mean))
    
  ##  Create text-file
    write.table(dataset_mean_std_tdy,row.name = FALSE,file = "tidy_data_set.txt") 
    