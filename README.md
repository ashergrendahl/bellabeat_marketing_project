# Bellabeat Marketing Strategy

**Summary:**  
In this project I assume the role of a junior data analyst at Bellabeat where I am tasked to work with the marketing team and analyze Fitbit data to see how people use fitness devices. I need to find trends in the Fitbit data that helps me inform the marketing strategy of the company by making data-driven decisions. 

**Tools:** SQL Server, SQL (T-SQL), Google Sheets, Google Slides

---

## What I did
- Imported the dataset into a SQL Server database and verified row counts.
- Cleaned and standardized data (handled NULLs, formatted date fields).
- Created a new table view that contained engagement groups of users based on how many times they have used the tracking features that the device has. 
- Created box plots in R to show the correlation of people who track data more often and living a heathier lifestyle.
- Created a presentation in Google Slides

---

## Files in this repo
- All original datasets and tables created from SQL are included
- `BellabeatMarketingStrategy.pdf` — project report and summary
- `BellabeatMatketingAnalysis.sql` — SQL code
- `bellabeatBoxPlots.R` — R code

---

## Key findings (summary)
- There is a positive correlation between users who track health metrics and living a healthier lifestyle than users who do not track.  

---

## How to run / open
1. Download `FitBitData.zip` and extract all files. Open all of the files in SQL and run the code from `BellabeatMatketingAnalysis.sql`
2. Download the other .csv files that that came from the analysis in SQL. Import those into RStudio and run `bellabeatBoxPlots.R`

---

## Notes and privacy
- Sensitive or personally-identifying information has been removed/anonymized.  

---
