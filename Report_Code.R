## Is there a relationship between income level and trust?
getwd()
setwd("D:/CEU_MA_EDP/Winter 2025/AI for EDP") 
list.files()  # This shows all files in the folder
WVS_data <- read.csv("WVS_GDP_merged_data.csv", stringsAsFactors = FALSE)

head(WVS_data)    # View the first few rows of the dataset
str(WVS_data)     # Check the structure of the dataset
summary(WVS_data) # Summary statistics

## Think in terms of two variables. 1. Pick a single variable or a combined index of variables 2. Pick a GDP variable 
# For a single item, e.g., Q64
WVS_data$Q64_rev <- 5 - WVS_data$Q64
# Explanation: if Q64 = 1 (a great deal), then Q64_rev = 4 (high trust)
#              if Q64 = 4 (none at all), then Q64_rev = 1 (low trust)

library(dplyr)

WVS_data <- WVS_data %>%
  mutate(
    Q64_rev = 5 - Q64,
    Q65_rev = 5 - Q65,
    Q66_rev = 5 - Q66,
    Q67_rev = 5 - Q67,
    Q68_rev = 5 - Q68,
    Q69_rev = 5 - Q69,
    Q70_rev = 5 - Q70,
    Q71_rev = 5 - Q71,
    Q72_rev = 5 - Q72,
    Q73_rev = 5 - Q73,
    Q74_rev = 5 - Q74
  ) %>%
  
  # Now standardize these reversed items:
  mutate(across(ends_with("_rev"), scale)) %>%
  # Create the average trust score:
  mutate(avg_trust = rowMeans(select(., ends_with("_rev")), na.rm = TRUE))

df_agg <- WVS_data %>%
  group_by(B_COUNTRY_ALPHA) %>%
  summarise(
    income_satisfaction = mean(Q50, na.rm = TRUE),
    avg_trust = mean(avg_trust, na.rm = TRUE)
  )

model_inst <- lm(avg_trust ~ income_satisfaction, data = df_agg)
summary(model_inst)

library(broom)
# Convert regression results into a data frame
reg_table <- tidy(model_inst)
print(reg_table)
tidy(model_inst, conf.int = TRUE)


## Create one carefully designed graph to illustrate the relationship (Graph 1)
library(ggplot2)
ggplot(df_agg, aes(x = income_satisfaction, y = avg_trust)) +
  geom_point(size = 3, alpha = 0.7) +
  geom_smooth(method = "lm", se = TRUE, color = "blue") +
  labs(title = "Income Satisfaction vs. Institutional Trust",
       x = "Income Satisfaction (GDP Variable)",
       y = "Average Institutional Trust (Reversed)") +
  theme_minimal()


## Use population to show heterogeneity by groups. (For an extra point add continents and show heterogeneity accordingly instead). Show this in another graph (Graph 2).
# Load necessary libraries
library(dplyr)
library(ggplot2)

unique(WVS_data$B_COUNTRY_ALPHA)

df_agg <- WVS_data %>%
  group_by(B_COUNTRY_ALPHA) %>%
  summarise(
    income_satisfaction = mean(Q50, na.rm = TRUE),  # GDP proxy
    avg_trust = mean(avg_trust, na.rm = TRUE),
    Population = mean(Population, na.rm = TRUE)  # Ensure Population is included
  )


# Create a data frame mapping ISO3 country codes to continents
continent_df <- data.frame(
  ISO3 = c("ALB", "AND", "ARG", "ARM", "AUS", "AUT", "AZE", "BGD", "BLR", "BEL",
           "BOL", "BIH", "BRA", "BGR", "CAN", "CHL", "CHN", "COL", "HRV", "CYP",
           "CZE", "DNK", "ECU", "EGY", "EST", "ETH", "FIN", "FRA", "GEO", "DEU",
           "GBR", "GRC", "GTM", "HKG", "HUN", "ISL", "IND", "IDN", "IRN", "IRQ",
           "ITA", "JPN", "JOR", "KAZ", "KEN", "KGZ", "LBN", "LBY", "LTU", "LUX",
           "MAC", "MDV", "MEX", "MNG", "MNE", "NLD", "NZL", "NIC", "NIR", "NOR",
           "PAK", "PER", "PHL", "PRI", "POL", "PRT", "ROU", "RUS", "SGP", "SRB",
           "SVK", "SVN", "KOR", "ESP", "SWE", "CHE", "TWN", "TJK", "THA", "TUN",
           "TUR", "UKR", "USA", "URY", "UZB", "VEN", "VNM", "ZWE"),
  Continent = c("Europe", "Europe", "South America", "Asia", "Oceania", "Europe", "Asia", "Asia", "Europe", "Europe",
                "South America", "Europe", "South America", "Europe", "North America", "South America", "Asia", "South America", "Europe", "Europe", 
                "Europe", "Europe", "South America", "Africa", "Europe", "Africa", "Europe", "Europe", "Asia", "Europe",
                "Europe", "Europe", "North America", "Asia", "Europe", "Europe", "Asia", "Asia", "Asia", "Asia",
                "Europe", "Asia", "Asia", "Asia", "Africa", "Asia", "Asia", "Africa", "Europe", "Europe",
                "Asia", "Asia", "North America", "Asia", "Europe", "Europe", "Oceania", "North America", "Europe", "Europe",
                "Asia", "South America", "Asia", "North America", "Europe", "Europe", "Europe", "Europe", "Asia", "Europe",
                "Europe", "Europe", "Asia", "Europe", "Europe", "Europe", "Asia", "Asia", "Asia", "Africa", 
                "Asia", "Europe", "North America", "South America", "Asia", "South America", "Asia", "Africa")
)

