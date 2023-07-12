(ns user
  (:require [libpython-clj2.require :refer [require-python]]
            [libpython-clj2.python :as py :refer [py. py.. py.-]]
            [libpython-clj2.python.np-array :as np-array]))



;; If properly set up, this should include the conda env path in Dockerfile: `/usr/local/envs/pyclj`
(require '[clojure.java.shell :as sh])
(println (:out (sh/sh "python3-config" "--prefix")))

;; Should also match here:
(System/getenv "LD_LIBRARY_PATH")

;; Initialize the python environment (technically don't have to do this explicitly, but whatevs)
(py/initialize!)

;; Demonstrate some basic standard library functionality
(require-python 'math)
(math/cos math/pi)

;; Require and test external library
(require-python '[numpy :as np])
(def test-ary (np/array [[1 2] [3 4]]))
(np/multiply 3 test-ary)

;; Require some more libraries...
(require-python '[sklearn.datasets :as sk-data])
(require-python '[sklearn.model_selection :as sk-model])
(require-python '[sklearn.decomposition :as sk-decomp])

