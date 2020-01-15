# cython: language_level = 3
# distutils: language = c++

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

    def __init__(self, dict params, int maxsize=1000,
                 int tries=5, float wait_time=0.1):
        self.params = params
        self.queue = Queue(maxsize=maxsize)
        self.tries = tries
        self.wait_time = wait_time

    def __iter__(self):
        return self

    cpdef _next(self):
        cdef:
            int tries = 0
            int qsize = self.queue.qsize()

        while qsize == 0 and tries < self.tries:
            time.sleep(self.wait_time)
            qsize = self.queue.qsize()

            if self.params["end"]:
                tries += 1
        if qsize == 0:
            raise StopIteration
        else:
            return self.queue.get()

    def __next__(self):
        return self._next()

    def get(self):
        return self.__next__()

    cpdef int qsize(self):
        return self.queue.qsize()

    cpdef void put(self, item):
        while self.queue.full():
            time.sleep(self.wait_time)
        self.queue.put(item)


class MultiThreads:
    def __init__(self, num_threads, *args, **kwargs):
        self.threads = [Thread(*args, **kwargs) for i in range(num_threads)]
    def start(self):
        for thread in self.threads:
            thread.start()
    def join(self):
        for thread in self.threads:
            thread.join()
