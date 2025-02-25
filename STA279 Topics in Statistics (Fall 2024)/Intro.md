# STA279 - Data Analysis 1 (Fall 2024)

## 📍 Course Overview
During Fall 2024, I took **STA279 - Data Analysis 1** at **Wake Forest University**. This course focused on applying statistical methods and data analysis techniques using **R** for real-world data problems.

## 🔎 Project Overview
In this project, we analyzed data from the **Federalist Papers** to investigate the authorship of the papers written by **James Madison** and **Alexander Hamilton**. The goal was to use various data analysis techniques, including logistic regression and text mining, to determine patterns in the text and accurately predict the authors of the papers.

### 🔧 Tools & Libraries Used
- **R** 🦸‍♂️
- **tidytext** 📚
- **dplyr** 🔧
- **ggplot2** 📊
- **tidyr** 🧹
- **tm** 🧳
- **forcats** 🏷️

### 🔢 Key Techniques:
1. **Word Count Analysis**: We compared the word counts of papers written by both authors.
2. **Logistic Regression**: We used the number of words in each paper to predict whether it was written by Madison or Hamilton.
3. **Top Word Frequency**: We analyzed the most frequent words used in the writings of Madison and Hamilton to see if there were any distinctive patterns.
4. **Model Evaluation**: We evaluated the models based on accuracy, true positive rate (TPR), and true negative rate (TNR).

## 📈 Key Findings
- **Word Count Comparison**: Madison's papers were generally longer, but Hamilton's longest papers were significantly longer.
- **Logistic Regression**: The model predicted the authorship of the papers with around **75% accuracy**.
- **Top Words Analysis**: Common words like "government", "power", and "union" appeared in both authors' writings, but there were some unique words that distinguished each author.

## 🔄 Final Model
The third model, which included both the word count and the top 14 most frequent words used by both authors, achieved **100% accuracy** in predicting authorship.

## 💡 Conclusion
The analysis suggests that Hamilton's claim of writing all 15 articles in the test set is likely untrue, as some of the articles were predicted to be written by Madison.

## 👨‍💻 Collaborators
- **Caleb Kim** (Me)
- **Adam Barrow**
