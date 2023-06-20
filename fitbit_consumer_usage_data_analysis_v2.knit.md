---
title: "fitbit_user_data_analysis"
output:
  html_document: default
  pdf_document: default
date: "2023-06-08"
---


##### 1. Understanding the business task:
Identify user trends in how consumers are using non-Bellabeat smart devices. Use this insight to recommend a high-level marketing strategy that can be applied to one of Bellabeat's product to drive new business growth opportunities.  

##### 2. Description of the data set we will be working with:
The data set we will be using is from users who consented to sharing their fitbit usage data. The original source was easily found on zenodo.org however we got the dataset on kaggle.com shared by the user Mobius. This data set contains data about users tracking their sleep, weight, calories, intensities, steps, heart rate, activity and metabolic equivalents (METs). 

The data set contains 18 CSV files:
* Daily logs for activity, sleep, calories, intensities, steps
* Hourly logs for steps, intensities and calories
* Minute logs for sleep and METs
* Minute logs for calories, intensities and steps as well separately organized into both wide and long formats
* Lastly heart rate logs per 5 second intervals and weight logs

##### 3. Preprocessing of the data - data manipulation and cleaning:
Google spreadsheets was used for some quick pre-processing of each CSV files.
1. Each data was processed to remove any duplicate entries.
      * The following sets were found to have duplicate entries in spreadsheets - daily sleep (3 duplicates) and minute sleep logs (543 duplicates)
      
As the minute calories, intensities, steps, METs stored in the long format and the heart rate log contain very large amounts of data for Google spreadsheet, we will import them into R to remove duplicates. 


```r
#install.packages("tidyverse")
```


```r
library(tidyverse)
```

```
## ── Attaching core tidyverse packages ──────────── tidyverse 2.0.0 ──
## ✔ dplyr     1.1.2     ✔ readr     2.1.4
## ✔ forcats   1.0.0     ✔ stringr   1.5.0
## ✔ ggplot2   3.4.2     ✔ tibble    3.2.1
## ✔ lubridate 1.9.2     ✔ tidyr     1.3.0
## ✔ purrr     1.0.1     
## ── Conflicts ────────────────────────────── tidyverse_conflicts() ──
## ✖ dplyr::filter() masks stats::filter()
## ✖ dplyr::lag()    masks stats::lag()
## ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
```


```r
#install.packages("lubridate")
library(lubridate)
```

Let's import all of the CSV files using the readr library











To ensure data was successfully imported we confirmed the number of columns and records matched the CSV file in Google spreadsheet. The number of records were counted using the 'COUNT() function in spreadsheet and compared to the number of observation in R's environment window after importing. 

Now that the data have been imported let's remove the duplicates in the large CSV files that was not possible in spreadsheet, i.e. the long format minute calories, intensities, steps, METs and heart rate files. 


```r
n_distinct(heart_rate)
```

```
## [1] 2483658
```

```r
n_distinct(minute_calories_l)
```

```
## [1] 1325580
```

```r
n_distinct(minute_intensities_l)
```

```
## [1] 1325580
```

```r
n_distinct(minute_steps_l)
```

```
## [1] 1325580
```

```r
n_distinct(minute_METs)
```

```
## [1] 1325580
```
When comparing the number of distinct records to the number of observations shown in R's environment window. We can see they are the same number thus being able to conclude these data have no duplicate records.


2. Correct the date related columns to the right date-time format. During importing of the data frames they were recognized as 'char' data types.

```r
str(weight)
```

```
## spc_tbl_ [67 × 8] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
##  $ Id            : num [1:67] 1.50e+09 1.50e+09 1.93e+09 2.87e+09 2.87e+09 ...
##  $ Date          : chr [1:67] "5/2/2016 11:59:59 PM" "5/3/2016 11:59:59 PM" "4/13/2016 1:08:52 AM" "4/21/2016 11:59:59 PM" ...
##  $ WeightKg      : num [1:67] 52.6 52.6 133.5 56.7 57.3 ...
##  $ WeightPounds  : num [1:67] 116 116 294 125 126 ...
##  $ Fat           : num [1:67] 22 NA NA NA NA 25 NA NA NA NA ...
##  $ BMI           : num [1:67] 22.6 22.6 47.5 21.5 21.7 ...
##  $ IsManualReport: logi [1:67] TRUE TRUE FALSE TRUE TRUE TRUE ...
##  $ LogId         : num [1:67] 1.46e+12 1.46e+12 1.46e+12 1.46e+12 1.46e+12 ...
##  - attr(*, "spec")=
##   .. cols(
##   ..   Id = col_double(),
##   ..   Date = col_character(),
##   ..   WeightKg = col_double(),
##   ..   WeightPounds = col_double(),
##   ..   Fat = col_double(),
##   ..   BMI = col_double(),
##   ..   IsManualReport = col_logical(),
##   ..   LogId = col_double()
##   .. )
##  - attr(*, "problems")=<externalptr>
```

