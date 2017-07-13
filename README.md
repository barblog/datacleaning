```Coursera Data Cleaning Class Final Project```

The tidy.txt file contains the activity data of 30 subjects. The rows are average data for each subject's each kind of activities.

The run_analysis.R file does the following:
1. install and load necessary packages
2. download and unzip the original data file
3. load activity labels and features
4. get only the mean and standard deviation data
5. load and combine test and train data with activity and suject as factors on the two left-most columns
6. melt the data and create a tidy dataset with average for each group (each subject's each activity)

