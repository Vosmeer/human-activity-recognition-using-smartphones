# human-activity-recognition-using-smartphones

You should create one R script called run_analysis.R that does the following.

    Merges the training and the test sets to create one data set.
    Extracts only the measurements on the mean and standard deviation for each measurement.
    Uses descriptive activity names to name the activities in the data set
    Appropriately labels the data set with descriptive variable names.
    From the data set in step 4, creates a second, independent tidy data set 
    with the average of each variable for each activity and each subject.

## Question 1: Merging the training and the test sets to create one data set
#### Loading data into R
#### Merging datasets train/test data
 
## Question 2: Dataset with only mean and standard deviation

### Rearranging feature labels to get measurement-type as the start of each label
  #### Get labelnames
  #### Splitting labels
  #### Constructing new labels

### Select only the Mean and Standard deviation-measurements
  #### Filter on time
  #### Filter on mean and standard deviation
  #### Filter on derivated measurements

### Filter dataset_tot for mean and standard deviation (question #4 is also answered here!)   
  #### renaming colnames dataset_tot
  #### filtering dataset_tot   

## Question 3: Uses descriptive activity names to name the activities in the data set
  ### Get activities 
  ### Get activity names
  ### Merge activities
  ### Labelling activities
  ### Labelling activities in dataset
      
## Question 4: Appropriately labels the data set with descriptive variable names 
### See last 3 programming lines of question no. 2
    
## Question 5: create an independent tidy data set with the average of each variable for each activity and each subject 
  ###  Adding subject number to dataset
  ### Get subject
  ### Merge subjects
  ### Adding subjects to dataset
  ###  Create tidy dataset

##  Create text-file