We can see the date column is set to type 'char' in place of date-time. We can use the 'lubridate' package to format the date column accordingly.

Now we can convert the 'Date' column to the Date-time data type.

```r
weight$Date <- as.Date(weight$Date, format = "%m/%d/%y %I:%M:%S %p")
```

Confirming the Date column was correctly formatted

```r
str(weight)
```

```
## spc_tbl_ [67 × 8] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
##  $ Id            : num [1:67] 1.50e+09 1.50e+09 1.93e+09 2.87e+09 2.87e+09 ...
##  $ Date          : Date[1:67], format: NA ...
##  $ WeightKg      : num [1:67] 52.6 52.6 133.5 56.7 57.3 ...
##  $ WeightPounds  : num [1:67] 116 116 294 125 126 ...
##  $ Fat           : num [1:67] 22 NA NA NA NA 25 NA NA NA NA ...
##  $ BMI           : num [1:67] 22.6 22.6 47.5 21.5 21.7 ...
##  $ IsManualReport: logi [1:67] TRUE TRUE FALSE TRUE TRUE TRUE ...
##  $ LogId         : num [1:67] 1.46e+12 1.46e+12 1.46e+12 1.46e+12 1.46e+12 ...
##  - attr(*, "spec")=
##   .. cols(
##   ..   Id = col_double(),
##   ..   Date = col_character(),
##   ..   WeightKg = col_double(),
##   ..   WeightPounds = col_double(),
##   ..   Fat = col_double(),
##   ..   BMI = col_double(),
##   ..   IsManualReport = col_logical(),
##   ..   LogId = col_double()
##   .. )
##  - attr(*, "problems")=<externalptr>
```

Re-formatting all the other tables date columns



```r
daily_activity$ActivityDate <- as.Date(daily_activity$ActivityDate, format = "%m/%d/%Y")
str(daily_activity)
```

```
## spc_tbl_ [940 × 15] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
##  $ Id                      : num [1:940] 1.5e+09 1.5e+09 1.5e+09 1.5e+09 1.5e+09 ...
##  $ ActivityDate            : Date[1:940], format: "2016-04-12" ...
##  $ TotalSteps              : num [1:940] 13162 10735 10460 9762 12669 ...
##  $ TotalDistance           : num [1:940] 8.5 6.97 6.74 6.28 8.16 ...
##  $ TrackerDistance         : num [1:940] 8.5 6.97 6.74 6.28 8.16 ...
##  $ LoggedActivitiesDistance: num [1:940] 0 0 0 0 0 0 0 0 0 0 ...
##  $ VeryActiveDistance      : num [1:940] 1.88 1.57 2.44 2.14 2.71 ...
##  $ ModeratelyActiveDistance: num [1:940] 0.55 0.69 0.4 1.26 0.41 ...
##  $ LightActiveDistance     : num [1:940] 6.06 4.71 3.91 2.83 5.04 ...
##  $ SedentaryActiveDistance : num [1:940] 0 0 0 0 0 0 0 0 0 0 ...
##  $ VeryActiveMinutes       : num [1:940] 25 21 30 29 36 38 42 50 28 19 ...
##  $ FairlyActiveMinutes     : num [1:940] 13 19 11 34 10 20 16 31 12 8 ...
##  $ LightlyActiveMinutes    : num [1:940] 328 217 181 209 221 164 233 264 205 211 ...
##  $ SedentaryMinutes        : num [1:940] 728 776 1218 726 773 ...
##  $ Calories                : num [1:940] 1985 1797 1776 1745 1863 ...
##  - attr(*, "spec")=
##   .. cols(
##   ..   Id = col_double(),
##   ..   ActivityDate = col_character(),
##   ..   TotalSteps = col_double(),
##   ..   TotalDistance = col_double(),
##   ..   TrackerDistance = col_double(),
##   ..   LoggedActivitiesDistance = col_double(),
##   ..   VeryActiveDistance = col_double(),
##   ..   ModeratelyActiveDistance = col_double(),
##   ..   LightActiveDistance = col_double(),
##   ..   SedentaryActiveDistance = col_double(),
##   ..   VeryActiveMinutes = col_double(),
##   ..   FairlyActiveMinutes = col_double(),
##   ..   LightlyActiveMinutes = col_double(),
##   ..   SedentaryMinutes = col_double(),
##   ..   Calories = col_double()
##   .. )
##  - attr(*, "problems")=<externalptr>
```









