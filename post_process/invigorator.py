import sys
import pandas as pd
import re
from urllib.parse import unquote

ROWS_PER_CHUNK = 10000
logfile = "/home/ab/work/thousand_clients/origin_logs/out_clean_large.log"

def invig(x):
    #x[5] ... "5" is the column label written by usecols=[0,5]
    try:
        cmcds = re.search(r'CMCD=(.*) ', x[5]).group(1)
    except AttributeError:
        print("ALB: no match for 'CMCD'")
        return
    cmcds = unquote(cmcds)
    A = cmcds.split(',')
    D = {}
    for B in A:
        try:
            k, v = B.split('=')
        except ValueError:
            k = B
            v = True
        D[k] = v

    return pd.Series({'ip': x[0], **D})


def get_data():
    F = pd.DataFrame()
    reader = pd.read_table(logfile, sep=" ", header=None, engine="c", usecols=[0,5], chunksize=ROWS_PER_CHUNK, iterator=True)
    i = 1
    for data_chunk in reader:
         processed_chunk = data_chunk.apply(invig, axis=1)
         F = pd.concat([F, processed_chunk])
         print('line {}'.format(i*ROWS_PER_CHUNK))
         i = i+1

    return F


if __name__ == '__main__':

    if sys.argv[1] == 'get_data':
        F = get_data()








