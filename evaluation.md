how to evaluation performance?
  8 Evaluation in information retrieval: https://nlp.stanford.edu/IR-book/pdf/08eval.pdf
    precision/recall (page 155)
    precision/recall graph, 11-point interpolated average, ROC (page 158-162)


  confusion matrix
    "An important tool for analyzing the performance of a classifier forJ>2classes is thec onfusion matrix." (see table 14.5)
      page 307: https://nlp.stanford.edu/IR-book/pdf/14vcat.pdf

  precision/recall

  interpretability
    "Often we want to know more than just the correct classification of an observation. We want to know why the classifier made the decision it did.  That is, we want ourdecision to be interpretable. Interpretability can be hard to define strictly, but the core idea is that as humans we should know why our algorithms reach the conclu-sions they do."
      page 17: https://web.stanford.edu/~jurafsky/slp3/5.pdf


  similarity / vector semantics / embeddings: https://web.stanford.edu/~jurafsky/slp3/6.pdf
    "In this chapter we’ll introduce the two most commonly used models. In the tf-idfmodel, an important baseline, the meaning of a word is defined by a simple function of the counts of nearby words.  We will see that this method results in very long vectors that aresparse, i.e.  mostly zeros (since most words simply never occur in the context of others). We’ll introduce the word2vec model family for constructing short, dense vectors that have useful semantic properties. We’ll also introduce the cosine, the standard way to use embeddings to compute semantic similarity, between two words, two sentences, or two documents, an important tool in practical applications like question answering, summarization, or automatic essay grading."
      page 6: https://web.stanford.edu/~jurafsky/slp3/6.pdf

    6.3.2 Words as vectors: document dimensions

    "To measure similarity between two target words v and w, we need a metric that takes two vectors...and gives a measure of their similarity. By far the most common similarity metric is the cosine of the angle between the vectors." 
      page 10: https://web.stanford.edu/~jurafsky/slp3/6.pdf

    "The tf-idf model of meaning is often used for document functions like deciding if two documents are similar. We represent a document by taking the vectors of all the words in the document, and computing the centroid of all those vectors."
      page 17: https://web.stanford.edu/~jurafsky/slp3/6.pdf

    6.12 Evaluating Vector Models
    "The most important evaluation metric for vector models is extrinsic evaluation on tasks, i.e., using vectors in an NLP task and seeing whether this improves performance over some other model. Nonetheless it is useful to have intrinsic evaluations."
      page 27: https://web.stanford.edu/~jurafsky/slp3/6.pdf

