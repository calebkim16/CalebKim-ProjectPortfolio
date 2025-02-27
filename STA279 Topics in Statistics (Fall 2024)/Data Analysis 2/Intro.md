# 📦 Amazon Review Analysis Lab

## 📝 Overview
This lab focuses on analyzing Amazon product reviews using **Natural Language Processing (NLP)** techniques. The goal is to extract meaningful insights from customer reviews and determine sentiment polarity. 

## 🔍 Objectives
- 🏷️ **Preprocess** text data by removing stopwords, punctuation, and performing tokenization.
- 📊 **Analyze** word frequency and sentiment distribution.
- 🤖 **Apply** classification techniques to categorize reviews as positive or negative.
- 📈 **Visualize** results using plots.

## 🛠️ Methods
### 1️⃣ Data Preprocessing
- Convert text to lowercase.
- Remove punctuation and stopwords.
- Tokenize and lemmatize words.

### 2️⃣ Sentiment Analysis
- Use **VADER (Valence Aware Dictionary and sEntiment Reasoner)** for polarity scoring.
- Label reviews as **positive**, **negative**, or **neutral** based on sentiment scores.

### 3️⃣ Feature Engineering
- Extract word frequencies and **TF-IDF (Term Frequency-Inverse Document Frequency)** values.
- Generate word clouds to visualize the most frequent words.

### 4️⃣ Classification Model
- Implement **Logistic Regression** for binary sentiment classification.
- Evaluate model accuracy using **precision, recall, and F1-score**.

## 📊 Results & Observations
- Most reviews were **positively skewed** (more positive than negative reviews). ✅
- Common words in **positive reviews** included: `love`, `great`, `excellent`. 💖
- Common words in **negative reviews** included: `poor`, `bad`, `disappointed`. ❌
- Logistic Regression achieved an **accuracy of XX%** (depending on dataset).

## 📌 Conclusion
- Sentiment analysis helps businesses understand customer opinions and improve products. 🎯
- Further improvements can be made using **deep learning models** (e.g., LSTMs, BERT). 🧠
