from threading import Thread, Lock
from multiprocessing import Process, Pool
from queue import Queue

cdef class IterableQueue:
    """Make the queue iterable.

    Parameters
    ----------
    maxsize : int
        Max size of the queue
    tries : int
        Number of times to try when the queue is empty
    wait_time : float
        Time (in seconds) between each try

    """
    cdef:
        dict params
        int tries
        float wait_time
        object queue


    cpdef _next(self)

    cpdef int qsize(self)

    cpdef void put(self, item)
