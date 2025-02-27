# STA279 - Data Analysis 3 Summary

**Name:** Caleb Kim  
**Date:** December 10, 2024

## Overview

This lab involves analyzing essays using Latent Dirichlet Allocation (LDA), text visualization, and logistic regression to predict authorship. The main objectives include:

- Topic modeling with LDA
- Visualizing word correlations
- Predicting authorship using statistical features

---

## Section 1: Topic Modeling with LDA

### Tokenization & Preprocessing
- Text was cleaned by removing punctuation and symbols.
- Tokenized text and created a document-term matrix.
- LDA model trained with **k = 2 topics**.

### Top Words in Each Topic
- A bar plot was created to visualize the top 10 words in each topic using **beta values**. 🎭

### Interpreting Topics
- **Topic 1:** Likely about plastic water bottle usage in India (words like "water," "bottled," "market").
- **Topic 2:** Related to career and jobs (words like "career," "job," "business").

### LDA Model Performance
- Used gamma estimates to predict topics for each essay.
- Confusion matrix showed a **98.58% accuracy rate**! ✅

---

## Section 2: Visualizing Connections

### Word Pair Correlation
- Most correlated words: "bottled" & "water" 💧
- Least correlated words: "bottled" & "career" 🚫

### Word Network Visualizations
- Used graphs to show clusters of related words.
- **Prompt 1:** Focused on research, communication, and family.
- **Prompt 2:** Centered on business, markets, and consumers.
- The graphs revealed thematic patterns that were different from LDA results!

---

## Section 3: Predicting Authorship

### Features Used:
- **Essay Length** 📏: Longer essays predicted as AI-generated.
- **Frequency of 'the'** 🔤: AI essays expected to use this filler word more.
- **Percentage of Unique Words** 📝: AI essays assumed to have higher unique word diversity.

### Logistic Regression Model
- Trained a multinomial logistic regression model.
- Key predictors: Big words & unique word percentage.

### Model Evaluation
- Confusion matrix showed **100% accuracy**! 🚀
- Model perfectly classified AI vs. human-written essays.

---

## Conclusion
- LDA effectively identified distinct topics, but some topics were better understood through word correlations.
- Word correlation networks provided insights into thematic structures.
- Logistic regression was extremely effective at predicting authorship.

✨ **Overall**, this lab demonstrated how text mining techniques can uncover hidden structures in textual data! 🔍📚