```r
daily_sleep$SleepDay <- as.POSIXct(daily_sleep$SleepDay, format = "%m/%d/%Y %I:%M:%S %p", tz= Sys.timezone())
str(daily_sleep)
```

```
## spc_tbl_ [410 × 5] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
##  $ Id                : num [1:410] 1.5e+09 1.5e+09 1.5e+09 1.5e+09 1.5e+09 ...
##  $ SleepDay          : POSIXct[1:410], format: "2016-04-12" ...
##  $ TotalSleepRecords : num [1:410] 1 2 1 2 1 1 1 1 1 1 ...
##  $ TotalMinutesAsleep: num [1:410] 327 384 412 340 700 304 360 325 361 430 ...
##  $ TotalTimeInBed    : num [1:410] 346 407 442 367 712 320 377 364 384 449 ...
##  - attr(*, "spec")=
##   .. cols(
##   ..   Id = col_double(),
##   ..   SleepDay = col_character(),
##   ..   TotalSleepRecords = col_double(),
##   ..   TotalMinutesAsleep = col_double(),
##   ..   TotalTimeInBed = col_double()
##   .. )
##  - attr(*, "problems")=<externalptr>
```


```r
hourly_calories$ActivityHour <- as.POSIXct(hourly_calories$ActivityHour, format = "%m/%d/%Y %I:%M:%S %p", tz = Sys.timezone())
str(hourly_calories)
```

```
## spc_tbl_ [22,099 × 3] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
##  $ Id          : num [1:22099] 1.5e+09 1.5e+09 1.5e+09 1.5e+09 1.5e+09 ...
##  $ ActivityHour: POSIXct[1:22099], format: "2016-04-12 00:00:00" ...
##  $ Calories    : num [1:22099] 81 61 59 47 48 48 48 47 68 141 ...
##  - attr(*, "spec")=
##   .. cols(
##   ..   Id = col_double(),
##   ..   ActivityHour = col_character(),
##   ..   Calories = col_double()
##   .. )
##  - attr(*, "problems")=<externalptr>
```


```r
hourly_intensities$ActivityHour <- as.POSIXct(hourly_intensities$ActivityHour, format = "%m/%d/%Y %I:%M:%S %p", tz = Sys.timezone())
str(hourly_intensities)
```

```
## spc_tbl_ [22,099 × 4] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
##  $ Id              : num [1:22099] 1.5e+09 1.5e+09 1.5e+09 1.5e+09 1.5e+09 ...
##  $ ActivityHour    : POSIXct[1:22099], format: "2016-04-12 00:00:00" ...
##  $ TotalIntensity  : num [1:22099] 20 8 7 0 0 0 0 0 13 30 ...
##  $ AverageIntensity: num [1:22099] 0.333 0.133 0.117 0 0 ...
##  - attr(*, "spec")=
##   .. cols(
##   ..   Id = col_double(),
##   ..   ActivityHour = col_character(),
##   ..   TotalIntensity = col_double(),
##   ..   AverageIntensity = col_double()
##   .. )
##  - attr(*, "problems")=<externalptr>
```


```r
hourly_steps$ActivityHour <- as.POSIXct(hourly_steps$ActivityHour, format = "%m/%d/%Y %I:%M:%S %p", tz = Sys.timezone())
head(hourly_steps)
```

