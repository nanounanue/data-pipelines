import pandas as pd
from sklearn.ensemble import RandomForestClassifier, ExtraTreesClassifier
from sklearn.externals import joblib
import click

import os

import importlib

import pickle

@click.command()
@click.argument('param_dir')
@click.argument('training_dir')
@click.argument('output_dir')
def train(param_dir, training_dir, output_dir):
    cols = [
        "Sepal_Length",
        "Sepal_Width",
        "Petal_Length",
        "Petal_Width",
        "Species"
    ]

    features = [
        "Sepal_Length",
        "Sepal_Width",
        "Petal_Length",
        "Petal_Width"
    ]

    ## Importing the training data set
    iris_df = pd.read_csv(os.path.join(training_dir, "iris.csv"), names=cols)

    ## Getting the params

    # List the files this container has access to.
    param_files = [f for f in os.listdir(param_dir) if os.path.isfile(os.path.join(param_dir, f))]

    print(param_files)

    for param_file in param_files:

        print(param_file)

        with open(os.path.join(param_dir, param_file), 'rb') as handle:
            params = pickle.load(handle)

        algorithm_class = params['name']
        hyperparams = params['hyperparams'][0]

        ## Create the estimator
        module_name, class_name = algorithm_class.rsplit(".", 1)
        Clf = getattr(importlib.import_module(module_name), class_name)
        clf = Clf()
        clf.set_params(**hyperparams)

        ## Fit the model
        clf = clf.fit(iris_df[features], iris_df["Species"])

        # output a text description of the model
        f = open(os.path.join(output_dir, os.path.splitext(param_file)[0] + '_metadata.txt'), 'w')
        f.write(str(clf))
        f.close()

        # persist the model
        joblib.dump(clf, os.path.join(output_dir, param_file))


if __name__ == "__main__":
    train()
