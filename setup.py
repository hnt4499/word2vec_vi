from setuptools import setup, find_packages
from setuptools.extension import Extension

from Cython.Build import cythonize

ext_modules = [
    Extension("word2vec_vi.utils.multiprocessing_utils",
              sources=["word2vec_vi/utils/multiprocessing_utils.pyx"],
              ),
    Extension("word2vec_vi.utils.text_utils",
              sources=["word2vec_vi/utils/text_utils.pyx"],
              ),
    Extension("word2vec_vi.process.process",
              sources=["word2vec_vi/process/process.pyx"],
              )
]

setup(name="word2vec_vi",
      packages=find_packages(),
      ext_modules=cythonize(ext_modules),
      )
