# Impact Evaluation

## Executive Summary
This project leveraged the Reality Check (RC) data to analyse how different concerns and attitudes, such as long-term optimism, influence different consumer mindsets in the current socio-economic climate. By identifying key drivers for mindsets like "Confident" and "Resentful," the analysis offers actionable insights that can improve targeted marketing strategies for clients. The potential impact on client revenue is significant, with estimated gains of up to £20 million across 20 clients. While the study faced limitations such as class imbalance, it provides a strong foundation for future, more sophisticated analyses.

## Introduction
The RC data began as a COVID-19 tracker in March 2020. However, by 2023, it had evolved into a UK-wide segmentation survey that groups people based on their resilience levels and how the cost-of-living crisis has impacted their attitudes and behaviours. The sharp rise in inflation in 2022 triggered this crisis, leading to significant shifts in spending habits, with 86% of UK adults expressing concern about their daily living costs.(1,2) The RC survey consists of six mindsets or segments: Surviving, Frustrated, Resentful, Coping, Carefree and Confident. Currently, RC is a quarterly tracker, and this project focuses on data from Q2 2024. An earlier analysis of the Q3 2023 RC data did not explore these mindsets in detail. This project aims to build upon the previous work by delving deeper into the mindsets and the factors that drive them. By gaining a clearer understanding of these segments, the media agency can better assist clients in refining their marketing strategies and improving business key performance indicators (KPIs).

## Methodology
### Hypothesis
H0: There is no statistically significant relationship between different mindsets and various concerns and attitudes.
H1: There is at least one statistically significant relationship between mindsets and various concerns and attitudes.
In this context, the concerns and attitudes refer to a wide range factors, such as long-term optimism, worries about economic conditions, personal and financial wellbeing, social issues, and more specific anxieties (e.g., artificial intelligence).

### Data Workflow
![etl workflow](assets/img/Picture1.png)

Figure 1. Diagram of the ETL pipeline. Capabilities include analytics and insights. 

The project demonstrates key ETL concepts, emphasising the importance of efficient data sourcing, extraction, transformation and loading. Streamlining this via R scripts ensure accurate data, which is crucial for achieving success in analysis and media planning for clients.

### Data Preparation and Analysis
The analysis began with a thorough preparation process, ensuring the dataset was clean, consistent, and suitable for logistic regression modelling. The most recent dataset, Q2 2024, was selected for analysis. To maintain data quality, duplicate columns were removed, missing values were handled, and variables were appropriately coded. Continuous variables with fewer than 100 missing values were retained, resulting in 56 predictors. This careful selection ensured a manageable predictor-to-target ratio (10 to 1), enhancing the model's stability and accuracy.(3)

Following data preparation, exploratory data analysis (EDA) was conducted to identify potential issues, such as class imbalance (see Figures 2 and 3). While class imbalance was present in most datasets, it was not addressed due to project simplicity and time constraints. Multicollinearity, a critical element of modelling, was assessed, and variables with high variance inflation factors (VIFs) were removed from the dataset.(4)

![Surviving Class Distribution](assets/img/Picture2.png)

Figure 2. Target Class Distribution in the Surviving Segment. This chart shows that there is a class imbalance.

![Surviving Data Profile](assets/img/Picture3.png)

Figure 3. Data Profile of the Surviving Segment. This was created using the DataExplorer R package. There are no missing data, as expected.

Logistic regression was chosen over linear regression due to its suitability for classification problems and ability to handle both binary and continuous variables.(5) Separate logistic regression models were built for each mindset segment, with the dependent variable indicating segment membership. Independent variables included selected predictors, such as concerns about housing prices and the economy. 

Model evaluation involved generating predictions, creating ROC curves to determine optimal thresholds, and analysing confusion matrices to assess model performance. Performance metrics such as accuracy, precision, recall, and F1 scores were calculated for each model. This approach enables toe capture of nuanced differences between mindsets and provides probabilistic predictions for each respondent’s likelihood of belonging to a mindset.

Ethical considerations and data privacy concerns were upheld in this analysis. The survey data did not contain any personally identifiable information (PII), ensuring that the respondents’ identities remained confidential. Each observation was anonymised and represented by a unique identifier, safeguarding user privacy. This aligns with best practices within both the Data Protection Act (DPA) 2018 and General Data Protection Regulation (GDPR).(6,7)

## Results


## References
1.	[UK Consumers and The Cost of Living Market Report](https://store.mintel.com/report/uk-consumers-and-the-cost-of-living-market-report)
2.	[How The Cost of Living Crisis is Changing People's Behaviours](https://www.pwc.co.uk/services/risk/rethink-risk/insights/how-the-cost-of-living-crisis-is-changing-people-s-behaviours-an.html)
3.	[Ref3](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7032893/)
4.	[Removing Multi Collinearity for Linear and Logistic Regression](https://medium.com/analytics-vidhya/removing-multi-collinearity-for-linear-and-logistic-regression-f1fa744f3666)
5.	[A Basic Guide to Logistic Regression](https://godatadrive.com/blog/a-basic-guide-to-logistic-regression)
6.	[Personal Data](https://gdpr-info.eu/issues/personal-data/)
7.	[Data Protection](https://www.gov.uk/data-protection)
8.	https://www.iguazio.com/glossary/classification-threshold/
9.	Topic 7 DSPP lecture.
10.	https://neptune.ai/blog/how-to-deal-with-imbalanced-classification-and-regression-data 
11.	https://www.scribbr.co.uk/bias-in-research/nonresponse-bias-explained/
12.	https://www.scribbr.co.uk/bias-in-research/what-is-recall-bias/
13.	https://medium.com/@nischitasadananda/the-battle-between-logistic-regression-random-forest-classifier-xg-boost-and-support-vector-46d773c70f41