```
## # A tibble: 6 × 3
##           Id ActivityHour        StepTotal
##        <dbl> <dttm>                  <dbl>
## 1 1503960366 2016-04-12 00:00:00       373
## 2 1503960366 2016-04-12 01:00:00       160
## 3 1503960366 2016-04-12 02:00:00       151
## 4 1503960366 2016-04-12 03:00:00         0
## 5 1503960366 2016-04-12 04:00:00         0
## 6 1503960366 2016-04-12 05:00:00         0
```


```r
heart_rate$Time <- as.POSIXct(heart_rate$Time, format = "%m/%d/%Y %I:%M:%S %p", tz = Sys.timezone())
str(heart_rate)
```

```
## spc_tbl_ [2,483,658 × 3] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
##  $ Id   : num [1:2483658] 2.02e+09 2.02e+09 2.02e+09 2.02e+09 2.02e+09 ...
##  $ Time : POSIXct[1:2483658], format: "2016-04-12 07:21:00" ...
##  $ Value: num [1:2483658] 97 102 105 103 101 95 91 93 94 93 ...
##  - attr(*, "spec")=
##   .. cols(
##   ..   Id = col_double(),
##   ..   Time = col_character(),
##   ..   Value = col_double()
##   .. )
##  - attr(*, "problems")=<externalptr>
```


```r
minute_calories_l$ActivityMinute <- as.POSIXct(minute_calories_l$ActivityMinute, format = "%m/%d/%Y %I:%M:%S %p", tz = Sys.timezone())
str(minute_calories_l)
```

```
## spc_tbl_ [1,325,580 × 3] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
##  $ Id            : num [1:1325580] 1.5e+09 1.5e+09 1.5e+09 1.5e+09 1.5e+09 ...
##  $ ActivityMinute: POSIXct[1:1325580], format: "2016-04-12 00:00:00" ...
##  $ Calories      : num [1:1325580] 0.786 0.786 0.786 0.786 0.786 ...
##  - attr(*, "spec")=
##   .. cols(
##   ..   Id = col_double(),
##   ..   ActivityMinute = col_character(),
##   ..   Calories = col_double()
##   .. )
##  - attr(*, "problems")=<externalptr>
```


```r
minute_intensities_l$ActivityMinute <- as.POSIXct(minute_intensities_l$ActivityMinute, format= "%m/%d/%Y %I:%M:%S %p", tz = Sys.timezone())
str(minute_intensities_l)
```

```
## spc_tbl_ [1,325,580 × 3] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
##  $ Id            : num [1:1325580] 1.5e+09 1.5e+09 1.5e+09 1.5e+09 1.5e+09 ...
##  $ ActivityMinute: POSIXct[1:1325580], format: "2016-04-12 00:00:00" ...
##  $ Intensity     : num [1:1325580] 0 0 0 0 0 0 0 0 0 0 ...
##  - attr(*, "spec")=
##   .. cols(
##   ..   Id = col_double(),
##   ..   ActivityMinute = col_character(),
##   ..   Intensity = col_double()
##   .. )
##  - attr(*, "problems")=<externalptr>
```













3. We can rename column names to keep it consistent across tables based on the periods i.e. daily, hourly and minute logs.

All daily tables named the date column 'ActivityDay' except for the daily_activity table. We can rename that.

```r
colnames(daily_activity)[colnames(daily_activity) == 'ActivityDate'] <- 'ActivityDay'
```


Now that the data have been cleaned and formatted we can proceed to use the data for analysis.

##### 4. Finding insights through data analysis:

1. Seeing if each tables contain sufficient data to draw reliable conclusions by verifying the sample size.


```r
table_names <- c("daily_activity", 
                 "daily_calories", 
                 "daily_intensities", 
                 "daily_sleep", 
                 "daily_steps", 
                 "hourly_calories", 
                 "hourly_intensities", 
                 "hourly_steps", 
                 "minute_calories_l", 
                 "minute_calories_w", 
                 "minute_intensities_l", 
                 "minute_intensities_w", 
                 "minute_METs", 
                 "minute_sleep", 
                 "minute_steps_l", 
                 "minute_steps_w", 
                 "weight", 
                 "heart_rate")

table_names
```

