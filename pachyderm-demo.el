;;; Pachyderm iris demo

;;; Commentary:

;; This is a simple demonstration that shows off how to create
;; a very basic data pipeline using Pachyderm

;;; Code:

(require 'demo-it)


;; ----------------------------------------------------------------------
;; Demonstration creation and the ordering of steps...

(demo-it-create :full-screen :single-window :insert-fast :advance-mode :variable-width
                (demo-it-start-shell nil nil nil :below :large 30)
                (demo-it-run-in-shell "pachctl delete-all")
                (demo-it-run-in-shell "pachctl list-repo")
                ;; Let's create the repos
                (demo-it-run-in-shell "pachctl create-repo training")
                (demo-it-run-in-shell "pachctl create-repo attributes")
                (demo-it-run-in-shell "pachctl list-repo")
                ;; Let's create the pipelines
                (demo-it-run-in-shell "pachctl create-pipeline -f pipelines/lda_train.json") ;; At this moment nothing happens, since we don't have commits in the repo
                (demo-it-run-in-shell "pachctl create-pipeline -f pipelines/lda_infer.json")
                (demo-it-run-in-shell "pachctl list-pipeline")
                (demo-it-run-in-shell "pachctl list-job")
                ;; Now we could add more data
                (demo-it-run-in-shell "pachctl put-file training master iris.csv -c -f data/iris.csv")
                (demo-it-run-in-shell "pachctl list-job")
                (demo-it-run-in-shell "pachctl list-repo")
                (demo-it-run-in-shell "pachctl list-file training master")
                (demo-it-run-in-shell "pachctl list-file model master")
                ;; Let's do inference
                (demo-it-run-in-shell "pachctl put-file attributes master / -c -r -f data/test") ;; this will trigger the infer pipeline
                ;;                                      repo       branch path flags file
                (demo-it-run-in-shell "pachctl list-job")

                ;;(demo-it-run-in-shell "tree data") ;; This data is outside the repo
                )
;; ----------------------------------------------------------------------
;;  Create some demonstration helper functions...


(defun pachyderm-demo/show-pipeline ()
  (ignore-errors
    (kill-buffer "iris.py"))
  (demo-it-load-file "iris.py" :side)
  )

(defun pachyderm-demo/show-irispipeline ()
  (demo-it-presentation-return)
  (ignore-errors
    (kill-buffer "iris.py"))
  (demo-it-load-part-file "iris.py" :line 103 108 :side)
  )

(defun pachyderm-demo/show-trainmodel ()
  (demo-it-presentation-return)
  (ignore-errors
    (kill-buffer "iris.py"))
  (demo-it-load-part-file "iris.py" :line 69 101 :side)
  )

(defun pachyderm-demo/show-trainmodel-requires ()
  (demo-it-presentation-return)
  (ignore-errors
    (kill-buffer "iris.py"))
  (demo-it-load-part-file "iris.py" :line 69 73 :side)
  )

(defun pachyderm-demo/show-trainmodel-output ()
  (demo-it-presentation-return-noadvance)
  (ignore-errors
    (kill-buffer "iris.py"))
  (demo-it-load-part-file "iris.py" :line 75 79 :side)
  )

(defun pachyderm-demo/show-trainmodel-run ()
  (demo-it-presentation-return-noadvance)
  (ignore-errors
    (kill-buffer "iris.py"))
  (demo-it-load-part-file "iris.py" :line 81 101 :side)
  )

(defun pachyderm-demo/show-traintestsplit ()
  (demo-it-presentation-return)
  (ignore-errors
    (kill-buffer "iris.py"))
  (demo-it-load-part-file "iris.py" :line 28 39 :side)
  )

(defun pachyderm-demo/show-traintestsplit-run ()
  (demo-it-presentation-return-noadvance)
  (ignore-errors
    (kill-buffer "iris.py"))
  (demo-it-load-part-file "iris.py" :line 40 67 :side)
  )

(defun pachyderm-demo/show-irisdata ()
  (demo-it-presentation-return)
  (ignore-errors
    (kill-buffer "iris.py"))
  (demo-it-load-part-file "iris.py" :line 24 27 :side)
  )

(defun pachyderm-demo/run-pipeline ()
  ;;(demo-it-presentation-return-noadvance)
  (pyenv-mode-set "3.6.1/envs/dsapp")
  (demo-it-run-in-shell "python iris.py")
  (pyenv-mode-unset)
  )

(defun pachyderm-demo/show-output ()
  (demo-it-run-in-shell "tree data")
  )

(defun pachyderm-demo/show-models ()
  (demo-it-run-in-shell "tree models")
  )

(defun pachyderm-demo/clean-up ()
  (interactive)
  (ignore-errors
    (kill-buffer "Shell"))
  (ignore-errors
    (kill-buffer "iris.py"))
  )

(pachyderm-demo/clean-up)

(demo-it-start)
