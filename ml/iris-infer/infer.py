import pandas as pd

from sklearn.externals import joblib

import os

import click

@click.command()
@click.argument('model_dir')
@click.argument('input_dir')
@click.argument('output_dir')
def infer(model_dir, input_dir, output_dir):
    # attribute column names
    features = [
        "Sepal_Length",
        "Sepal_Width",
        "Petal_Length",
        "Petal_Width"
    ]

    # load the model
    model = joblib.load(os.path.join(model_dir, 'model.pkl'))

    # walk the input attributes directory and make an
    # inference for every attributes file found
    print("Input dir:", input_dir)
    print("Output dir:", output_dir)

    for dirpath, dirs, files in os.walk(input_dir):
        for file in files:
            print("Processing file:" , file)
            # read in the attributes
            attr = pd.read_csv(os.path.join(dirpath, file), names=features)

            # make the inference
            pred = model.predict(attr)

            # save the inference
            output = pd.DataFrame(pred, columns=["Species"])
            print("The inferences will be located at:", os.path.join(output_dir, file))
            output.to_csv(os.path.join(output_dir, file), header=False, index=False)


if __name__ == "__main__":
    infer()
