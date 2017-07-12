;;; Pachyderm iris demo

;;; Commentary:

;; This is a simple demonstration that shows off how to create
;; a very basic data pipeline using Pachyderm

;;; Code:

(require 'demo-it)


;; ----------------------------------------------------------------------
;; Demonstration creation and the ordering of steps...

(demo-it-create :full-screen :single-window :insert-fast :advance-mode :variable-width
                (demo-it-title-screen "pachyderm-demo.org")
                ;;(demo-it-presentation "pachyderm-demo.org")
                ;;(demo-it-show-image "images/data-centric-pipeline.png" :below :large 30)
                ;;(demo-it-presentation-return)
                ;;(demo-it-show-image "images/screenshot-20170705-110839.png" :below :large 30)
                ;;(demo-it-presentation-return-noadvance)
                (demo-it-start-shell nil nil nil :below :large 30)
                (demo-it-run-in-shell "pachctl delete-all")
                (demo-it-run-in-shell "pachctl list-repo")
                ;; Let's create the repos
                ;;(demo-it-presentation-advance)
                (demo-it-run-in-shell "pachctl create-repo training")
                (demo-it-run-in-shell "pachctl create-repo attributes")
                (demo-it-run-in-shell "pachctl list-repo")
                ;; Let's create the pipelines
                ;;(demo-it-presentation-advance)
                (demo-it-run-in-shell "pachctl create-pipeline -f pipelines/train.json") ;; At this moment nothing happens, since we don't have commits in the repo
                (demo-it-run-in-shell "pachctl create-pipeline -f pipelines/infer.json")
                (demo-it-run-in-shell "pachctl list-pipeline")
                (demo-it-run-in-shell "pachctl list-job")
                ;; Now we could add more data
                (demo-it-run-in-shell "pachctl put-file training master iris.csv -c -f data/iris.csv")
                (demo-it-run-in-shell "pachctl list-job")
                (demo-it-run-in-shell "pachctl list-repo")
                (demo-it-run-in-shell "pachctl list-file training master")
                (demo-it-run-in-shell "pachctl list-file model master")
                (demo-it-run-in-shell "pachctl get-file model master model.txt")
                ;;(demo-it-presentation-advance)
                ;; Let's do inference
                (demo-it-run-in-shell "pachctl put-file attributes master / -c -r -f data/test") ;; this will trigger the infer pipeline
                ;;                                      repo       branch path flags file
                (demo-it-run-in-shell "pachctl list-job")
                (demo-it-run-in-shell "pachctl list-file inference master")
                (demo-it-run-in-shell "pachctl get-file inference master 1.csv")
                (demo-it-run-in-shell "pachctl get-file inference master 2.csv")
                ;; Let's change our model to a SVC
                ;;(demo-it-presentation-advance)
                (demo-it-load-file "pipelines/train.json" :side :small 40)
                ;;(demo-it-presentation-return-noadvance)
                (demo-it-run-in-shell "pachctl update-pipeline -f pipelines/train.json")
                (demo-it-run-in-shell "pachctl list-job")
                (demo-it-run-in-shell "pachctl list-file inference master")
                (demo-it-run-in-shell "pachctl get-file model master model.txt")
                (demo-it-run-in-shell "pachctl list-commit inference")
                ;; Trace
                ;; pachctl list-job
                ;; pachctl list-repo
                ;; pachctl list-commit inference
                ;; pachctl inspect-commit inference 781241155cf44351b6a3eb7059c8ee9e
                ;; pachctl get-file model 98f85e48160742e7b6d7aa1ea41872cd
                ;; pachctl get-file model 98f85e48160742e7b6d7aa1ea41872cd model.txt
                ;; Now, some hyperparameter tunning
                ;;(demo-it-presentation-advance)
                (demo-it-run-in-shell "pachctl delete-all")
                (demo-it-run-in-shell "pachctl  create-repo training")
                (demo-it-run-in-shell "pachctl  create-repo params")
                (demo-it-run-in-shell "pachctl create-pipeline -f pipelines/param_gen.json")
                (demo-it-presentation-advance)
                (demo-it-load-file "pipelines/train.json" :side :small 40)
                (demo-it-presentation-return-noadvance)
                (demo-it-run-in-shell  "pachctl create-pipeline -f pipelines/model_training.json")
                (demo-it-run-in-shell  "pachctl list-repo")
                (demo-it-run-in-shell  "pachctl put-file training master iris.csv -c -f data/iris.csv")
                (demo-it-run-in-shell  "pachctl list-repo")
                (demo-it-run-in-shell  "pachctl put-file params master clfs.json -c -f params/clfs.json")
                (demo-it-run-in-shell  "pachctl list-job")
                (demo-it-run-in-shell  "pachctl list-repo")
                (demo-it-run-in-shell  "pachctl get-logs --pipeline train_models")
                (demo-it-run-in-shell  "pachctl get-logs --pipeline params_gen")
                (demo-it-run-in-shell  "pachctl list-file train_models master")
                )
;; ----------------------------------------------------------------------
;;  Create some demonstration helper functions...


(defun pachyderm-demo/show-pipeline ()
  (ignore-errors
    (kill-buffer "iris.py"))
  (demo-it-load-file "iris.py" :side)
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
