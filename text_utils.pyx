from libcpp.string cimport string
from libcpp.vector cimport vector

import re


split_periods = re.compile("(?<=\.{2})\s*(?=[A-Z]+)")

cpdef vector[string] sent_tokenizer(string[] text):
    """Take a list of lines as input and produce a list of sentences.

    Parameters
    ----------
    text : list
        List of string.

    Returns
    -------
    list
        List of tokenized sentences.

    """
    cdef:
        int i
        string t, u
        string[] ts
        vector[string] container, ans

    for t in text:
        ts = sent_tokenize(t)
        for u in ts:
            container.push_back(u)
    for t in container:
        ts = split_periods.split(t)
        for u in ts:
            ans.push_back(u)
    return ans
