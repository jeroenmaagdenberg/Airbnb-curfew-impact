#regression and analysis ideas price is dependent variable 

# packages
library(ggplot2)
library(ggfortify)
library(broom)
library(dplyr)
library(readr)
library(stargazer)
library(modelsummary)

# --- loading curfew data ---#
Curfew_Amsterdam <- read_csv("./gen/data_prep/output/Curfew_Amsterdam.csv")

# --- Linear Regression models --- #

# --- Checking effect curfew and smaller curfew window --- #
m1 <- lm(price ~ 1 + curfew + host_is_superhost, data = Curfew_Amsterdam)
m2 <- lm(price ~ 1 + curfew_2100 + curfew_2200 + host_is_superhost, data = Curfew_Amsterdam)
m3 <- lm(price ~ 1 + curfew_2100 + curfew_2200 + host_is_superhost + neighbourhood, data = Curfew_Amsterdam)
m4 <- lm(price ~ 1 + curfew + curfew_2200 + host_is_superhost + neighbourhood, data = Curfew_Amsterdam) #this one or m3?

table_m1_m2_m3 <- msummary(list(m1, m2, m3))
table_m1_m2_m3

# Checking model assumptions
autoplot(m3,which = 1:3,nrow = 1,ncol = 3)

#fig1 data points should center around the horizontal axis
#fig2 second requirement is that the residuals are approximately normally distributed
#fig3 check here if there is any pattern that stands out
#volgens ons kloppen alle 3 de reqs

# outliers screening

pot_outliers <- m3 %>%
  augment() %>%
  select(price, curfew_2100, curfew_2200, host_is_superhost, neighbourhood, leverage = .hat, cooks_dist = .cooksd) %>%
  arrange(desc(cooks_dist)) %>%
  head()
pot_outliers

#very low values, no outliers in data

# check p-values
stargazer(m1, m2, m3,
          title = "Figure 1: Curfew effect on Airbnb Prices",
          dep.var.caption = "Airbnb Pricing",
          dep.var.labels = "",
          column.labels = c("Original Curfew", "Later Curfew"),
          notes.label = "Significance levels",
          type = 'text') #update after asking Hannes about which model we need to use.

stargazer(m1, m2, m3, type = 'text')  

# store output
dir.create(("gen/paper"), showWarnings = FALSE)
dir.create(("gen/paper/output"), showWarnings = FALSE)

pdf("gen/paper/output/test_output.pdf")  ##### gives empty pdf but it works #####