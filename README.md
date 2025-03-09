# Ibnat_Nahian_dawai_week03_Report

# README: Relationship Between Income Satisfaction and Institutional Trust

## **Dataset Information**
- Dataset Name: WVS_GDP_Merged_Data.csv
- Source: World Values Survey (WVS) merged with GDP indicators
- Location: `D:/CEU_MA_EDP/Winter 2025/AI for EDP/`
- File Path: `D:/CEU_MA_EDP/Winter 2025/AI for EDP/WVS_GDP_Merged_Data.csv`
- License: Open for academic use under the World Values Survey data policy
- 

## **Overview**
This dataset is used to analyze the relationship between individual income satisfaction and institutional trust. It contains various socio-economic, political, and demographic variables collected from multiple countries.

Data Type and Timeframe
- Type: Cross-sectional data (not panel)
- Survey Period: The WVS data were collected in different years depending on the country. The dataset does not track the same individuals over time, making it a purely cross-sectional dataset.

Handling Missing Data
- Missing values such as “-1”, “-2”, “-4”, and “-5” were recoded as NA.
- Rows with excessive missingness were excluded to ensure data quality.

## **Variable Descriptions**

### **Dependent Variable:**
| Variable Name       | Type       | WVS Question Code | Description |
|---------------------|------------|-------------------|-------------|
| Institutional Trust | Continuous | Q64–Q74          | Composite index created by averaging standardized scores of trust in institutions (e.g., government, media, judiciary). |

### **Independent Variable:**
| Variable Name       | Type       | WVS Question Code | Description |
|---------------------|------------|-------------------|-------------|
| Income Satisfaction | Continuous | Q50              | "How satisfied are you with the financial situation of your household?" (Scale: 1 = Dissatisfied, 10 = Satisfied) |

### **Control Variables:**
| Variable Name            | Type        | WVS Question Code | Description |
|--------------------------|------------|-------------------|-------------|
| Family Importance        | Ordinal    | Q1                | "How important is family in your life?" (Scale: 1-4) |
| Friends Importance       | Ordinal    | Q2                | "How important are friends in your life?" (Scale: 1-4) |
| Happiness Level          | Ordinal    | Q46               | "Overall happiness level?" (Scale: 1-4) |
| Life Satisfaction        | Ordinal    | Q47               | "Are you satisfied with life?" (Scale: 1-10) |
| Trust in Others          | Binary     | Q57               | "Can most people be trusted?" (1 = Yes, 0 = No) |
| Confidence in Government | Ordinal    | Q71               | "Confidence in government" (Scale: 1-4) |
| Confidence in Media      | Ordinal    | Q78               | "Confidence in the press/media?" (Scale: 1-4) |
| Political Interest       | Ordinal    | Q89               | "Interest in politics?" (Scale: 1-4) |

### **Heterogeneity Variables:**
| Variable Name | Type        | Description |
|--------------|------------|-------------|
| Population   | Continuous | Population size by country. |
| Continent    | Categorical| Countries grouped into continents (Africa, Asia, Europe, North America, South America, Oceania). |

## **Methodology**
- **OLS Regression**: Examines the relationship between income satisfaction and institutional trust.
- **Interaction Analysis**: Tests whether the effect varies across continents.
- **Instrumental Variable (IV) Approach**: Uses Population as an instrument for income satisfaction to address endogeneity concerns.

## **Regression Models**

### **OLS Regression Model:**
```r
lm(avg_trust ~ income_satisfaction + Continent + Family_Importance + Friends_Importance + Happiness_Level + Life_Satisfaction + Trust_Others + Confidence_Government + Confidence_Media + Political_Interest, data = df_agg)
```

### **Instrumental Variable (IV) Regression Model:**
```r
library(AER)
iv_model <- ivreg(avg_trust ~ income_satisfaction | Population, data = df_agg)
summary(iv_model)
```

## **File Structure**
- **`WVS_GDP_Merged_Data.csv`** - The main dataset.
- **`Report_Code.R`** - The R script used for analysis.
- **`Ibnat_Nahian_dawai_week03_Report.pdf`** - The research report with findings and interpretations.
- **`Scatterplot_relationship.png`, `Interaction (Population and Continent).png`** - Contains visualizations used in the report.
- **Regression Tables** - Detailed regression outputs from the analysis.

## **Usage Instructions**
1. Load the dataset into R using:
   ```r
   WVS_data <- read.csv("D:/CEU_MA_EDP/Winter 2025/AI for EDP/WVS_GDP_Merged_Data.csv")
   ```
2. Ensure all necessary libraries (`dplyr`, `ggplot2`, `AER`) are installed.
3. Run the provided R script (`Report_Code.R`) to reproduce results.
4. Check `Ibnat_Nahian_dawai_week03_Report.pdf` for insights and interpretations.
5. Check `Ibnat_Nahian_dawai_week03_advice_document.txt` for knowing my experience.
6. The `Ibnat_Nahian_dawai_week03_oneshot_prompt.txt` gives an idea of what AI can do without any complex command.

---
For further details, refer to the full research report.

