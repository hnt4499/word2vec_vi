# cython: language_level = 3
# distutils: language = c++

import re

from underthesea import sent_tokenize, word_tokenize

# Compile re modules
split_periods = re.compile("(?<=\.{2})\s*(?=[A-Z]+)")
re_punct = re.compile("[^\w\s]")
re_digit = re.compile("[\d]")

cpdef list sent_tokenizer(list text):
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
        str t, u
        list ts, container = [], ans = []

    for t in text:
        ts = sent_tokenize(t)
        for u in ts:
            container.append(u)
    for t in container:
        ts = split_periods.split(t)
        for u in ts:
            ans.append(u)
    return ans


cdef str remove(str text):
    """Remove whitespaces and digits from text.

    Parameters
    ----------
    text : str

    Returns
    -------
    str
        Cleaned text.

    """
    cdef str ans
    ans = re_punct.sub("", text)
    ans = re_digit.sub("", ans)
    return ans