# Ensure both columns have the same length
nrow(continent_df)  

# Merge continent data with df_agg using ISO3 country codes
df_agg <- merge(df_agg, continent_df, by.x = "B_COUNTRY_ALPHA", by.y = "ISO3", all.x = TRUE)

# Check if merging was successful
head(df_agg)


# Run an updated regression model including Continent and Population
model_updated <- lm(avg_trust ~ income_satisfaction + Continent + Population, data = df_agg)
# Show regression summary
summary(model_updated)

reg_table <- tidy(model_updated)
print(reg_table)
tidy(model_updated, conf.int = TRUE)


# Remove NA values for Continent
df_agg_clean <- df_agg %>% 
  filter(!is.na(Continent))  # Remove missing continent values

# Enhanced visualization for better readability
ggplot(df_agg_clean, aes(x = income_satisfaction, y = avg_trust, color = Continent)) +
  geom_point(aes(size = Population), alpha = 0.5, shape = 21, stroke = 0.5) +  # Improved point appearance
  geom_smooth(method = "lm", se = FALSE, aes(group = Continent), linewidth = 1.2, linetype = "solid") +  # Smoother trend lines
  scale_size_continuous(range = c(3, 10)) +  # Keeps bubbles reasonable size
  scale_color_manual(values = c("Africa" = "red", "Asia" = "gold", "Europe" = "green",
                                "North America" = "blue", "Oceania" = "purple", "South America" = "pink")) +  # Better colors
  labs(title = "Income Satisfaction vs. Institutional Trust",
       subtitle = "Colored by Continent, Bubble Size Represents Population",
       x = "Income Satisfaction (GDP Variable)",
       y = "Average Institutional Trust",
       size = "Population",
       color = "Continent") +
  theme_minimal(base_size = 14) +  # Clean theme with larger font
  theme(legend.position = "bottom",  # Move legend to bottom
        plot.title = element_text(face = "bold", size = 16),
        plot.subtitle = element_text(size = 12))

## Think about a causal link. 
# Adding Control Variables
df_agg_causal <- WVS_data %>%
  group_by(B_COUNTRY_ALPHA) %>%
  summarise(
    income_satisfaction = mean(Q50, na.rm = TRUE),  # GDP proxy
    avg_trust = mean(avg_trust, na.rm = TRUE),
    Population = mean(Population, na.rm = TRUE),  # Ensure Population is included
    Family_Importance = mean(Q1, na.rm = TRUE),
    Friends_Importance = mean(Q2, na.rm = TRUE),
    Happiness_Level = mean(Q46, na.rm = TRUE),
    Life_Satisfaction = mean(Q47, na.rm = TRUE),
    Trust_Others = mean(Q57, na.rm = TRUE),
    Confidence_Government = mean(Q71, na.rm = TRUE),
    Confidence_Media = mean(Q78, na.rm = TRUE),
    Political_Interest = mean(Q89, na.rm = TRUE)
  )
df_agg_causal <- merge(df_agg_causal, continent_df, by.x = "B_COUNTRY_ALPHA", by.y = "ISO3", all.x = TRUE)
summary(df_agg_causal)

#  Run the updated regression model
model_causal <- lm(avg_trust ~ income_satisfaction + Population + Continent+
                     Family_Importance + Friends_Importance + 
                     Happiness_Level + Life_Satisfaction + 
                     Trust_Others + Confidence_Government + 
                     Confidence_Media + Political_Interest, data = df_agg_causal)

# Display results
summary(model_causal)

# Interaction Model: Testing If the Effect Varies Across Continents
# Run interaction model: Does income satisfaction affect trust differently by continent?
model_interaction <- lm(avg_trust ~ income_satisfaction * Continent, data = df_agg_causal)
# Display the results
summary(model_interaction)

reg_table <- tidy(model_interaction)
print(reg_table)
tidy(model_interaction, conf.int = TRUE)

# Addressing Endogeneity (Reverse Causality)
# Instrumental Variable (IV) Approach
# Load the AER package for IV regression
library(AER)

# Step 1: First-stage regression (Predict income satisfaction using Population)
first_stage <- lm(income_satisfaction ~ Population, data = df_agg)
# Step 2: Second-stage regression (Predict avg_trust using predicted income satisfaction)
iv_model <- ivreg(avg_trust ~ income_satisfaction | Population, data = df_agg)
# Display IV regression results
summary(iv_model)



