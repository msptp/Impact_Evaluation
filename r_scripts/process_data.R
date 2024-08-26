#### DATA PROCESSING SCRIPT ####
# 1. Setup ----
## load packages
library(haven)
library(dplyr)
library(readxl)
library(DataExplorer)
library(car)
library(ggplot2)
library(ROSE)

## set working directory
setwd("C:/Users/Sally.Pham/OneDrive - insidemedia.net/Documents/Personal Development/BPP University/BSc Data Science 1.0/Data Science Professional Practice/0. Assignments/Summative/1. Data/")

# 2. Read in data ----
## read in raw data spss files
raw <- read_sav("1. Raw/Reality Check/Q2 2024 SPSS.sav")

## renaming column names
column_labels <- sapply(raw, function(x) attr(x, "label"))
names(raw) <- column_labels

## output raw dataset
#write.csv(raw, "1. Raw/Reality Check/q22024_raw.csv")

# 3a. Process Data - Data Quality ----

## check for duplicated column names and remove them
duplicate_columns <- names(raw)[duplicated(names(raw))]
raw2 <- raw[, !duplicated(names(raw))]

## extract column names to create a lookup that tells us which columns to keep
colnames <- colnames(raw2)
#write.csv(colnames, "1. Raw/Reality Check/q22024_colnames.csv")

## read in lookup and remove unwanted columns
lookup <- read_excel("1. Raw/Reality Check/lookup.xlsx")

lookup <- lookup[lookup$keep == "yes", ]
columns_to_keep <- lookup$column_name

filtered_raw <- raw2[, columns_to_keep]

## handle missing values / NAs - remove rows with NAs in any of the columns to get a full dataset
final_raw <- na.omit(filtered_raw)

## output final raw dataset
#write.csv(final_raw, "1. Raw/Reality Check/q22024_raw_clean.csv")


# 3b. Process Data - Data Prep ----
## convert RC Mindsets into separate binary variables - these will become target vars
final_raw$RC_Surviving <- ifelse(final_raw$`RC Mindset Segments` == 1, 1, 0)
final_raw$RC_Frustrated <- ifelse(final_raw$`RC Mindset Segments` == 2, 1, 0)
final_raw$RC_Resentful <- ifelse(final_raw$`RC Mindset Segments` == 3, 1, 0)
final_raw$RC_Coping <- ifelse(final_raw$`RC Mindset Segments` == 4, 1, 0)
final_raw$RC_Carefree <- ifelse(final_raw$`RC Mindset Segments` == 5, 1, 0)
final_raw$RC_Confident <- ifelse(final_raw$`RC Mindset Segments` == 6, 1, 0)

## create a list of target vars that will be used in a function to create 6 separate datasets
# each including a target variable
target_vars <- c("RC_Surviving", "RC_Frustrated", "RC_Resentful", "RC_Coping", "RC_Carefree", "RC_Confident")

## create a list to store the datasets
datasets <- list()

## loop through each target variable and create a dataset
for (target in target_vars) {
  datasets[[target]] <- final_raw %>%
    mutate(target = .[[target]]) %>%
    select(-`RC Mindset Segments`, -starts_with("RC_"), target)  # Exclude `RC Mindset Segments` and all `RC_` columns except the target
}


## get datasets
RC_Surviving <- datasets[["RC_Surviving"]]
RC_Frustrated <- datasets[["RC_Frustrated"]]
RC_Resentful <- datasets[["RC_Resentful"]]
RC_Coping <- datasets[["RC_Coping"]]
RC_Carefree <- datasets[["RC_Carefree"]]
RC_Confident <- datasets[["RC_Confident"]]

## convert all variables to a numerical data type
RC_Surviving[] <- lapply(RC_Surviving, as.numeric)
RC_Frustrated[] <- lapply(RC_Frustrated, as.numeric)
RC_Resentful[] <- lapply(RC_Resentful, as.numeric)
RC_Coping[] <- lapply(RC_Coping, as.numeric)
RC_Carefree[] <- lapply(RC_Carefree, as.numeric)
RC_Confident[] <- lapply(RC_Confident, as.numeric)


## 3c. Process Data - EDA

# create charts to understand distribution of target vars - is there a class imbalance?
table(RC_Surviving$target)
ggplot(RC_Surviving, aes(x = target)) + geom_bar() + ggtitle("RC_Surviving Target Class Distribution")

table(RC_Frustrated$target)
ggplot(RC_Frustrated, aes(x = target)) + geom_bar() + ggtitle("RC_Frustrated Target Class Distribution")

