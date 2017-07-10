;;; Luigi iris demo

;;; Commentary:

;; This is a simple demonstration that shows off how to create
;; a very basic data pipeline using Luigi

;;; Code:

(require 'demo-it)


;; ----------------------------------------------------------------------
;; Demonstration creation and the ordering of steps...

(demo-it-create :full-screen :single-window :insert-fast :variable-width
                (demo-it-title-screen "luigi-demo-title.org")
                (demo-it-presentation "luigi-demo.org")
                ;;luigi-demo/show-pipeline
                luigi-demo/show-irispipeline
                luigi-demo/show-trainmodel-requires
                luigi-demo/show-trainmodel-output
                luigi-demo/show-trainmodel-run
                luigi-demo/show-traintestsplit
                luigi-demo/show-traintestsplit-run
                luigi-demo/show-irisdata
                (demo-it-presentation-return)
                (demo-it-start-eshell)
                luigi-demo/show-models
                luigi-demo/show-output
                luigi-demo/run-pipeline
                luigi-demo/show-models
                luigi-demo/show-output
                luigi-demo/run-pipeline
                )



;; ----------------------------------------------------------------------
;;  Create some demonstration helper functions...


(defun luigi-demo/show-pipeline ()
  (ignore-errors
    (kill-buffer "iris.py"))
  (demo-it-load-file "iris.py" :side)
  )

(defun luigi-demo/show-irispipeline ()
  (demo-it-presentation-return)
  (ignore-errors
    (kill-buffer "iris.py"))
  (demo-it-load-part-file "iris.py" :line 103 108 :side)
  )

(defun luigi-demo/show-trainmodel ()
  (demo-it-presentation-return)
  (ignore-errors
    (kill-buffer "iris.py"))
  (demo-it-load-part-file "iris.py" :line 69 101 :side)
  )

(defun luigi-demo/show-trainmodel-requires ()
  (demo-it-presentation-return)
  (ignore-errors
    (kill-buffer "iris.py"))
  (demo-it-load-part-file "iris.py" :line 69 73 :side)
  )

(defun luigi-demo/show-trainmodel-output ()
  (demo-it-presentation-return-noadvance)
  (ignore-errors
    (kill-buffer "iris.py"))
  (demo-it-load-part-file "iris.py" :line 75 79 :side)
  )

(defun luigi-demo/show-trainmodel-run ()
  (demo-it-presentation-return-noadvance)
  (ignore-errors
    (kill-buffer "iris.py"))
  (demo-it-load-part-file "iris.py" :line 81 101 :side)
  )

(defun luigi-demo/show-traintestsplit ()
  (demo-it-presentation-return)
  (ignore-errors
    (kill-buffer "iris.py"))
  (demo-it-load-part-file "iris.py" :line 28 39 :side)
  )

(defun luigi-demo/show-traintestsplit-run ()
  (demo-it-presentation-return-noadvance)
  (ignore-errors
    (kill-buffer "iris.py"))
  (demo-it-load-part-file "iris.py" :line 40 67 :side)
  )

(defun luigi-demo/show-irisdata ()
  (demo-it-presentation-return)
  (ignore-errors
    (kill-buffer "iris.py"))
  (demo-it-load-part-file "iris.py" :line 24 27 :side)
  )

(defun luigi-demo/run-pipeline ()
  ;;(demo-it-presentation-return-noadvance)
  (pyenv-mode-set "3.6.1/envs/dsapp")
  (demo-it-run-in-eshell "python iris.py")
  (pyenv-mode-unset)
  )

(defun luigi-demo/show-output ()
  (demo-it-run-in-eshell "tree data")
  )

(defun luigi-demo/show-models ()
  (demo-it-run-in-eshell "tree models")
  )

(defun luigi-demo/clean-up ()
  (interactive)
  (ignore-errors
    (kill-buffer "Shell"))
  (ignore-errors
    (kill-buffer "iris.py"))
  )

(luigi-demo/clean-up)

(demo-it-start)
