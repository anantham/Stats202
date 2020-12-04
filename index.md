## A Comparison of Various Binary Classifiers

This project was done as part of the course [stats202](https://web.archive.org/web/20140922050041/https://sites.google.com/site/stats202/course-information) taken by [Professor Rajan Patel](https://ai.google/research/people/author37597) during the Stanford Summer Session 2016 which I attended.

### Objective

To train a binary classifier with $10$ signals which are in some way properties of "the query" as well as "the web page". For example the first two signals are query_length ( a property solely of the query ) and is_homepage ( a property solely of the webpage ), likewise the remaining $8$ signals - $sig1, sig2, ... sig8$ are some unknown function of both "the query" as well as "the web page". This obfuscation was delibrate to ensure we built a classifier that would generalize well beyond this specific data.

### My Approach

I converted the integer data types is_homepage and relevance into factor datatypes as the assumption of ordered values is false. I used log (x + 1) transformation to make the skewed distributions (signals 3,4,5,6) more normal. I removed the first two columns - query_id and url_id since they are just unique identifiers for queries and web pages. 

I found sig 5 is correlated with sig 6 but removing either did not help in any of the models I trained. So in variable selection stage I used all the signals.

I used the caret library to train the models, with 2325 as my seed for randomness. I managed to get the error down to the following values.

![error](https://i.imgur.com/s5TarqM.png)

I used 9 fold cross validation to select the optimal tuning parameters for boosting. I used the Area Under the Curve (AUC) of the ROC as the metric to minimize. So Boosting gave me the best classifier and I attribute the success of this model to the fact that it reduces bias while not increasing variance of the model.

