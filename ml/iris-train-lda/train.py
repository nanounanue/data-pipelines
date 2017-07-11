import pandas as pd
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
from sklearn.externals import joblib
import click
import os



@click.command()
@click.argument('input_dir')
@click.argument('output_dir')
def train(input_dir, output_dir):
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
    iris_df = pd.read_csv(os.path.join(input_dir, "iris.csv"), names=cols)

    ## Fit the model
    lda = LinearDiscriminantAnalysis().fit(iris_df[features], iris_df["Species"])

    # output a text description of the model
    f = open(os.path.join(output_dir, 'model.txt'), 'w')
    f.write(str(lda))
    f.close()

    # persist the model
    joblib.dump(lda, os.path.join(output_dir, 'model.pkl'))


if __name__ == "__main__":
    train()