table(RC_Resentful$target)
ggplot(RC_Resentful, aes(x = target)) + geom_bar() + ggtitle("RC_Resentful Target Class Distribution")

table(RC_Coping$target)
ggplot(RC_Coping, aes(x = target)) + geom_bar() + ggtitle("RC_Coping Target Class Distribution")

table(RC_Carefree$target)
ggplot(RC_Carefree, aes(x = target)) + geom_bar() + ggtitle("RC_Carefree Target Class Distribution")

table(RC_Confident$target)
ggplot(RC_Confident, aes(x = target)) + geom_bar() + ggtitle("RC_Confident Target Class Distribution")

## create charts to understand data (general)
plot_intro(RC_Surviving)
plot_intro(RC_Frustrated)
plot_intro(RC_Resentful)
plot_intro(RC_Coping)
plot_intro(RC_Carefree)
plot_intro(RC_Confident)

## check for multicollinearity
vif_values <- vif(lm(target ~ ., data = RC_Surviving)) # calculate VIF
high_vif <- names(vif_values[vif_values > 5]) # identify high VIF predictors
print(high_vif)

vif_values <- vif(lm(target ~ ., data = RC_Frustrated))
high_vif <- names(vif_values[vif_values > 5])
print(high_vif)

vif_values <- vif(lm(target ~ ., data = RC_Resentful))
high_vif <- names(vif_values[vif_values > 5])
print(high_vif)

vif_values <- vif(lm(target ~ ., data = RC_Coping))
high_vif <- names(vif_values[vif_values > 5])
print(high_vif)

vif_values <- vif(lm(target ~ ., data = RC_Carefree))
high_vif <- names(vif_values[vif_values > 5])
print(high_vif)

vif_values <- vif(lm(target ~ ., data = RC_Confident))
high_vif <- names(vif_values[vif_values > 5])
print(high_vif)


# # 3d. Process Data - SMOTE (commented out as it was not used)----
# ## clean column names
# colnames(RC_Surviving) <- make.names(colnames(RC_Surviving), unique = TRUE)
# colnames(RC_Frustrated) <- make.names(colnames(RC_Frustrated), unique = TRUE)
# colnames(RC_Resentful) <- make.names(colnames(RC_Resentful), unique = TRUE)
# colnames(RC_Coping) <- make.names(colnames(RC_Coping), unique = TRUE)
# colnames(RC_Carefree) <- make.names(colnames(RC_Carefree), unique = TRUE)
# colnames(RC_Confident) <- make.names(colnames(RC_Confident), unique = TRUE)
# 
# ## apply SMOTE to all datasets except RC_confident
# RC_Surviving$target <- as.factor(RC_Surviving$target)
# RC_Frustrated$target <- as.factor(RC_Frustrated$target)
# RC_Resentful$target <- as.factor(RC_Resentful$target)
# RC_Coping$target <- as.factor(RC_Coping$target)
# RC_Carefree$target <- as.factor(RC_Carefree$target)
# RC_Confident$target <- as.factor(RC_Confident$target)
# 
# RC_Surviving_smote <- ovun.sample(target ~ ., data = RC_Surviving, method = "under")$data
# 
# RC_Frustrated_smote <- ovun.sample(target ~ ., data = RC_Frustrated, method = "under")$data
# 
# RC_Resentful_smote <- ovun.sample(target ~ ., data = RC_Resentful, method = "under")$data
# 
# RC_Coping_smote <- ovun.sample(target ~ ., data = RC_Coping, method = "under")$data
# ()
# RC_Carefree_smote <- ovun.sample(target ~ ., data = RC_Carefree, method = "under")$data
# 
# ## RC_Confident remains unchanged
# RC_Confident_smote <- RC_Confident
# 
# 
# ## check class distribution - they should all be close to 50:50
# table(RC_Surviving_smote$target)
# table(RC_Frustrated_smote$target)
# table(RC_Resentful_smote$target)
# table(RC_Coping_smote$target)
# table(RC_Carefree_smote$target)
# table(RC_Confident_smote$target)



# 4. Output final processed datasets ----

write.csv(RC_Surviving, "2. Processed/Reality Check/RC_Surviving.csv")
write.csv(RC_Frustrated, "2. Processed/Reality Check/RC_Frustrated.csv")
write.csv(RC_Resentful, "2. Processed/Reality Check/RC_Resentful.csv")
write.csv(RC_Coping, "2. Processed/Reality Check/RC_Coping.csv")
write.csv(RC_Carefree, "2. Processed/Reality Check/RC_Carefree.csv")
write.csv(RC_Confident, "2. Processed/Reality Check/RC_Confident.csv")