```
##  [1] "daily_activity"       "daily_calories"      
##  [3] "daily_intensities"    "daily_sleep"         
##  [5] "daily_steps"          "hourly_calories"     
##  [7] "hourly_intensities"   "hourly_steps"        
##  [9] "minute_calories_l"    "minute_calories_w"   
## [11] "minute_intensities_l" "minute_intensities_w"
## [13] "minute_METs"          "minute_sleep"        
## [15] "minute_steps_l"       "minute_steps_w"      
## [17] "weight"               "heart_rate"
```


```r
user_count <- c(n_distinct(daily_activity$Id), 
                n_distinct(daily_calories$Id), 
                n_distinct(daily_intensities$Id), 
                n_distinct(daily_sleep$Id), 
                n_distinct(daily_steps$Id), 
                n_distinct(hourly_calories$Id), 
                n_distinct(hourly_intensities$Id), 
                n_distinct(hourly_steps$Id), 
                n_distinct(minute_calories_l$Id),
                n_distinct(minute_calories_w$Id), 
                n_distinct(minute_intensities_l$Id), 
                n_distinct(minute_intensities_w$Id), 
                n_distinct(minute_METs$Id), 
                n_distinct(minute_sleep$Id), 
                n_distinct(minute_steps_l$Id), 
                n_distinct(minute_steps_w$Id), 
                n_distinct(weight$Id), 
                n_distinct(heart_rate$Id))
user_count
```

```
##  [1] 33 33 33 24 33 33 33 33 33 33 33 33 33 24 33 33  8 14
```


```r
users_count_table <- data.frame(table_names, user_count)
users_count_table
```

```
##             table_names user_count
## 1        daily_activity         33
## 2        daily_calories         33
## 3     daily_intensities         33
## 4           daily_sleep         24
## 5           daily_steps         33
## 6       hourly_calories         33
## 7    hourly_intensities         33
## 8          hourly_steps         33
## 9     minute_calories_l         33
## 10    minute_calories_w         33
## 11 minute_intensities_l         33
## 12 minute_intensities_w         33
## 13          minute_METs         33
## 14         minute_sleep         24
## 15       minute_steps_l         33
## 16       minute_steps_w         33
## 17               weight          8
## 18           heart_rate         14
```

From this we can see users are not really making use of the weight, heart rate and sleep tracking features when it comes to the fitbit tracker compared to the Activity, Intensity, Calories, METs and Step tracker features. This potentially communicates users are more focused on using these devices to monitor their level of activeness. Additionally, the data were retrieved from a sample size of less than 30 for the weight, heart rate and sleep logs therefore we cannot proceed to use their tables for any analysis as they have a high uncertainty associated with them. According to the Central Limit Theorem we should have a minimum sample size of 30 for the analysis' results to start being reflective of the average population's response. 


Let's compare the common columns across the different periods daily, hourly and minutely to see if we can aggregate and combine data frames for more interesting insights.

```r
head(hourly_calories)
```

```
## # A tibble: 6 × 3
##           Id ActivityHour        Calories
##        <dbl> <dttm>                 <dbl>
## 1 1503960366 2016-04-12 00:00:00       81
## 2 1503960366 2016-04-12 01:00:00       61
## 3 1503960366 2016-04-12 02:00:00       59
## 4 1503960366 2016-04-12 03:00:00       47
## 5 1503960366 2016-04-12 04:00:00       48
## 6 1503960366 2016-04-12 05:00:00       48
```

```r
head(hourly_intensities)
```

```
## # A tibble: 6 × 4
##           Id ActivityHour        TotalIntensity AverageIntensity
##        <dbl> <dttm>                       <dbl>            <dbl>
## 1 1503960366 2016-04-12 00:00:00             20            0.333
## 2 1503960366 2016-04-12 01:00:00              8            0.133
## 3 1503960366 2016-04-12 02:00:00              7            0.117
## 4 1503960366 2016-04-12 03:00:00              0            0    
## 5 1503960366 2016-04-12 04:00:00              0            0    
## 6 1503960366 2016-04-12 05:00:00              0            0
```

```r
head(hourly_steps)
```

```
## # A tibble: 6 × 3
##           Id ActivityHour        StepTotal
##        <dbl> <dttm>                  <dbl>
## 1 1503960366 2016-04-12 00:00:00       373
## 2 1503960366 2016-04-12 01:00:00       160
## 3 1503960366 2016-04-12 02:00:00       151
## 4 1503960366 2016-04-12 03:00:00         0
## 5 1503960366 2016-04-12 04:00:00         0
## 6 1503960366 2016-04-12 05:00:00         0
```


