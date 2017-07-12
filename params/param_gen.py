import json
import uuid
import pickle

import os

def parse_params():
    with open("/pfs/params/clfs.json") as f:
        params = json.load(f)

    for param in params:
        print(param)
        algorithm = param['id']
        for hp in param['hyperparams']:
            print(hp)
            hp_str = "_".join([f"{k}_{v}" for k,v in hp.items()])
            output_file = f"{algorithm}_{hp_str}.pkl"
            print(output_file)
            with open(os.path.join('/pfs/out/', output_file), 'wb') as handle:
                pickle.dump(param, handle)

if __name__ == "__main__":
    parse_params()
