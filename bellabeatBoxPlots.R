
#Boxplot for heartrate
BellabeatHeartrateData$EngagementGroup <- factor(BellabeatHeartrateData$EngagementGroup,
                                                 levels = c("Low", "Medium", "High"))
boxplot(AverageHeartrate ~ EngagementGroup,
        data = BellabeatHeartrateData,
        main = "Average Daily Heartrate by Engagement Group",
        xlab = "Engagement Group",
        ylab = "Average Heartrate Per Day")

#Boxplot for calories
BellabeatCaloriesData$EngagementGroup <- factor(BellabeatCaloriesData$EngagementGroup,
                                                 levels = c("Low", "Medium", "High"))
boxplot(AverageCaloriesBurned ~ EngagementGroup,
        data = BellabeatCaloriesData,
        main = "Average Daily Calories Burned by Engagement Group",
        xlab = "Engagement Group",
        ylab = "Average Calories Per Day")

#Boxplot for sleep
BellabeatSleepData$EngagementGroup <- factor(BellabeatSleepData$EngagementGroup,
                                                levels = c("Low", "Medium", "High"))
boxplot(AvereageNightlySleepMinutes ~ EngagementGroup,
        data = BellabeatSleepData,
        main = "Average Sleep Per Night by Engagement Group in Minutes",
        xlab = "Engagement Group",
        ylab = "Average Sleep Per Night")

#Boxplot for steps
BellabeatStepData$EngagementGroup <- factor(BellabeatStepData$EngagementGroup,
                                                levels = c("Low", "Medium", "High"))
boxplot(AverageDailySteps ~ EngagementGroup,
        data = BellabeatStepData,
        main = "Average Daily Steps by Engagement Group",
        xlab = "Engagement Group",
        ylab = "Average Steps Per Day")

#Boxplot for intensity
BellabeatIntensityLevel$EngagementGroup <- factor(BellabeatIntensityLevel$EngagementGroup,
                                                levels = c("Low", "Medium", "High"))
boxplot(AvereageIntensity ~ EngagementGroup,
        data = BellabeatIntensityLevel,
        main = "Average Daily Intensity by Engagement Group",
        xlab = "Engagement Group",
        ylab = "Average Intensity Per Day")

#Boxplot for very active time
BellabeatVeryActiveData$EngagementGroup <- factor(BellabeatVeryActiveData$EngagementGroup,
                                                    levels = c("Low", "Medium", "High"))
boxplot(VeryActiveTime ~ EngagementGroup,
        data = BellabeatVeryActiveData,
        main = "Average Daily Very Active Time by Engagement Group",
        xlab = "Engagement Group",
        ylab = "Average Time Per Day")

#Boxplot for failry active time
BellabeatFairlyActiveData$EngagementGroup <- factor(BellabeatFairlyActiveData$EngagementGroup,
                                                levels = c("Low", "Medium", "High"))
boxplot(FairlyActiveTime ~ EngagementGroup,
        data = BellabeatFairlyActiveData,
        main = "Average Daily Fairly Active Time by Engagement Group",
        xlab = "Engagement Group",
        ylab = "Average Time Per Day")

#Boxplot for lightly active time
BellabeatLightlyActiveData$EngagementGroup <- factor(BellabeatLightlyActiveData$EngagementGroup,
                                                    levels = c("Low", "Medium", "High"))
boxplot(LightlyActiveTime ~ EngagementGroup,
        data = BellabeatLightlyActiveData,
        main = "Average Daily Lightly Active Time by Engagement Group",
        xlab = "Engagement Group",
        ylab = "Average Time Per Day")

#Boxplot for sedentary time
BellabeatSedentaryData$EngagementGroup <- factor(BellabeatSedentaryData$EngagementGroup,
                                                 levels = c("Low","Medium","High"))
boxplot(SedentaryTime ~ EngagementGroup,
        data = BellabeatSedentaryData,
        main = "Average Sedentary Time by Engagement Group in Minutes",
        xlab = "Engagement Group",
        ylab = "Average Sedentary Time Per Day")