```r
head(daily_calories)
```

```
## # A tibble: 6 × 3
##           Id ActivityDay Calories
##        <dbl> <date>         <dbl>
## 1 1503960366 2016-04-12      1985
## 2 1503960366 2016-04-13      1797
## 3 1503960366 2016-04-14      1776
## 4 1503960366 2016-04-15      1745
## 5 1503960366 2016-04-16      1863
## 6 1503960366 2016-04-17      1728
```

```r
head(daily_intensities)
```

```
## # A tibble: 6 × 10
##           Id ActivityDay SedentaryMinutes LightlyActiveMinutes
##        <dbl> <date>                 <dbl>                <dbl>
## 1 1503960366 2016-04-12               728                  328
## 2 1503960366 2016-04-13               776                  217
## 3 1503960366 2016-04-14              1218                  181
## 4 1503960366 2016-04-15               726                  209
## 5 1503960366 2016-04-16               773                  221
## 6 1503960366 2016-04-17               539                  164
## # ℹ 6 more variables: FairlyActiveMinutes <dbl>,
## #   VeryActiveMinutes <dbl>, SedentaryActiveDistance <dbl>,
## #   LightActiveDistance <dbl>, ModeratelyActiveDistance <dbl>,
## #   VeryActiveDistance <dbl>
```

```r
head(daily_steps)
```

```
## # A tibble: 6 × 3
##           Id ActivityDay StepTotal
##        <dbl> <date>          <dbl>
## 1 1503960366 2016-04-12      13162
## 2 1503960366 2016-04-13      10735
## 3 1503960366 2016-04-14      10460
## 4 1503960366 2016-04-15       9762
## 5 1503960366 2016-04-16      12669
## 6 1503960366 2016-04-17       9705
```

```r
head(daily_activity)
```

```
## # A tibble: 6 × 15
##           Id ActivityDay TotalSteps TotalDistance TrackerDistance
##        <dbl> <date>           <dbl>         <dbl>           <dbl>
## 1 1503960366 2016-04-12       13162          8.5             8.5 
## 2 1503960366 2016-04-13       10735          6.97            6.97
## 3 1503960366 2016-04-14       10460          6.74            6.74
## 4 1503960366 2016-04-15        9762          6.28            6.28
## 5 1503960366 2016-04-16       12669          8.16            8.16
## 6 1503960366 2016-04-17        9705          6.48            6.48
## # ℹ 10 more variables: LoggedActivitiesDistance <dbl>,
## #   VeryActiveDistance <dbl>, ModeratelyActiveDistance <dbl>,
## #   LightActiveDistance <dbl>, SedentaryActiveDistance <dbl>,
## #   VeryActiveMinutes <dbl>, FairlyActiveMinutes <dbl>,
## #   LightlyActiveMinutes <dbl>, SedentaryMinutes <dbl>,
## #   Calories <dbl>
```

2. We can create the following joined tables:
* hourly - Calories, intensities, Steps tables joined on Id and ActivityHour


```r
hourly_data <- merge(x=hourly_calories, y=hourly_intensities, all=TRUE)

hourly_datas <- merge(x=hourly_data, y=hourly_steps, all=TRUE)

head(hourly_datas) 
```

```
##           Id        ActivityHour Calories TotalIntensity
## 1 1503960366 2016-04-12 00:00:00       81             20
## 2 1503960366 2016-04-12 01:00:00       61              8
## 3 1503960366 2016-04-12 02:00:00       59              7
## 4 1503960366 2016-04-12 03:00:00       47              0
## 5 1503960366 2016-04-12 04:00:00       48              0
## 6 1503960366 2016-04-12 05:00:00       48              0
##   AverageIntensity StepTotal
## 1         0.333333       373
## 2         0.133333       160
## 3         0.116667       151
## 4         0.000000         0
## 5         0.000000         0
## 6         0.000000         0
```

A closer look at the daily_activity table shows this table has the same daily calories, steps and intensities data already in its table. 

We won't be working with any tables on the minute scale record as there are many 0 values for most records to provide any interesting insights.

3. We can visualize some interesting correlations between calories burned and steps, intensity















