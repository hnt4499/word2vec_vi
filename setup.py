from distutils.core import setup
from Cython.Build import cythonize

setup(name="word2vec_vi",
      packages=["word2vec_vi", "word2vec_vi.utils",
                ],
      ext_modules=cythonize("**/*.pyx"),
      )
