# cython: language_level = 3
# distutils: language = c++

from random import shuffle
from multiprocessing import Pool

from word2vec_vi.utils.text_utils import sent_tokenizer, word_tokenizer


cpdef void line_process(str data_src, list queues, dict params):
    """Start reading text file from `data_src` and process one line at a time.

    Parameters
    ----------
    data_src : str
        Path to the text file.
    queues : list
        List of queues.
    params : dict
        Dictionary containing all parameters needed for training.

    """
    cdef:
        int i
        str line
        list lines, container = []

    with open(data_src, "r", encoding="utf-8") as fin:
        lines = fin.readlines()
    shuffle(lines)

    params["n_lines"] = len(lines)
    params["start"] = True


    for i, line in enumerate(lines):
        container.append(line)

        if len(container) == params["num_process"]:
            params["n_lines_processed"] = i
            queues[0].put(sent_tokenizer(container))
            container = []
    # Finalize
    if len(container) != 0:
        queues[0].put(sent_tokenizer(container))
    params["end"] = True


cpdef void word_process(list queues, list sentences, dict params):
    """Tokenize sentences (which are extracted by `sent_tokenizer`) into words.

    Parameters
    ----------
    queues : list
        List of queues.
    sentences : list
        A list of tokenized sentences (that is, a list of list of words).
    params : dict
        Dictionary containing all parameters needed for training.

    """
    cdef list s
    pool = Pool(processes=2)

    for s in queues[0]:
        words = pool.map(word_tokenizer, s)
        sentences.extend(words)

    params["stop"] = True
