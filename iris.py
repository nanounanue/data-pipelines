# coding: utf-8
# This Pipeline is a simple example
import sys

import luigi

import pandas as pd

from sklearn.model_selection import train_test_split


from sklearn.externals import joblib

from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier

from sklearn.preprocessing import LabelEncoder
from sklearn.preprocessing import MinMaxScaler
from sklearn.preprocessing import StandardScaler
from sklearn.svm import SVC

from sklearn.pipeline import make_pipeline

class IrisData(luigi.ExternalTask):
    def output(self):
        return luigi.LocalTarget("./data/iris.csv")

class TrainTestSplit(luigi.Task):
    def requires(self):
        return IrisData()

    def output(self):
        return {
            'X_train': luigi.LocalTarget("./data/X_train.csv"),
            'X_test': luigi.LocalTarget("./data/X_test.csv"),
            'y_train': luigi.LocalTarget("./data/y_train.csv"),
            'y_test': luigi.LocalTarget("./data/y_test.csv")
        }

    def run(self):
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

        iris_df = pd.read_csv(self.input().path, names=cols)

        X = iris_df[features]
        y = iris_df["Species"]

        X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=1234)

        X_train.to_csv(self.output()['X_train'].path, index = False, header = True)
        X_test.to_csv(self.output()['X_test'].path, index = False, header = True)
        y_train.to_csv(self.output()['y_train'].path, index = False, header = True)
        y_test.to_csv(self.output()['y_test'].path, index = False, header = True)


class TrainModel(luigi.Task):
    algorithm = luigi.Parameter()

    def requires(self):
        return TrainTestSplit()

    def output(self):
        return {
            'model': luigi.LocalTarget("./models/" + self.algorithm + "_model.pkl"),
            'metadata': luigi.LocalTarget("./models/" + self.algorithm + "_metadata.txt")
        }

    def run(self):
        X_train = pd.read_csv(self.input()['X_train'].path)
        y_train = pd.read_csv(self.input()['y_train'].path)

        if self.algorithm == 'SVC':
            model = SVC(kernel='linear', C=1.0)
        elif self.algorithm == 'RF':
            model = RandomForestClassifier()
        else:
            lr = LogisticRegression(solver='newton-cg',
                                    multi_class='multinomial',
                                    random_state=1)

            model = make_pipeline(StandardScaler(), lr)

        model.fit(X_train, y_train)

        joblib.dump(model, self.output()['model'].path)

        with self.output()['metadata'].open('w') as meta:
            meta.write(str(model))

class IrisPipeline(luigi.WrapperTask):
    def requires(self):
        yield TrainModel(algorithm='SVC')
        yield TrainModel(algorithm='RF')
        yield TrainModel(algorithm='LR')

if __name__ == "__main__":
    luigi_args = ['IrisPipeline',
                  '--local-scheduler',
                  '--workers', '4']
    luigi.run(luigi_args)
